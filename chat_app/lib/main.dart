import 'package:chat_app/views/pages/add_friend_page.dart';
import 'package:chat_app/views/pages/user_info_page.dart';
import 'package:chat_app/views/pages/change_pass_page.dart';
import 'package:chat_app/views/pages/edit_page.dart';
import 'package:chat_app/views/pages/home_page.dart';
import 'package:chat_app/views/bottom_tabs/chat_tab.dart';
import 'package:chat_app/views/auth/login_page.dart';
import 'package:chat_app/views/auth/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/': (context) => HomeScreen(),
        'login': (context) => LoginPage(),
        'sign-up': (context) => SignUpPage(),
        'chat-tab': (context) => ChatTab(),
        'user-info': (context) => UserInfoPage(),
        'edit-page': (context) => EditPage(),
        'change-pass-page': (context) => ChangePassPage(),
        'add-friend': (context) => AddFriendPage(),
      },
      initialRoute: '/',
    );
  }
}
