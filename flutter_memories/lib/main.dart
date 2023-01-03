import 'package:flutter/material.dart';
import 'package:flutter_memories_dailyjournal/pages/passcode_page.dart';
import 'package:flutter_memories_dailyjournal/pages/security_question.dart';
import 'package:flutter_memories_dailyjournal/pages/set_diary_lock.dart';
import 'package:flutter_memories_dailyjournal/pages/setting_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memories - Daily Jounnal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const HomePage(),
      routes: {
        '/': (context) => HomePage(),
        'setting-page': (context) => SettingPage(),
        'passcode-page':(context) => PasscodePage(),
        'question-page': (context) => SecurityQuestion(),
        'set-lock':(context) => SetDiaryLock(),
      },
    );
  }
}
