import 'dart:io';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/diary.dart';

class ImageGallery extends StatelessWidget {
  ImageGallery({super.key});
  final diaryBox = Hive.box('diaries');

  @override
  Widget build(BuildContext context) {
    final List diaryList = diaryBox.values.toList();
    List<String> imgList = [];
    for (Diary diary in diaryList) {
      imgList += diary.imgPaths;
    }
    imgList = List.from(imgList.reversed);

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text("img_gallery_title".tr()),
          centerTitle: true,
        ),
        body: imgList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 30),
                    const SizedBox(height: 10),
                    Text(
                      "img_gallery_empty".tr(),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
                padding: const EdgeInsets.all(0.0),
                children: [
                  ...List<Widget>.generate(
                    imgList.length,
                    (int index) => InkWell(
                      onTap: () => showImageViewer(
                        context,
                        FileImage(
                          File(imgList[index]),
                        ),
                        useSafeArea: false,
                        doubleTapZoomable: true,
                        swipeDismissible: true,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image.file(
                          File(imgList[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
