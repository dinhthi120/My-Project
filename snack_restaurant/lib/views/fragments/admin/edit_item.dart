import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snack_restaurant/models/item.dart';

class EditItemPage extends StatefulWidget {
  const EditItemPage({Key? key, required this.item}) : super(key: key);
  final Item item;
  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();
  final controllerPrice = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String? initialImgLink;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controllerTitle.text = widget.item.title;
    controllerDescription.text = widget.item.description;
    controllerPrice.text = widget.item.price.toString();
    initialImgLink = widget.item.imgLink;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            if (initialImgLink != '' && initialImgLink != null)
              SizedBox(
                height: 200,
                child: Image.network(
                  initialImgLink!,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
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
            if (pickedFile != null ||
                (initialImgLink != null && initialImgLink != ''))
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                onPressed: () {
                  setState(() {
                    initialImgLink = null;
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
              controller: controllerDescription,
            ),
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
                      if (initialImgLink != null && initialImgLink != '') {
                        final item = Item(
                          id: widget.item.id,
                          title: controllerTitle.text,
                          description: controllerDescription.text,
                          price: int.parse(controllerPrice.text),
                          imgLink: initialImgLink ?? '',
                        );
                        updateItem(item);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                '"${controllerTitle.text}" has been updated successfully!')));
                        Navigator.of(context).pop();
                        return;
                      }

                      final imgLink = await uploadFile();
                      final item = Item(
                        id: widget.item.id,
                        title: controllerTitle.text,
                        description: controllerDescription.text,
                        price: int.parse(controllerPrice.text),
                        imgLink: imgLink,
                      );
                      updateItem(item);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        backgroundColor: Colors.green,
                          content: Text(
                              '"${controllerTitle.text}" has been updated successfully!')));
                      Navigator.of(context).pop();
                      return;
                    }
                  },
                  child: const Text(
                    'UPDATE',
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

  Future updateItem(Item item) async {
    final docItem = FirebaseFirestore.instance.collection('items').doc(item.id);
    final json = item.toJson();
    await docItem.update(json);
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    if (result == null) return;

    setState(() {
      initialImgLink = null;
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
