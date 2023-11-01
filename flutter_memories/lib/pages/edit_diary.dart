import 'dart:convert';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memories_dailyjournal/pages/share_diary.dart';
import 'package:flutter_memories_dailyjournal/widgets/show_flush_bar.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

import '../constants.dart';
import '../models/diary.dart';
import 'home_page.dart';

class EditDiary extends StatefulWidget {
  final int diaryId;
  final Diary currentDiary;

  const EditDiary(
      {super.key, required this.diaryId, required this.currentDiary});

  @override
  State<EditDiary> createState() => _EditDiaryState();
}

class _EditDiaryState extends State<EditDiary> {
  final quill.QuillController _controller = quill.QuillController.basic();
  final FocusNode _focusNode = FocusNode();
  bool isFocus = false;
  late DateTime selectedDate;
  DateTime now = DateTime.now();
  late int? selectedMood;
  final ImagePicker _picker = ImagePicker();
  late List<String> _imagesPathList;
  late List<String> tempImgList = [];
  List<String> tempDeleteImgList = [];
  bool isEditing = false;
  var diariesBox = Hive.box('diaries');

  @override
  void initState() {
    super.initState();
    selectedDate = widget.currentDiary.date;
    selectedMood = widget.currentDiary.mood;
    _imagesPathList = List.from(widget.currentDiary.imgPaths);
    _controller.document =
        quill.Document.fromJson(jsonDecode(widget.currentDiary.contentJson));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year, now.month, now.day),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _discardConfirm(BuildContext context) async {
    if (await confirm(
      context,
      title: Text('discard_confirm_title'.tr()),
      content: Text("discard_confirm_content".tr()),
      textOK: Text('discard_ok'.tr()),
      textCancel: Text('discard_cancel'.tr()),
    )) {
      handleDeleteImg("cancel");
      return Navigator.of(context).pop();
    }
    return;
  }

  Future<void> cancelEditConfirm(BuildContext context) async {
    if (await confirm(
      context,
      title: Text('discard_edit_title'.tr()),
      content: Text("discard_edit_content".tr()),
      textOK: Text('discard_ok'.tr()),
      textCancel: Text('discard_cancel'.tr()),
    )) {
      handleDeleteImg("cancel");
      setState(() {
        selectedDate = widget.currentDiary.date;
        selectedMood = widget.currentDiary.mood;
        _imagesPathList = List.from(widget.currentDiary.imgPaths);
        _controller.document = quill.Document.fromJson(
            jsonDecode(widget.currentDiary.contentJson));
        isEditing = false;
      });
      return;
    }
    return;
  }

  Future<void> _deleteConfirm(BuildContext context) async {
    if (await confirm(
      context,
      title: Text('discard_delete_title'.tr()),
      content: Text("discard_delete_content".tr()),
      textOK: Text('discard_ok'.tr()),
      textCancel: Text('discard_cancel'.tr()),
    )) {
      deleteAllImg();
      diariesBox.deleteAt(widget.diaryId);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
      return;
    }
    return;
  }

  Future<void> selectImages() async {
    try {
      var pickedImages = await _picker.pickMultiImage();
      if (pickedImages.isNotEmpty) {
        await copyImagesToDir(pickedImages);
      }
      // print(tempImgList.toString());
      setState(() {});
    } catch (e) {
      return;
    }
  }

