import 'package:chat_app/views/bottom_nav_bar.dart';
import 'package:chat_app/views/auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/';

  HomeScreen({Key? key}) : super(key: key);

  @override
  _NavigationBarState createState() => _NavigationBarState();
}
  final auth = FirebaseAuth.instance;

class _NavigationBarState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if(auth.currentUser == null)
            LoginPage(),
          if(auth.currentUser != null)
           BotNavigationBar(),
        ],
      ),
    );
  }
}

