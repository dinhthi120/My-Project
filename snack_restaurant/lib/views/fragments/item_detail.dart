import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:snack_restaurant/models/item.dart';
import '../../controllers/handle_cart.dart';
import 'auth/login_page.dart';

class ItemDetail extends StatefulWidget {
  const ItemDetail({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  State<ItemDetail> createState() => _DetailState();
}

class _DetailState extends State<ItemDetail> {
  int itemCount = 1;
  bool isBtnDisabled = true;

  final cartController = Get.put(CartController());

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              ListView(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.item.imgLink != ''
                              ? widget.item.imgLink
                              : 'https://t4.ftcdn.net/jpg/04/70/29/97/360_F_470299797_UD0eoVMMSUbHCcNJCdv2t8B2g1GVqYgs.jpg'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.item.title,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            NumberFormat.currency(locale: 'vi')
                                .format(widget.item.price),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.item.description,
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey.shade700),
                      )
                    ]),
                  )
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
                        ElevatedButton(
                          onPressed: () {
                            if (itemCount > 1) {
                              setState(() {
                                itemCount--;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              onPrimary: Colors.indigo,
                              primary: Colors.indigo.shade50,
                              onSurface: Colors.grey.shade600,
                              minimumSize: const Size(30, 30),
                              elevation: 0.0),
                          child: const FaIcon(FontAwesomeIcons.minus, size: 10),
                        ),
                        Text(
                          itemCount.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              itemCount++;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              onPrimary: Colors.indigo,
                              primary: Colors.indigo.shade50,
                              minimumSize: const Size(30, 30),
                              onSurface: Colors.grey.shade600,
                              elevation: 0.0),
                          child: const FaIcon(
                            FontAwesomeIcons.plus,
                            size: 10,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (auth.currentUser != null) {
                              cartController.addItems(widget.item, itemCount);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            onPrimary: Colors.white,
                            primary: Colors.indigo,
                            minimumSize: Size(180, 50),
                            onSurface: Colors.grey.shade600,
                          ),
                          child: const Text(
                            'Add to cart',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ]),
                ),
              ),
              Positioned(
                  top: 0,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                        onPrimary: Colors.white,
                        primary: Colors.black54.withOpacity(0.3),
                        shape: const CircleBorder(),
                        minimumSize: const Size(30, 30),
                        elevation: 0.0),
                    child: const Icon(
                      Icons.clear,
                      size: 20,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
