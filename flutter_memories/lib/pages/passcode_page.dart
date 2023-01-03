import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import '../services/secure_storage.dart';

class PasscodePage extends StatefulWidget {
  static const route = 'passcode-page';

  const PasscodePage({super.key});

  @override
  State<PasscodePage> createState() => _PasscodePageState();
}

class _PasscodePageState extends State<PasscodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/passcode-img.png',
              ),
            ),
          ),
          child: PassCodeScreen()),
    );
  }
}

class PassCodeScreen extends StatefulWidget {
  const PassCodeScreen({super.key});

  @override
  State<PassCodeScreen> createState() => _PassCodeScreenState();
}

class _PassCodeScreenState extends State<PassCodeScreen> {
  List<String> currentPin = ["", "", "", ""];
  TextEditingController pinOneController = TextEditingController();
  TextEditingController pinTwoController = TextEditingController();
  TextEditingController pinThreeController = TextEditingController();
  TextEditingController pinFourController = TextEditingController();

  int pinIndex = 0;

  String oldPin = '';
  String firstPin = '';
  String confirmPin = '';

  // Read Pin nummber from secure storage
  String securePin = '';

  @override
  void initState() {
    super.initState();

    init();
  }

  Future init() async {
    String pin = await PinSecureStorage.getPinNumber() ?? '';

    setState(() {
      securePin = pin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          buildBackButton(),
          Expanded(
            child: Container(
              alignment: const Alignment(0, 0.1),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildSecurityText(),
                  const SizedBox(height: 100),
                  buildPinRow(),
                ],
              ),
            ),
          ),
          buildKeyBoard(),
        ],
      ),
    );
  }

  buildBackButton() {
    return Container(
      alignment: Alignment.topLeft,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(8),
      child: MaterialButton(
        onPressed: () async {
          // Delete Pin from secure storage
          PinSecureStorage.deletePinNumber();
          await Navigator.pushReplacementNamed(context, 'setting-page');
          // ignore: use_build_context_synchronously
          showFlushBar(context, 'Cancel Create Pin');
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
    );
  }

  buildSecurityText() {
    return securePin == ""
        ? Column(
            children: [
              firstPin == ""
                  ? Text(
                      "enter your new pin".toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Text(
                      "Confirm your pin".toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              // Display Pin from secure storage
              // Text(
              //   "your pin is $text".toUpperCase(),
              //   style: const TextStyle(
              //     color: Colors.white,
              //     fontSize: 24,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
            ],
          )
        : Column(
            children: [
              securePin != oldPin
                  ? Text(
                      "Enter your old Pin".toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Column(
                      children: [
                        firstPin == ""
                            ? Text(
                                "Enter your new Pin".toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                "Confirm your new pin $firstPin $oldPin"
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ],
                    ),
            ],
          );
  }

  buildPinRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PinNumber(
          textEditingController: pinOneController,
        ),
        PinNumber(
          textEditingController: pinTwoController,
        ),
        PinNumber(
          textEditingController: pinThreeController,
        ),
        PinNumber(
          textEditingController: pinFourController,
        ),
      ],
    );
  }

  buildKeyBoard() {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                    n: 1,
                    onPressed: () {
                      pinIndexSetup("1");
                    },
                  ),
                  KeyboardNumber(
                    n: 2,
                    onPressed: () {
                      pinIndexSetup("2");
                    },
                  ),
                  KeyboardNumber(
                    n: 3,
                    onPressed: () {
                      pinIndexSetup("3");
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                    n: 4,
                    onPressed: () {
                      pinIndexSetup("4");
                    },
                  ),
                  KeyboardNumber(
                    n: 5,
                    onPressed: () {
                      pinIndexSetup("5");
                    },
                  ),
                  KeyboardNumber(
                    n: 6,
                    onPressed: () {
                      pinIndexSetup("6");
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  KeyboardNumber(
                    n: 7,
                    onPressed: () {
                      pinIndexSetup("7");
                    },
                  ),
                  KeyboardNumber(
                    n: 8,
                    onPressed: () {
                      pinIndexSetup("8");
                    },
                  ),
                  KeyboardNumber(
                    n: 9,
                    onPressed: () {
                      pinIndexSetup("9");
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    width: 60,
                    child: MaterialButton(
                      onPressed: null,
                      child: SizedBox(),
                    ),
                  ),
                  KeyboardNumber(
                    n: 0,
                    onPressed: () {
                      pinIndexSetup("0");
                    },
                  ),
                  // Del button
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(60),
                    ),
                    width: 60,
                    child: MaterialButton(
                      height: 60,
                      onPressed: () {
                        clearPin();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Image.asset(
                        'assets/images/del-icon.png',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  clearPinField() {
    // Clear Pin row
    setState(() {
      pinIndex = 0;
      pinOneController.clear();
      pinTwoController.clear();
      pinThreeController.clear();
      pinFourController.clear();
    });
  }

  pinIndexSetup(String text) async {
    if (pinIndex == 0) {
      pinIndex = 1;
    } else if (pinIndex < 4) {
      pinIndex++;
    }
    setPin(pinIndex, text);
    setState(() {
      currentPin[pinIndex - 1] = text;
    });
    String strPin = "";
    for (var e in currentPin) {
      strPin += e;
    }
    if (securePin == "") {
      if (pinIndex == 4 && firstPin == '') {
        setState(() {
          firstPin = strPin;
        });
        showFlushBar(
          context,
          'Input your Pin again',
        );
        clearPinField();
      }
      if (pinIndex == 4 && firstPin != '') {
        setState(() {
          confirmPin = strPin;
        });
        if (firstPin != confirmPin) {
          showFlushBar(
            context,
            'Pin does not match',
          );

          clearPinField();
        }
        if (firstPin == confirmPin) {
          // Set Pin Number to secure storage
          await PinSecureStorage.setPinNumber(confirmPin);
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, 'question-page');
        }
      }
    }
    if (securePin != "") {
      if (pinIndex == 4 && oldPin == "") {
        setState(() {
          oldPin = strPin;
        });
        if (oldPin != securePin) {
          // ignore: use_build_context_synchronously
          showFlushBar(
            context,
            'Old Pin does not match',
          );
          clearPinField();
        } else {
          setState(() {
            oldPin = strPin;
          });
          // ignore: use_build_context_synchronously
          showFlushBar(
            context,
            'Enter your new pin',
          );
          clearPinField();
        }
      }
      if (pinIndex == 4 && oldPin != "") {
        if (pinIndex == 4 && firstPin == "") {
          setState(() {
            firstPin = strPin;
          });
          // ignore: use_build_context_synchronously
          showFlushBar(
            context,
            'Enter your Pin again',
          );
          clearPinField();
        }
        if (pinIndex == 4 && firstPin != '') {
          setState(() {
            confirmPin = strPin;
          });
          if (firstPin != confirmPin) {
            // ignore: use_build_context_synchronously
            showFlushBar(
              context,
              'Pin does not match',
            );
            clearPinField();
          }
          if (firstPin == confirmPin) {
            // Set Pin Number to secure storage
            await PinSecureStorage.setPinNumber(confirmPin);
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, 'setting-page');
            // ignore: use_build_context_synchronously
            showFlushBar(
              context,
              'Change Pin successfully',
            );
          }
        }
      }
    }
  }

  setPin(int n, String text) {
    switch (n) {
      case 1:
        pinOneController.text = text;
        break;
      case 2:
        pinTwoController.text = text;
        break;
      case 3:
        pinThreeController.text = text;
        break;
      case 4:
        pinFourController.text = text;
        break;
    }
  }

  clearPin() {
    if (pinIndex == 0) {
      pinIndex = 0;
    } else if (pinIndex == 4) {
      setPin(pinIndex, "");
      setState(() {
        currentPin[pinIndex - 1] = "";
      });
      pinIndex--;
    } else {
      setPin(pinIndex, "");
      setState(() {
        currentPin[pinIndex - 1] = "";
      });
      pinIndex--;
    }
  }
}

class PinNumber extends StatelessWidget {
  final TextEditingController textEditingController;

  const PinNumber({
    super.key,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      width: 50,
      child: TextField(
        controller: textEditingController,
        autofocus: false,
        enabled: true,
        readOnly: true,
        obscureText: true,
        obscuringCharacter: "*",
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          enabledBorder: textEditingController.text.isEmpty
              ? UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey[400]!,
                    width: 2,
                  ),
                )
              : InputBorder.none,
        ),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 21,
          color: Colors.white,
        ),
      ),
    );
  }
}

class KeyboardNumber extends StatelessWidget {
  final int n;
  final Function() onPressed;
  const KeyboardNumber({
    super.key,
    required this.n,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[400]!,
      ),
      alignment: Alignment.center,
      child: MaterialButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(60),
        ),
        height: 60,
        child: Text(
          "$n",
          style: const TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

void showFlushBar(context, message) {
  Flushbar(
    borderRadius: BorderRadius.circular(20),
    margin: const EdgeInsets.only(top: 18, left: 54, right: 54),
    padding: EdgeInsets.zero,
    flushbarStyle: FlushbarStyle.FLOATING,
    flushbarPosition: FlushbarPosition.TOP,
    animationDuration: const Duration(milliseconds: 1000),
    duration: const Duration(seconds: 1),
    messageText: Container(
      alignment: Alignment.center,
      height: 60,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  ).show(context);
}
