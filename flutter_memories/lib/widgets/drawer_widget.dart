import 'package:flutter/material.dart';
import 'package:flutter_memories_dailyjournal/pages/set_diary_lock.dart';
import 'package:share_plus/share_plus.dart';
import '../pages/backup_and_restore.dart';
import '../pages/change_theme.dart';
import '../pages/passcode_page.dart';
import '../pages/setting_page.dart';
import '../services/secure_storage.dart';
import 'drawer_items.dart';
import 'package:easy_localization/easy_localization.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String text =
      'I am using Memories - Daily Journal to write down all my thoughts and memories. Share it to your friends!! \n https://drive.google.com/file/d/1nVPNvYPWJ9CFXg5m_GElScJzlMK_yZRi/view?usp=share_link';
  String subject = '';

  String securePin = "";

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

  void _onShare() async {
    final box = context.findRenderObject() as RenderBox?;

    await Share.share(
      text,
      subject: subject,
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(),
                child: Image.asset('assets/images/drawer_header.png'),
              ),
              DrawerItems(
                icon: Icons.color_lens_outlined,
                title: "drawer_theme".tr(),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingPage(),
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangeTheme(),
                    ),
                  );
                },
              ),
              const Divider(
                height: 10.0,
                indent: 15,
                endIndent: 20,
                thickness: 1,
              ),
              DrawerItems(
                icon: Icons.lock_outline,
                title: "drawer_diary_lock".tr(),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingPage(),
                    ),
                  );
                  if (securePin != "") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const PasscodePage(checked: 'checkToTurnOff'),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SetDiaryLock(),
                      ),
                    );
                  }
                },
              ),
              DrawerItems(
                icon: Icons.backup_outlined,
                title: "drawer_backup_restore".tr(),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BackupAndRestore(),
                    ),
                  );
                },
              ),
              const Divider(
                indent: 20,
                endIndent: 20,
                thickness: 1,
              ),
              // DrawerItems(
              //   icon: Icons.card_giftcard_outlined,
              //   title: "drawer_donate".tr(),
              //   onTap: () {},
              // ),
              DrawerItems(
                icon: Icons.share_outlined,
                title: "drawer_share_app".tr(),
                onTap: () {
                  _onShare();
                },
              ),
              DrawerItems(
                icon: Icons.settings_outlined,
                title: "drawer_settings".tr(),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
