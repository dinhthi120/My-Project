import 'package:flutter/material.dart';
import 'package:snack_restaurant/views/fragments/admin/item_page.dart';
import 'package:snack_restaurant/views/fragments/auth/change_password.dart';
import 'package:snack_restaurant/views/fragments/auth/login_page.dart';
import 'package:snack_restaurant/views/fragments/my_order.dart';
import 'package:snack_restaurant/views/fragments/auth/signup_page.dart';
import 'fragments/home_page.dart';
import 'fragments/admin/order_page.dart';
import 'routes/page_route.dart';

class SnackApp extends StatelessWidget {
  const SnackApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snack App',
      theme: ThemeData(
        // This is the theme of application.
        primarySwatch: Colors.indigo,
      ),
      home: const HomePage(),
      routes: {
        PageRoutes.home: (context) => HomePage(),
        PageRoutes.item: (context) => ItemPage(),
        PageRoutes.order: (context) => OrderPage(),
        PageRoutes.login: (context) => LoginPage(),
        PageRoutes.signUp: (context) => SignUpPage(),
        PageRoutes.changePassword: (context) => ChangePassword(),
        PageRoutes.userOrders: (context) => UserOrders(),
      },
    );
  }
}
