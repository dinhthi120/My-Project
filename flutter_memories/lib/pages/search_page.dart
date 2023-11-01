import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/diary.dart';
import '../widgets/diary_items.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  var diariesBox = Hive.box('diaries');
  late List originalData;
  List showData = [];

  @override
  void initState() {
    originalData = diariesBox.values.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "search_hint".tr(),
          ),
          onChanged: (value) {
            setState(() {
              showData.clear();
              showData = originalData.where((element) {
                return element.contentPlainText
                    .trim()
                    .toLowerCase()
                    .contains(value.toLowerCase());
              }).toList();
              showData.sort((a, b) => b.date.compareTo(a.date));
            });
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                showData.clear();
                searchController.text = '';
              });
            },
            icon: const Icon(Icons.clear_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${showData.length} ${showData.length < 2 ? "search_count_single".tr() : "search_count_multiple".tr()} ${"search_count_found".tr()}',
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box('diaries').listenable(),
              builder: (context, box, _) {
                return ListView.builder(
                  itemCount: showData.length,
                  itemBuilder: (context, index) {
                    Diary? currentDiary = showData[index];
                    if (index == showData.length - 1) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: diaryItem(
                          context: context,
                          index: originalData.indexOf(currentDiary),
                          currentDiary: currentDiary,
                        ),
                      );
                    }
                    return diaryItem(
                      context: context,
                      index: originalData.indexOf(currentDiary),
                      currentDiary: currentDiary,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
