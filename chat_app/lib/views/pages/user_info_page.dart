import 'package:chat_app/controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';

class UserInfoPage extends StatelessWidget {
  static const route = 'user-info';

  UserInfoPage({Key? key}) : super(key: key);
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          centerTitle: true,
          title: const Text('Thông tin của bạn'),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.greenAccent[400],
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('edit-page');
                },
                icon: const Icon(Icons.edit_outlined)),
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('change-pass-page');
                },
                icon: const Icon(Icons.password_outlined)),
          ],
        ),
        backgroundColor: Colors.grey[200],
        body: FutureBuilder<Users?>(
            future: UserController().readUser(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong! ${snapshot.error}');
              }
              if (snapshot.hasData) {
                final user = snapshot.data;
                return Column(
                  children: [
                    buildItem(context, 'Tên của bạn', user.name),
                    buildItem(context, 'Số điện thoại', user.phone),
                    buildItem(context, 'Email', user.email),
                    const Spacer(),
                    logoutButton(context),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  Widget buildItem(context, title, info) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(top: 2),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text(
                info,
                textAlign: TextAlign.right,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget logoutButton(context) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(40),
      ),
      child: TextButton(
        child: const Text(
          'Đăng xuất',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        onPressed: () {
          if (auth.currentUser!.email != null) {
            AuthController().logOut();
            Navigator.pushReplacementNamed((context), 'login');
          } else {
            if (kDebugMode) {
              print('Đăng xuất không thành công');
            }
          }
        },
      ),
    );
  }
}
