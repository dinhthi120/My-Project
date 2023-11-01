import 'package:flutter/material.dart';
import '../services/secure_storage.dart';
import '../widgets/show_flush_bar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';

import 'change_page.dart';

class SecurityQuestion extends StatefulWidget {
  final String checkEvent;
  final String passcode;
  const SecurityQuestion({
    super.key,
    required this.passcode,
    required this.checkEvent,
  });

  @override
  State<SecurityQuestion> createState() => _SecurityQuestionState();
}

TextEditingController _answer = TextEditingController();
String checkUserEvent = '';
String oldAnswer = '';
String oldQuestion = '';
String question = '';
String answer = '';
String confirmAnswer = '';
String dropdownValue = list.first;

class _SecurityQuestionState extends State<SecurityQuestion> {
  @override
  void initState() {
    init();
    super.initState();
  }

  Future init() async {
    String secureAnwser = await AnswerSecureStorage.getSecurityAnswer() ?? '';
    String secureQuestion =
        await QuestionSecureStorage.getSecurityQuestion() ?? '';

    setState(() {
      answer = "";
      question = "";
      oldAnswer = secureAnwser;
      oldQuestion = secureQuestion;
      checkUserEvent = widget.checkEvent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (checkUserEvent == 'setQuestion') {
          QuestionSecureStorage.deleteSecurityQuestion();
          AnswerSecureStorage.deleteSecurityAnswer();
          _answer.clear();
          Navigator.pushReplacementNamed(context, 'set-lock');
        } else {
          _answer.clear();
          Navigator.pushReplacementNamed(context, 'set-lock');
        }
        if (checkUserEvent == 'checkQuestionToLog') {
          return false;
        }
        return false;
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/passcode-img.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                buildBackButton(),
                checkUserEvent != 'checkQuestionToLog'
                    ? buildHelperText(
                        context,
                        'question_page_title'.tr(),
                      )
                    : buildHelperText(
                        context,
                        '',
                      ),
                const DropdownButtonExample(),
                const AnswerField(),
                ConfirmButton(
                  passcode: widget.passcode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildHelperText(context, title) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  buildBackButton() {
    return checkUserEvent == 'checkQuestionToLog'
        ? checkToLogButton()
        : createAndChangeQuestionButton();
  }

  checkToLogButton() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          MaterialButton(
            onPressed: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePage(),
                ),
              );
              _answer.clear();
            },
            height: 50,
            minWidth: 50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          Text(
            'reset_passcode'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  createAndChangeQuestionButton() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          MaterialButton(
            onPressed: () {
              if (oldAnswer == "") {
                QuestionSecureStorage.deleteSecurityQuestion();
                AnswerSecureStorage.deleteSecurityAnswer();
                _answer.clear();
                Navigator.pushReplacementNamed(context, 'set-lock');
              } else {
                _answer.clear();
                Navigator.pushReplacementNamed(context, 'set-lock');
              }
            },
            height: 50,
            minWidth: 50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
          checkUserEvent == "setQuestion"
              ? buttonTitle('create_question_back_btn'.tr())
              : buttonTitle('change_question_back_btn'.tr())
        ],
      ),
    );
  }

  buttonTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

List<String> list = <String>[
  "What is your favortie color?",
  "What is your favorite food?",
  "What is your favorite movie?"
];

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          dropdownDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          value: dropdownValue,
          itemHeight: kMinInteractiveDimension,
          icon: Expanded(
            child: Container(
              padding: const EdgeInsets.only(right: 12),
              alignment: Alignment.topRight,
              child: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
            ),
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
          underline: Container(
            height: 1,
            color: Colors.black,
          ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue = value!;
            });
          },
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class AnswerField extends StatefulWidget {
  const AnswerField({super.key});

  @override
  State<AnswerField> createState() => _AnswerFieldState();
}

class _AnswerFieldState extends State<AnswerField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: TextField(
        controller: _answer,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: 'answer_field_hint_text'.tr(),
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ConfirmButton extends StatefulWidget {
  final String passcode;
  const ConfirmButton({super.key, required this.passcode});

  @override
  State<ConfirmButton> createState() => _ConfirmButtonState();
}

class _ConfirmButtonState extends State<ConfirmButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 24, right: 24, top: 42),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(4),
      ),
      child: MaterialButton(
        child: Text(
          'question_page_confirm_btn'.tr().toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        onPressed: () async {
          if (_answer.text.isEmpty) {
            showFlushBar(context, "flush_bar_empty_answer".tr());
          } else {
            if (checkUserEvent == 'checkQuestionToLog') {
              checkQuestionToLog();
            } else {
              createAndChangeQuestion();
            }
          }
        },
      ),
    );
  }

  void checkQuestionToLog() async {
    setState(() {
      answer = _answer.text;
    });
    if (answer != oldAnswer || dropdownValue != oldQuestion) {
      _answer.clear();
      showFlushBar(context, 'flush_bar_not_match'.tr());
    } else {
      _answer.clear();

      await PinSecureStorage.deletePinNumber();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  void createAndChangeQuestion() async {
    if (answer == '') {
      setState(() {
        answer = _answer.text;
        question = dropdownValue;
      });
      showFlushBar(context, 'flush_bar_confirm_answer'.tr());
      _answer.clear();
    } else {
      setState(() {
        confirmAnswer = _answer.text;
      });
      if (answer != confirmAnswer || question != dropdownValue) {
        _answer.clear();

        showFlushBar(context, 'flush_bar_not_match'.tr());
      } else {
        _answer.clear();
        await QuestionSecureStorage.setSecurityQuestion(dropdownValue);
        await AnswerSecureStorage.setSecurityAnswer(answer);

        if (widget.passcode != '') {
          await PinSecureStorage.setPinNumber(widget.passcode);
          await CheckUserSession.setUserSession('logged');
        }

        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, 'setting-page');
      }
    }
  }
}
