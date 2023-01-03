import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AdminOrderDetail extends StatefulWidget {
  const AdminOrderDetail({Key? key, required this.order}) : super(key: key);
  final Map<String, dynamic> order;
  @override
  State<AdminOrderDetail> createState() => _AdminOrderDetailState();
}

class _AdminOrderDetailState extends State<AdminOrderDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderInfo(),
                const SizedBox(height: 8.0),
                _buildCustomerInfo(),
                const SizedBox(height: 8.0),
                _buildItemList(),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.white,
                  child: Row(
                    children: [
                      const Text(
                        'Total price:',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        NumberFormat.currency(locale: 'vi')
                            .format(widget.order['totalPrice']),
                        style: const TextStyle(
                            fontSize: 16.0, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child:
                _buildStatusBtn(widget.order['billId'], widget.order['status']),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.receipt_outlined,
            color: Colors.indigo,
            size: 20,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order: ${widget.order['billId']}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Date: ${widget.order['createdAt']}',
                  style: const TextStyle(fontSize: 12.0, color: Colors.black54),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Status: ${widget.order['status'] ? 'Done' : 'Pending'}',
                  style: const TextStyle(fontSize: 12.0, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> _buildCustomerInfo() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.order['uid'])
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.hasData && snapshot.data != null) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.person_pin_circle_outlined,
                    color: Colors.indigo,
                    size: 20,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Customer Info',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Name: ${snapshot.data['name']}',
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Phone:  ${snapshot.data['phone']}',
                          style: const TextStyle(
                              fontSize: 12.0, color: Colors.black54),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Address:  ${widget.order['address']}',
                          style: const TextStyle(
                              fontSize: 12.0, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Widget _buildItemList() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Item List',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const Divider(thickness: 1.0),
          Column(
            children: widget.order['item'].map<Widget>(_buildItem).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              'x ${item['quantity'].toString()}',
              style: const TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              item['title'],
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            NumberFormat.currency(locale: 'vi').format(item['itemSubTotal']),
            maxLines: 1,
            style:
                const TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBtn(String id, bool status) {
    return status
        ? Container(
            margin: const EdgeInsets.only(top: 16),
            width: double.infinity,
            height: 45,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.zero, color: Colors.red),
            child: TextButton(
              onPressed: () async {
                final confirmed = await confirm(
                  context,
                  title: const Text('Confirm'),
                  content: Text('This will delete the order, are you sure?'),
                  textOK: const Text('Yes'),
                  textCancel: const Text('Cancel'),
                );
                if (confirmed) {
                  deleteOrder(id);
                  Fluttertoast.showToast(
                      msg: "Order deleted",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 14.0);
                  Navigator.pop(context);
                }
                print('pressedCancel');
              },
              child: Text(
                'Delete Order'.toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
        : Container(
            margin: const EdgeInsets.only(top: 16),
            width: double.infinity,
            height: 45,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.zero, color: Colors.green),
            child: TextButton(
              onPressed: () {
                updateStatus(id, status);
                Fluttertoast.showToast(
                    msg: "Order completed",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    fontSize: 14.0);
                Navigator.pop(context);
              },
              child: Text(
                'Complete'.toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
  }

  Future updateStatus(String id, bool status) async {
    final docOrder = FirebaseFirestore.instance.collection('bills').doc(id);
    await docOrder.update({
      'status': true,
    });
  }

  Future deleteOrder(String id) async {
    final docOrder = FirebaseFirestore.instance.collection('bills').doc(id);
    await docOrder.delete();
  }
}
