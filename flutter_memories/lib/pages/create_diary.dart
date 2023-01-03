import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateDiary extends StatefulWidget {
  const CreateDiary({super.key});

  @override
  State<CreateDiary> createState() => _CreateDiaryState();
}

class _CreateDiaryState extends State<CreateDiary> {
  DateTime selectedDate = DateTime.now();
  DateTime now = DateTime.now();
  List<String> moodIconList = [
    'assets/images/mood_cry.png',
    'assets/images/mood_sad.png',
    'assets/images/mood_neutral.png',
    'assets/images/mood_happy.png',
    'assets/images/mood_excited.png',
  ];
  List<String> moodList = [
    'heartbroken',
    'unhappy',
    'neutral',
    'happy',
    'delighted',
  ];
  int? selectedMood = 2;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
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
      title: const Text('Discard'),
      content: const Text(
          "Your changes haven't been saved. \nDo you want to discard the changes?"),
      textOK: const Text('OK'),
      textCancel: const Text('CANCEL'),
    )) {
      return Navigator.of(context).pop();
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5F5FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => _discardConfirm(context),
        ),
        title: TextButton(
          onPressed: () => _selectDate(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                DateFormat.yMMMd().format(selectedDate),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              const Icon(
                Icons.arrow_drop_down_rounded,
                color: Colors.black,
                size: 30,
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              //Save data to Database
            },
            icon: const Icon(Icons.check, color: Colors.blue),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'How was your day?',
                        style: TextStyle(
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
                                    onPressed: () {
                                      setState(() {
                                        selectedMood = null;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 2,
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(15),
                                      backgroundColor: Colors.white,
                                    ),
                                    child: Image.asset(
                                        moodIconList[selectedMood!],
                                        height: 32),
                                  ),
                                  const VerticalDivider(
                                    width: 30,
                                    thickness: 1.0,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: "It was ",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: moodList[selectedMood!],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const TextSpan(text: " today.")
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
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: const [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tell me about your day',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 100),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: const [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Your photos',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
