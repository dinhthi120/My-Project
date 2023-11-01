import 'package:flutter/material.dart';
import 'package:flutter_memories_dailyjournal/pages/passcode_page.dart';
import 'package:flutter_memories_dailyjournal/pages/security_question.dart';
import '../services/secure_storage.dart';
import 'package:easy_localization/easy_localization.dart';

class SetDiaryLock extends StatefulWidget {
  static const route = 'set-lock';
  const SetDiaryLock({super.key});

  @override
  State<SetDiaryLock> createState() => _SetDiaryLockState();
}

String pin = "";
bool active = false;

class _SetDiaryLockState extends State<SetDiaryLock> {
  @override
  void initState() {
    super.initState();

    init();
  }

  Future init() async {
    String getPin = await PinSecureStorage.getPinNumber() ?? "";
    setState(() {
      pin = getPin;
    });
    if (pin != "") {
      active = true;
    } else {
      active = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text('set_lock_title'.tr()),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          SetLockTile(
            onChanged: (bool value) async {
              setState(
                () {
                  active = value;
                },
              );
              if (active == true) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PasscodePage(checked: 'noPin'),
                  ),
                );
              } else {
                await PinSecureStorage.deletePinNumber();
                await QuestionSecureStorage.deleteSecurityQuestion();
                await AnswerSecureStorage.deleteSecurityAnswer();
                await CheckUserSession.deleteUserSession();
              }
            },
          ),
          active == true ? const ShowHiddenWidget() : const SizedBox(),
        ],
      ),
    );
  }
}

class ShowHiddenWidget extends StatelessWidget {
  const ShowHiddenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SetLockItems(
          title: 'set_lock_set_passcode_title'.tr(),
          subTitle: 'set_lock_set_passcode_sub_title'.tr(),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const PasscodePage(checked: 'changePassCode'),
              ),
            );
          },
        ),
        SetLockItems(
          title: 'set_lock_set_question_title'.tr(),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SecurityQuestion(
                  passcode: '',
                  checkEvent: 'changeQuestion',
                ),
              ),
            );
          },
          subTitle: 'set_lock_set_question_sub_title'.tr(),
        ),
      ],
    );
  }
}

class SetLockItems extends StatefulWidget {
  final String title;
  final String subTitle;
  final Function() onTap;

  const SetLockItems({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onTap,
  });

  @override
  State<SetLockItems> createState() => _SetLockItemsState();
}

class _SetLockItemsState extends State<SetLockItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: ListTile(
        onTap: widget.onTap,
        title: Text(widget.title),
        subtitle: Text(
          widget.subTitle,
          style: const TextStyle(fontSize: 13, color: Colors.grey),
        ),
      ),
    );
  }
}

class SetLockTile extends StatefulWidget {
  final Function(bool) onChanged;
  const SetLockTile({super.key, required this.onChanged});

  @override
  State<SetLockTile> createState() => _SetLockTileState();
}

class _SetLockTileState extends State<SetLockTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: ListTile(
        title: Text(
          'set_lock_enable_diary_lock_title'.tr(),
        ),
        subtitle: Text(
          'set_lock_enable_diary_lock_sub_title'.tr(),
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        trailing: Switch(
          value: active,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
