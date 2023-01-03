import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snack_restaurant/views/navigation_drawer.dart';

import 'order_detail.dart';

class UserOrders extends StatefulWidget {
  const UserOrders({Key? key}) : super(key: key);
  static const String routeName = '/userOrders';

  @override
  State<UserOrders> createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: readBills(false),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          }
          if (snapshot.hasData) {
            final orders = snapshot.data!;
            return ListView(
              physics: const BouncingScrollPhysics(),
              children: orders.map(_buildItem).toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildItem(Map<String, dynamic> order) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderDetail(order: order)),
          );
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      order['status'] == true
                          ? Icon(
                              Icons.check_circle,
                              size: 14,
                              color: Colors.grey[600],
                            )
                          : Icon(
                              Icons.remove_circle_outlined,
                              size: 14,
                              color: Colors.green,
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: order['status'] == true
                            ? Text(
                                'Done',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              )
                            : Text(
                                'Pendding',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12),
                              ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Date: ${order['createdAt']}',
                    style: TextStyle(fontSize: 12.0, color: Colors.black87),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    '${order['address']}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Price: ${NumberFormat.currency(locale: 'vi').format(order['totalPrice'])}',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Stream<List<Map<String, dynamic>>> readBills(bool status) {
    final auth = FirebaseAuth.instance.currentUser!.uid;
    final bills = FirebaseFirestore.instance
        .collection('bills')
        .where('uid', isEqualTo: auth.toString())
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

    return bills;
  }
}
