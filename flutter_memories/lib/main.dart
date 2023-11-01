import 'package:flutter/material.dart';
import 'package:flutter_memories_dailyjournal/pages/set_diary_lock.dart';
import 'package:flutter_memories_dailyjournal/pages/setting_page.dart';
import 'package:flutter_memories_dailyjournal/theme/theme.dart';
import 'package:flutter_memories_dailyjournal/theme/theme_manager.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'models/diary.dart';
import 'pages/change_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(DiaryAdapter());
  SharedPreferences.getInstance().then((pref) {
    var themeColor = pref.getInt('ThemeMode');
    if (themeColor == null) {
      activeTheme = lightTheme;
    } else if (themeColor == 1) {
      activeTheme = darkTheme;
    } else if (themeColor == 0) {
      activeTheme = lightTheme;
    }
  });
  runApp(EasyLocalization(
    supportedLocales: const [
      Locale('en', 'US'),
      Locale('vi'),
    ],
    path: 'assets/translations',
    saveLocale: true,
    fallbackLocale: const Locale('en', 'US'),
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeNotifier(activeTheme!))
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: themeNotifier.getTheme,
      title: 'Memories - Daily Jounnal',
      routes: {
        '/': (context) => FutureBuilder(
              future: Hive.openBox('diaries'),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return const ChangePage();
                  }
                } else {
                  return const Scaffold();
                }
              },
            ),
        'setting-page': (context) => const SettingPage(),
        'set-lock': (context) => const SetDiaryLock(),
      },
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
