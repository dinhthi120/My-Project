import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:snack_restaurant/models/item.dart';
import 'package:snack_restaurant/views/fragments/admin/add_item.dart';
import 'package:snack_restaurant/views/navigation_drawer.dart';

import 'edit_item.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({Key? key}) : super(key: key);
  static const String routeName = '/itemsPage';

  @override
  State<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(),
      appBar: AppBar(
        title: const Text('Manage Items'),
      ),
      body: StreamBuilder<List<Item>>(
        stream: readItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          }
          if (snapshot.hasData) {
            final items = snapshot.data!;

            return ListView(
              physics: const BouncingScrollPhysics(),
              children: ListTile.divideTiles(
                      context: context, tiles: items.map(buildItem).toList())
                  .toList(),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemPage()),
          );
        },
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildItem(Item item) => Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (BuildContext slidableContext) async {
                final confirmed = await confirm(
                  context,
                  title: const Text('Confirm'),
                  content: Text('Would you like to remove "${item.title}"?'),
                  textOK: const Text('Yes'),
                  textCancel: const Text('Cancel'),
                );
                print(confirmed);
                if (confirmed) {
                  final docItem = FirebaseFirestore.instance
                      .collection('items')
                      .doc(item.id);
                  docItem.delete();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Colors.red,
                      content: Text(
                          '"${item.title}" has been removed successfully!')));
                }
                print('pressedCancel');
                return;
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete_outline_rounded,
              label: 'Delete',
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            // Add your onPressed code here!
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditItemPage(item: item)),
            );
          },
          onLongPress: () async {
            if (await confirm(
              context,
              title: const Text('Confirm'),
              content: Text('Would you like to remove "${item.title}"?'),
              textOK: const Text('Yes'),
              textCancel: const Text('Cancel'),
            )) {
              final docItem =
                  FirebaseFirestore.instance.collection('items').doc(item.id);
              docItem.delete();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                  content:
                      Text('"${item.title}" has been removed successfully!')));
            }
          },
          child: Container(
            width: double.infinity,
            height: 100,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                if (item.imgLink != '')
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: Image.network(
                      item.imgLink,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (item.imgLink != '') const SizedBox(width: 18.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold)),
                      Text(
                        item.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: false,
                        style: TextStyle(color: Colors.grey),
                      ),
                      const Spacer(),
                      Text(
                        NumberFormat.currency(locale: 'vi').format(item.price),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Stream<List<Item>> readItems() => FirebaseFirestore.instance
      .collection('items').orderBy('title')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Item.fromJson(doc.data())).toList());
}
