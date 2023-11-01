import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../models/diary.dart';
import '../pages/edit_diary.dart';

Widget diaryItem(
    {required BuildContext context,
    required int index,
    required Diary? currentDiary}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
    child: InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => EditDiary(
            diaryId: index,
            currentDiary: currentDiary,
          ),
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: DateFormat('d ').format(currentDiary!.date).toString(),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text:
                        DateFormat('MMM').format(currentDiary.date).toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              ),
            ),
            IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      moodIconList[currentDiary.mood],
                      height: 32,
                    ),
                    const VerticalDivider(
                      width: 30,
                      thickness: 1.0,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: currentDiary.contentPlainText.isEmpty
                                ? currentDiary.imgPaths.isNotEmpty
                                    ? Container()
                                    : Text(
                                        "empty_content_diary".tr(),
                                        style: const TextStyle(
                                            // color: Colors.black,
                                            fontStyle: FontStyle.italic),
                                      )
                                : Text(
                                    currentDiary.contentPlainText,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        // color: Colors.black,
                                        ),
                                  ),
                          ),
                          const SizedBox(height: 10),
                          if (currentDiary.imgPaths.isNotEmpty)
                            SizedBox(
                              height: 100,
                              child: GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 3,
                                crossAxisSpacing: 5.0,
                                padding: const EdgeInsets.all(0.0),
                                children: [
                                  ...List<Widget>.generate(
                                    currentDiary.imgPaths.length <= 3
                                        ? currentDiary.imgPaths.length
                                        : 3,
                                    (int index) => currentDiary
                                                .imgPaths.length >
                                            3
                                        ? handleMultipleImg(index, currentDiary)
                                        : _imgWidget(currentDiary, index),
                                  ),
                                ],
                              ),
                            )
                          else
                            const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget handleMultipleImg(int index, Diary currentDiary) {
  if (index < 2) {
    return _imgWidget(currentDiary, index);
  } else {
    return Stack(
      children: [
        _imgWidget(currentDiary, index),
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        const Center(
          child: Icon(
            Icons.more_horiz_rounded,
            color: Colors.white,
            size: 30.0,
          ),
        ),
      ],
    );
  }
}

Widget _imgWidget(Diary currentDiary, int index) {
  return SizedBox(
    width: double.infinity,
    height: double.infinity,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.file(
        File(currentDiary.imgPaths[index]),
        fit: BoxFit.cover,
      ),
    ),
  );
}
