import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:snack_restaurant/models/user.dart';
import 'package:snack_restaurant/views/fragments/auth/edit_profile.dart';
import 'package:snack_restaurant/views/routes/page_route.dart';
import '../../../controllers/handle_cart.dart';
import '../../../controllers/handle_logout.dart';
import '../../../validate/validation.dart';

class ProfilePage extends StatefulWidget {
  static const route = '/main';

  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with CommonValidation {
  final auth = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.grey[200],
        body: Stack(
          children: [
            FutureBuilder<Users?>(
              future: readUser(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong! ${snapshot.error}');
                }
                if (snapshot.hasData) {
                  final user = snapshot.data;
                  return user == null? Center(child: Text('No User')): Column(
                    children: [
                      _listItem(user),
                      ChangePassword(),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: LogoutButton(),
            ),
          ],
        ));
  }

  Widget _listItem(Users user) {
    return Column(
      children: [
        BuildItem(title: 'Phone', subTitle: user.phone),
        BuildItem(title: 'Email', subTitle: user.email),
        BuildItem(title: 'Address', subTitle: user.address),
        BuildItem(title: 'Name', subTitle: user.name),
        editButton(user),
      ],
    );
  }

  Widget editButton(Users user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6, top: 6),
      width: double.infinity,
      height: 38,
      decoration:
      BoxDecoration(borderRadius: BorderRadius.zero, color: Colors.white),
      child: TextButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditProfile(
                  user: user,
                )),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Edit your profile'.toUpperCase(),
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 13),
            ),
            SizedBox(width: 8),
            Icon(Icons.edit_outlined, color: Colors.black, size: 20,),
          ],
        ),
      ),
    );
  }

  Future<Users?> readUser() async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(auth);
    final snapshot = await docUser.get();
    if (snapshot.exists) {
      return Users.fromJson(snapshot.data()!);
    }
  }
}

class BuildItem extends StatelessWidget {
  final String title;
  final String subTitle;

  const BuildItem({Key? key, required this.title, required this.subTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      color: Colors.white,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                subTitle,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChangePassword extends StatelessWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/change-password');
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1),
        padding: EdgeInsets.all(12),
        color: Colors.white,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Change password',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final CartController controller = Get.find();

  LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: double.infinity,
      height: 38,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.zero, color: Colors.red),
      child: TextButton(
        onPressed: () {
          if (auth.currentUser!.email != null) {
            controller.items.clear();
            HandleLogout().logOut();
            Navigator.popAndPushNamed(context, PageRoutes.home);
          } else {
            print('No way home');
          }
        },
        child: Text(
          'Log Out'.toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
