import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/handle_cart.dart';
import '../../models/item.dart';
import '../../models/user.dart';
import '../routes/page_route.dart';
import 'change_delivery_address.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);
  static const String routeName = '/';

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final auth = FirebaseAuth.instance.currentUser!.uid;
  final CartController controller = Get.find();
  late final Item item;
  late final int index;

  String addressChange = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetch().then((user) {
      setState(() {
        addressChange = user["address"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          elevation: 1,
          title: const Text('Checkout'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                FutureBuilder<Users?>(
                  future: readUser(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if(snapshot.hasError){
                      return Text('Something went wrong! ${snapshot.error}');
                    }
                    if(snapshot.hasData) {
                      final user = snapshot.data!;
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1.0, color: Colors.grey.shade300))),
                        child: GestureDetector(
                          onTap: () async {
                            final finalAddress = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeDeliveryAddress(
                                  address: user.address,
                                ),
                              ),
                            );
                            setState(() {
                                addressChange = finalAddress;
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Deliver to',
                                  style:
                                  TextStyle(fontSize: 15, color: Colors.blueGrey),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        addressChange,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        softWrap: false,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      size: 18,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                              width: 1.0, color: Colors.grey.shade300))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Your order',
                          style:
                              TextStyle(fontSize: 15, color: Colors.blueGrey),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: controller.items.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  'x ${controller.items.values.toList()[index].toString()}',
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    controller.items.keys.toList()[index].title,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: false,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  NumberFormat.currency(locale: 'vi').format(
                                      controller.itemSubtotal.toList()[index]),
                                  style: TextStyle(
                                      fontSize: 15,
                                      overflow: TextOverflow.ellipsis),
                                  maxLines: 1,
                                ),
                                ElevatedButton(
                                  child: Icon(
                                    Icons.clear,
                                    size: 10,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      controller.removeOneItem(controller
                                          .items.keys
                                          .toList()[index]);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      onPrimary: Colors.white,
                                      primary: Colors.black54.withOpacity(0.3),
                                      shape: CircleBorder(),
                                      minimumSize: Size(20, 20),
                                      elevation: 0.0),
                                )
                              ],
                            ),
                          ),
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                height: 90,
                padding: const EdgeInsets.all(20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        NumberFormat.currency(locale: 'vi')
                            .format(controller.total),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: controller.items.length == 0
                            ? null
                            : () {
                          fetch();
                                createBill();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text('Order successfully!')));
                                controller.items.clear();
                                Navigator.popAndPushNamed(
                                    context, PageRoutes.home);
                              },
                        style: ElevatedButton.styleFrom(
                          onPrimary: Colors.white,
                          primary: Colors.indigo,
                          minimumSize: const Size(180, 50),
                          onSurface: Colors.grey.shade600,
                        ),
                        child: const Text(
                          'Order',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ]),
              ),
            ),
          ],
        ));
  }

  Future<Users?> readUser() async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(auth);
    final snapshot = await docUser.get();
    if (snapshot.exists) {
      return Users.fromJson(snapshot.data()!);
    }
  }

  Future<dynamic> fetch() async {
    final DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(auth).get();

    if (documentSnapshot.exists) {
      return documentSnapshot.data();
    }
    return null;
  }

  Future createBill() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docBill = FirebaseFirestore.instance.collection('bills').doc();
    final keyItemList = controller.items.keys.toList();
    final DateTime now = DateTime.now();
    final String time = DateFormat('HH:mm dd/MM/yyyy').format(now).toString();
    print('Item: $keyItemList');
    final itemList = [];
    for (final item in keyItemList) {
      final itemData = {
        'id': item.id,
        'title': item.title,
        'quantity': controller.items[item],
        'itemSubTotal': item.price * controller.items[item],
      };
      itemList.add(itemData);
    }
    print('Item final list: $itemList');

    final json = {
      'billId': docBill.id,
      'status': false,
      'totalPrice': controller.total,
      'uid': uid,
      'item': itemList,
      'createdAt': time,
      'address': addressChange,
    };

    await docBill.set(json);
  }
}
