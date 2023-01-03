import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:snack_restaurant/views/fragments/admin/admin_order_detail.dart';
import 'package:snack_restaurant/views/navigation_drawer.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);
  static const String routeName = '/ordersPage';

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: NavigationDrawer(),
        appBar: AppBar(
          title: const Text('Manage Orders'),
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'PENDING'),
              Tab(text: 'DONE'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPendingOrders(),
            _buildDoneOrders(),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingOrders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          padding: const EdgeInsets.all(12.0),
          child: const Text(
            "Pending order",
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: readOrders(false),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            }
            if (snapshot.hasData) {
              final bills = snapshot.data!;
              return Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: bills.map(_buildItem).toList(),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }

  Widget _buildDoneOrders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8.0),
          padding: const EdgeInsets.all(12.0),
          child: const Text(
            "Completed order",
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ),
        StreamBuilder<List<Map<String, dynamic>>>(
          stream: readOrders(true),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            }
            if (snapshot.hasData) {
              final bills = snapshot.data!;
              return Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: bills.map(_buildItem).toList(),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
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
            MaterialPageRoute(
                builder: (context) => AdminOrderDetail(order: order)),
          );
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${order['createdAt']}',
                    style:
                        const TextStyle(fontSize: 12.0, color: Colors.black87),
                  ),
                  const SizedBox(height: 4.0),
                  Text('Order: ${order['billId']}'),
                  const SizedBox(height: 8.0),
                  Text(
                    'Price: ${NumberFormat.currency(locale: 'vi').format(order['totalPrice'])}',
                    style:
                        const TextStyle(fontSize: 12.0, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Stream<List<Map<String, dynamic>>> readOrders(bool status) {
    final orders = FirebaseFirestore.instance
        .collection('bills')
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

    return orders;
  }
}