  Future<void> copyImagesToDir(List<XFile> pickedImages) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    List<String> newPaths = [];
    for (var img in pickedImages) {
      File originalImg = File(img.path);
      // print(originalImg.path);
      File newImage = await originalImg.copy("$path/${img.name}");
      newPaths.add(newImage.path);
    }
    _imagesPathList += newPaths;
    tempImgList += newPaths;
  }

  Future<void> removeImg(String path) async {
    try {
      // await File(path).delete();
      tempDeleteImgList.add(path);
      _imagesPathList.remove(path);
      setState(() {});
    } catch (e) {
      return;
    }
  }

  Future<void> deleteAllImg() async {
    try {
      for (String path in _imagesPathList) {
        await File(path).delete();
      }
    } catch (e) {
      return;
    }
  }

  Future<void> handleDeleteImg(String state) async {
    switch (state) {
      // When user save the edited data, delete images in tempDeleteImgList
      case "save":
        {
          try {
            for (String path in tempDeleteImgList) {
              await File(path).delete();
            }
          } catch (e) {
            return;
          }
        }
        break;
      // When user cancel the edited data, delete images in tempImgList
      case "cancel":
        {
          try {
            for (String path in tempImgList) {
              await File(path).delete();
            }
            setState(() {
              _imagesPathList = List.from(widget.currentDiary.imgPaths);
            });
          } catch (e) {
            return;
          }
        }
        break;
      default:
        break;
    }
  }

  void saveDiary(Diary diary) {
    final diariesBox = Hive.box('diaries');
    diariesBox.putAt(widget.diaryId, diary);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: isEditing
          ? () async {
              final shouldPop = await confirm(
                context,
                title: Text('discard_confirm_title'.tr()),
                content: Text("discard_confirm_content".tr()),
                textOK: Text('discard_ok'.tr()),
                textCancel: Text('discard_cancel'.tr()),
              );
              if (shouldPop) {
                handleDeleteImg("cancel");
              }
              return shouldPop;
            }
          : () async => true,
      child: GestureDetector(
        onTap: () => setState(() {
          _focusNode.unfocus();
          isFocus = false;
        }),
        child: Scaffold(
          // backgroundColor: const Color(0xFFE5F5FF),
          appBar: AppBar(
            elevation: 0,
            // backgroundColor: Colors.transparent,
            // foregroundColor: Colors.black,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => isEditing
                  ? _discardConfirm(context)
                  : Navigator.of(context).pop(),
            ),
            title: TextButton(
              onPressed: isEditing ? () => _selectDate(context) : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.yMMMd().format(selectedDate),
                    style: const TextStyle(
                      // color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  isEditing
                      ? const Icon(
                          Icons.arrow_drop_down_rounded,
                          // color: Colors.black,
                          size: 30,
                        )
                      : Container(),
                ],
              ),
            ),
            actions: [
              isEditing
                  ? IconButton(
                      onPressed: () {
                        cancelEditConfirm(context);
                      },
                      icon: const Icon(Icons.close_rounded),
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          isEditing = true;
                        });
                      },
                      icon: const Icon(Icons.edit_note_rounded),
                    ),
              isEditing
                  ? IconButton(
                      onPressed: () {
                        //Save data to Database
                        if (selectedMood == null) {
                          showFlushBar(context, "Select a mood");
                        } else {
                          String contentJson = jsonEncode(
                              _controller.document.toDelta().toJson());
                          String contentPlainText =
                              _controller.document.toPlainText().trim();
                          final newDiary = Diary(
                            date: selectedDate,
                            mood: selectedMood!,
                            contentPlainText: contentPlainText,
                            contentJson: contentJson,
                            imgPaths: _imagesPathList,
                          );
                          handleDeleteImg("save");
                          saveDiary(newDiary);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                              (route) => false);
                          showFlushBar(context, "save_success".tr());
                        }
                      },
                      icon: const Icon(
                        Icons.check,
                        // color: Colors.blue,
                      ),
                    )
                  : IconButton(
                      onPressed: () {
                        _deleteConfirm(context);
                      },
                      icon: const Icon(Icons.delete_outline_rounded),
                    ),
            ],
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      moodSelectWidget(),
                      const SizedBox(height: 20),
                      isEditing ||
                              widget.currentDiary.contentPlainText.isNotEmpty
                          ? contentWidget()
                          : Container(),
                      const SizedBox(height: 20),
                      isEditing || widget.currentDiary.imgPaths.isNotEmpty
                          ? imageUploadWidget()
                          : Container(),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
              isEditing ? textToolbarWidget() : Container(),
            ],
          ),
          floatingActionButton: Visibility(
            visible: !isEditing,
            child: FloatingActionButton(
              backgroundColor: Colors.blue[300],
              elevation: 2,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShareDiary(
                      currentDiary: widget.currentDiary,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.share, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget moodSelectWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'mood_select_title'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              alignment: Alignment.centerLeft,
              child: child,
            ),
            child: selectedMood != null
                ? IntrinsicHeight(
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: isEditing
                              ? () {
                                  setState(() {
                                    selectedMood = null;
                                  });
                                }
                              : () {},
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(15),
                            backgroundColor: Colors.blue[300],
                          ),
                          child: Image.asset(moodIconList[selectedMood!],
                              height: 32),
                        ),
                        const VerticalDivider(
                          width: 30,
                          thickness: 1.0,
                        ),
                        RichText(
                          text: TextSpan(
                            text: "mood_leading_text".tr(),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                              fontSize: 14,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: moodList[selectedMood!].tr(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color),
                              ),
                              TextSpan(text: "mood_trailing_text".tr())
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List<Widget>.generate(
                        5,
                        (index) => IconButton(
                          onPressed: () {
                            setState(() {
                              selectedMood = index;
                            });
                          },
                          icon: Image.asset(moodIconList[index]),
                          iconSize: 45,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget contentWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'diary_content_helper_text'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Divider(
            thickness: 1.0,
          ),
          // quill.QuillEditor(
          //   minHeight: 100,
          //   controller: _controller,
          //   scrollController: ScrollController(),
          //   scrollable: true,
          //   focusNode: _focusNode,
          //   autoFocus: false,
          //   readOnly: !isEditing,
          //   placeholder: 'diary_content_placeholder'.tr(),
          //   padding: EdgeInsets.zero,
          //   expands: false,
          //   onTapDown: (details, p1) {
          //     setState(() {
          //       isFocus = true;
          //     });
          //     return false;
          //   },
          // ),
        ],
      ),
    );
  }

  Widget textToolbarWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: isFocus
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
              // child: quill.QuillToolbar.basic(
              //   controller: _controller,
              //   toolbarIconSize: 26,
              //   toolbarIconAlignment: WrapAlignment.spaceAround,
              //   showDividers: false,
              //   showFontFamily: false,
              //   showFontSize: false,
              //   showBoldButton: true,
              //   showItalicButton: true,
              //   showUnderLineButton: true,
              //   showStrikeThrough: true,
              //   showInlineCode: false,
              //   showColorButton: true,
              //   showBackgroundColorButton: true,
              //   showClearFormat: true,
              //   showLeftAlignment: false,
              //   showCenterAlignment: false,
              //   showRightAlignment: false,
              //   showJustifyAlignment: false,
              //   showHeaderStyle: false,
              //   showListNumbers: false,
              //   showListBullets: false,
              //   showListCheck: false,
              //   showCodeBlock: false,
              //   showQuote: false,
              //   showIndent: false,
              //   showLink: false,
              //   showUndo: false,
              //   showRedo: false,
              //   showSearchButton: false,
              // ),
            )
          : Container(),
    );
  }

  Widget imageUploadWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'diary_add_photos'.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 3,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
            padding: const EdgeInsets.all(0.0),
            children: [
              ...List<Widget>.generate(
                _imagesPathList.length,
                (int index) => Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        showImageViewer(
                          context,
                          FileImage(
                            File(_imagesPathList[index]),
                          ),
                          useSafeArea: true,
                          // immersive: false,
                          doubleTapZoomable: true,
                          swipeDismissible: true,
                        );
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            File(_imagesPathList[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isEditing,
                      child: Positioned(
                        top: 6,
                        right: 6,
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: ElevatedButton(
                            onPressed: () {
                              // Temporarily remove, not remove the original
                              removeImg(_imagesPathList[index]);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              shape: const CircleBorder(),
                              backgroundColor: Colors.black.withOpacity(0.3),
                              foregroundColor: Colors.white,
                            ),
                            child: const Icon(Icons.close, size: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: isEditing,
                child: InkWell(
                  onTap: () {
                    selectImages();
                  },
                  child: DottedBorder(
                    color: Colors.blue,
                    dashPattern: const [10, 3],
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add_photo_alternate_rounded,
                          color: Colors.blue,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
