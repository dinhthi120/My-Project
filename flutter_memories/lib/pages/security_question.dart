import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../services/secure_storage.dart';

class SecurityQuestion extends StatefulWidget {
  static const route = 'question-page';

  const SecurityQuestion({super.key});

  @override
  State<SecurityQuestion> createState() => _SecurityQuestionState();
}

class _SecurityQuestionState extends State<SecurityQuestion> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      setQuestionDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/passcode-img.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

void setQuestionDialog(context) {
  showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.transparent,
        child: DialogBody(),
      );
    },
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration: const Duration(milliseconds: 200),
  );
}

class DialogBody extends StatefulWidget {
  const DialogBody({super.key});

  @override
  State<DialogBody> createState() => _DialogBodyState();
}

class _DialogBodyState extends State<DialogBody> {
  // Read question and answer from secure storage
  // String question = '';
  // String answer = '';

  // @override
  // void initState() {
  //   super.initState();

  //   init();
  // }

  // Future init() async {
  //   String userQuestion =
  //       await QuestionSecureStorage.getSecurityQuestion() ?? '';
  //   String userAnswer = await AnswerSecureStorage.getSecurityAnswer() ?? '';
  //   setState(() {
  //     question = userQuestion;
  //     answer = userAnswer;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.transparent,
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildBackButton(context),
              buildTitle(
                context,
                'Please set a security quesion in case you forget your password',
              ),
              DropdownButtonExample(),
              AnswerField(),
              ConfirmButton(),
            ],
          ),
        ),
      ),
    );
  }

  buildBackButton(context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          MaterialButton(
            onPressed: () {
              // Delete Pin from secure storage
              PinSecureStorage.deletePinNumber();
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'set-lock');
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
          const Text(
            'Set Diary Lock',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  buildTitle(context, title) {
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
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

const List<String> list = <String>[
  'What is your favortie color?',
  'What is your favorite food?',
  'What is your favorite movie?'
];

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<String>(
        value: dropdownValue,
        menuMaxHeight: 200,
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
        elevation: 0,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        dropdownColor: Colors.black,
        underline: Container(
          height: 1,
          color: Colors.black,
        ),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
            QuestionSecureStorage.setSecurityQuestion(value);
          });
        },
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
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
        onChanged: (value) {
          AnswerSecureStorage.setSecurityAnswer(value);
        },
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
        decoration: const InputDecoration(
          hintText: 'Please input your answer',
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({super.key});

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
        onPressed: () async {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, 'setting-page');
        },
        child: Text(
          'Confirm'.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
