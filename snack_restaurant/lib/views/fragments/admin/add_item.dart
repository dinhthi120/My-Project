import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snack_restaurant/models/item.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({Key? key}) : super(key: key);

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();
  final controllerPrice = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            if (pickedFile != null)
              SizedBox(
                height: 200,
                child: Image.file(
                  File(pickedFile!.path!),
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
            ElevatedButton(
                onPressed: selectFile, child: const Text('Select photo')),
            if (pickedFile != null)
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  setState(() {
                    pickedFile = null;
                  });
                },
                child: const Text('Delete photo'),
              ),
            const SizedBox(height: 24),
            TextFormField(
              decoration: decoration('Title'),
              controller: controllerTitle,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text!';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            TextFormField(
                minLines: 6,
                maxLines: 10,
                decoration: decoration('Description'),
                controller: controllerDescription),
            const SizedBox(height: 24),
            TextFormField(
              decoration: decoration('Price'),
              controller: controllerPrice,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price!';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 46.0,
              child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final imgLink = await uploadFile();
                      final item = Item(
                        title: controllerTitle.text,
                        description: controllerDescription.text,
                        price: int.parse(controllerPrice.text),
                        imgLink: imgLink,
                      );
                      addItem(item);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.green,
                          content: Text(
                              '"${controllerTitle.text}" has been added successfully!')));
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    'ADD ITEM',
                    style: TextStyle(fontSize: 16.0),
                  )),
            )
          ],
        ),
      ),
    );
  }

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      );

  Future addItem(Item item) async {
    final docItem = FirebaseFirestore.instance.collection('items').doc();
    item.id = docItem.id;
    final json = item.toJson();
    await docItem.set(json);
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future<String> uploadFile() async {
    if (pickedFile == null) {
      return '';
    }

    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    return urlDownload;
  }
}
