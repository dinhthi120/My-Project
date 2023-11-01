import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../constants.dart';
import '../models/diary.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:screenshot/screenshot.dart';

class ShareDiary extends StatefulWidget {
  final Diary currentDiary;
  const ShareDiary({super.key, required this.currentDiary});

  @override
  State<ShareDiary> createState() => _ShareDiaryState();
}

class _ShareDiaryState extends State<ShareDiary> {
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[400],
        actions: [
          IconButton(
            onPressed: () {
              screenshotController
                  .capture(delay: const Duration(milliseconds: 10))
                  .then((capturedImage) async {
                final directory = await getApplicationDocumentsDirectory();
                final imagePath =
                    await File('${directory.path}/screenshot.png').create();
                await imagePath.writeAsBytes(capturedImage!);
                await GallerySaver.saveImage(imagePath.path);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(milliseconds: 500),
                  content: Text("Image Saved!"),
                ));
              }).catchError((onError) {});
            },
            icon: const Icon(Icons.save_alt),
          ),
          IconButton(
            onPressed: () {
              String text =
                  'I am using Memories - Daily Journal to write down all my thoughts and memories. Share it to your friends!! \n https://drive.google.com/file/d/1nVPNvYPWJ9CFXg5m_GElScJzlMK_yZRi/view?usp=share_link';
              screenshotController
                  .capture(delay: const Duration(milliseconds: 10))
                  .then((capturedImage) async {
                final directory = await getApplicationDocumentsDirectory();
                final imagePath =
                    await File('${directory.path}/screenshot.png').create();
                await imagePath.writeAsBytes(capturedImage!);

                /// Share Plugin
                await Share.shareXFiles([XFile(imagePath.path)], text: text);
              }).catchError((onError) {
                print(onError);
              });
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Screenshot(
          controller: screenshotController,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    DateFormat.yMMMd().format(widget.currentDiary.date),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                moodSection(),
                const SizedBox(height: 10),
                Visibility(
                  visible: widget.currentDiary.contentPlainText.isNotEmpty,
                  child: Column(
                    children: [
                      contentSection(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.currentDiary.imgPaths.isNotEmpty,
                  child: Column(
                    children: [
                      imageSection(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                      child: Image.asset(
                        "assets/images/icon_launcher/icon_launcher.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 5.0),
                    const Text('Memories - Daily Journal')
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget moodSection() {
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
          IntrinsicHeight(
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: null,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(15),
                    backgroundColor: Colors.blue[300],
                    disabledBackgroundColor: Colors.blue[300],
                  ),
                  child: Image.asset(moodIconList[widget.currentDiary.mood],
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
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: 14,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: moodList[widget.currentDiary.mood].tr(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color),
                      ),
                      TextSpan(text: "mood_trailing_text".tr())
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget contentSection() {
    final quill.QuillController controller = quill.QuillController.basic();
    controller.document =
        quill.Document.fromJson(jsonDecode(widget.currentDiary.contentJson));
    final FocusNode focusNode = FocusNode();
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
          //   showCursor: false,
          //   minHeight: 100,
          //   controller: controller,
          //   scrollController: ScrollController(),
          //   scrollable: true,
          //   focusNode: focusNode,
          //   autoFocus: false,
          //   readOnly: true,
          //   placeholder: 'diary_content_placeholder'.tr(),
          //   padding: EdgeInsets.zero,
          //   expands: false,
          // ),
        ],
      ),
    );
  }

  Widget imageSection() {
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
                widget.currentDiary.imgPaths.length,
                (int index) => SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      File(widget.currentDiary.imgPaths[index]),
                      fit: BoxFit.cover,
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
