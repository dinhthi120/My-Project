import 'package:flutter/material.dart';

import '../services/secure_storage.dart';
import 'home_page.dart';
import 'passcode_page.dart';

class ChangePage extends StatefulWidget {
  static const route = '/';
  const ChangePage({super.key});

  @override
  State<ChangePage> createState() => _ChangePageState();
}

class _ChangePageState extends State<ChangePage> with WidgetsBindingObserver {
  String userSession = "noPin";
  String securePin = "";

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    init();

    super.initState();
  }

  Future init() async {
    String pin = await PinSecureStorage.getPinNumber() ?? '';
    String checkUserSession = await CheckUserSession.getUserSession() ?? '';

    setState(() {
      securePin = pin;
      userSession = checkUserSession;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.detached) return;

    final isInActive = state == AppLifecycleState.inactive;

    // Delete user session
    if (isInActive) {
      CheckUserSession.deleteUserSession();
    }

    final isBackgroud = state == AppLifecycleState.paused;

    if (isBackgroud) {
      String pin = await PinSecureStorage.getPinNumber() ?? '';

      if (pin != "") {
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                const PasscodePage(checked: 'checkPassOnResume'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return securePin != ''
        ? userSession != 'logged'
            ? const PasscodePage(
                checked: 'checkPassOnCreate',
              )
            : const HomePage()
        : const HomePage();
  }
}
