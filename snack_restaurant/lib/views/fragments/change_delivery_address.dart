import 'package:flutter/material.dart';

class ChangeDeliveryAddress extends StatefulWidget {
  ChangeDeliveryAddress({Key? key, required this.address}) : super(key: key);
  static const String routeName = '/changeAddress';
  final String address;

  @override
  State<ChangeDeliveryAddress> createState() => _ChangeDeliveryAddressState();
}

class _ChangeDeliveryAddressState extends State<ChangeDeliveryAddress> {
  final textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textController.text = widget.address;
  }

  late String newAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Change Delivery Address'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context, widget.address);
          },
            child: Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            child: TextFormField(
              controller: textController,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(6),
            ),
            child: TextButton(
              onPressed: () {
                final newAddress = textController.text;
                  Navigator.pop(context, newAddress);
              },
              child: Text(
                'update'.toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
