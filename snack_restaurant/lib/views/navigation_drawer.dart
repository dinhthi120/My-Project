import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snack_restaurant/views/fragments/auth/login_page.dart';
import 'package:snack_restaurant/views/fragments/auth/profile.dart';
import '../controllers/handle_cart.dart';
import '../controllers/handle_logout.dart';
import 'routes/page_route.dart';

class NavigationDrawer extends StatelessWidget {
  NavigationDrawer({Key? key}) : super(key: key);
  final auth = FirebaseAuth.instance;
  final CartController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(context),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.indigo),
            title: const Text('Home', style: TextStyle(fontSize: 16.0)),
            onTap: () {
              Navigator.pushReplacementNamed(context, PageRoutes.home);
            },
          ),
          if (auth.currentUser != null)
            ListTile(
              leading: const Icon(Icons.shopping_cart_outlined,
                  color: Colors.indigo),
              title: const Text('My Orders', style: TextStyle(fontSize: 16.0)),
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, PageRoutes.userOrders);
              },
            ),
          if (auth.currentUser != null)
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Container();
                }
                if (snapshot.hasData && snapshot.data != null) {
                  if (snapshot.data['role'] == 'admin') {
                    return ListTile(
                      leading: const Icon(Icons.food_bank_rounded,
                          color: Colors.indigo),
                      title: const Text('Manage Items',
                          style: TextStyle(fontSize: 16.0)),
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, PageRoutes.item);
                      },
                    );
                  } else {
                    return Container();
                  }
                }
                return Container();
              },
            ),
          if (auth.currentUser != null)
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(auth.currentUser!.uid)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Container();
                }
                if (snapshot.hasData && snapshot.data != null) {
                  if (snapshot.data['role'] == 'admin') {
                    return ListTile(
                      leading: const Icon(Icons.list_alt_rounded,
                          color: Colors.indigo),
                      title: const Text('Manage Order',
                          style: TextStyle(fontSize: 16.0)),
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, PageRoutes.order);
                      },
                    );
                  } else {
                    return Container();
                  }
                }
                return Container();
              },
            ),
          const Divider(thickness: 1.5),
          if (auth.currentUser != null)
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.red),
              title: const Text('Log out', style: TextStyle(fontSize: 16.0)),
              onTap: () {
                if (auth.currentUser!.email != null) {
                  HandleLogout().logOut();
                  Navigator.pushReplacementNamed(context, PageRoutes.home);
                }
              },
            ),
        ], // Populate the Drawer in the next step.
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return SizedBox(
      height: 150.0,
      child: DrawerHeader(
        decoration: const BoxDecoration(
          color: Colors.indigo,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            TextButton(
              onPressed: () {
                if (auth.currentUser != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  auth.currentUser != null
                      ? Expanded(
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(auth.currentUser!.uid)
                                  .snapshots(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }
                                if (snapshot.hasData && snapshot.data != null) {
                                  return Text(
                                    '${snapshot.data['name']}',
                                    style: const TextStyle(
                                        fontSize: 22.0, color: Colors.white),
                                    overflow: TextOverflow.fade,
                                    softWrap: false,
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        )
                      : const Expanded(
                          child: Text(
                            'Guest',
                            style:
                                TextStyle(fontSize: 22.0, color: Colors.white),
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                        ),
                  const Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
