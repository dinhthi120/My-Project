import 'package:flutter/material.dart';
import 'package:flutter_memories_dailyjournal/pages/about_us_page.dart';
import 'package:flutter_memories_dailyjournal/pages/backup_and_restore.dart';
import 'package:flutter_memories_dailyjournal/pages/change_theme.dart';
import 'package:flutter_memories_dailyjournal/pages/home_page.dart';
import 'package:flutter_memories_dailyjournal/pages/language_page.dart';
import 'package:flutter_memories_dailyjournal/notification/notification_api.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_memories_dailyjournal/pages/privacy_policy_page.dart';
import 'package:flutter_memories_dailyjournal/pages/set_diary_lock.dart';
import 'package:flutter_memories_dailyjournal/pages/term_and_conditions.dart';
import '../services/secure_storage.dart';
import 'passcode_page.dart';

class SettingPage extends StatefulWidget {
  static const route = 'setting-page';
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text("drawer_settings".tr()),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Data Security
              ComponentTitle(
                title: 'setting_data_security'.tr(),
              ),
              SettingItems(
                icon: Icons.lock_outline,
                title: 'setting_diary_lock'.tr(),
                onTap: () {
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
              SettingItems(
                icon: Icons.cloud_upload_outlined,
                title: 'setting_backup_restore'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BackupAndRestore(),
                    ),
                  );
                },
              ),

              // Notifications
              ComponentTitle(
                title: 'setting_notifications'.tr(),
              ),
              const RemindTimeTile(
                time: '21:10',
              ),

              // Appearance
              ComponentTitle(
                title: 'setting_appearance'.tr(),
              ),
              SettingItems(
                icon: Icons.color_lens_outlined,
                title: 'setting_theme'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangeTheme(),
                    ),
                  );
                },
              ),

              SettingItems(
                icon: Icons.language,
                title: 'setting_language'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LanguagePage(),
                    ),
                  );
                },
              ),

              // Other
              ComponentTitle(
                title: 'setting_other'.tr(),
              ),
              SettingItems(
                icon: Icons.security,
                title: 'setting_privacy_policy'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyPage(),
                    ),
                  );
                },
              ),
              SettingItems(
                icon: Icons.shield,
                title: 'setting_tems_conditions'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsAndConditions(),
                    ),
                  );
                },
              ),
              SettingItems(
                icon: Icons.info_outline,
                title: 'setting_about_us'.tr(),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutUsPage(),
                    ),
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

class ComponentTitle extends StatelessWidget {
  final String title;

  const ComponentTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class SettingItems extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function() onTap;

  const SettingItems({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        onTap: onTap,
        leading: Icon(
          icon,
          size: 28,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class RemindTimeTile extends StatefulWidget {
  final String time;
  const RemindTimeTile({super.key, required this.time});

  @override
  State<RemindTimeTile> createState() => _RemindTimeTileState();
}

bool active = false;

class _RemindTimeTileState extends State<RemindTimeTile> {
  String selectedTime = "00:00";
  String checkNotification = "true";

  @override
  void initState() {
    init();
    NotificationApi().setup();

    super.initState();
  }

  Future init() async {
    String time = await SelectedTime.getTime() ?? "00:00";
    String check =
        await CheckScheduledNotification.getCheckNotificationActivate() ?? "";

    setState(() {
      selectedTime = time;
      checkNotification = check;
      if (check == 'true') {
        active = true;
      } else {
        active = false;
      }
    });
  }

  void callScheduledNotification() {
    NotificationApi.showScheduledNotification(
      title: 'Memories - Daily Journal',
      body: 'Time to write your new diary',
      payload: 'diary',
      hour: int.parse(selectedTime.split(":")[0]),
      minute: int.parse(selectedTime.split(":")[1]),
    );
  }

  Future<void> displayTimeDialog() async {
    String check =
        await CheckScheduledNotification.getCheckNotificationActivate() ?? "";

    final TimeOfDay? time = await showTimePicker(
      context: context,
      helpText: "clock_helper_text".tr(),
      initialTime: TimeOfDay(
        hour: int.parse(selectedTime.split(":")[0]),
        minute: int.parse(selectedTime.split(":")[1]),
      ),
      builder: (context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() {
        selectedTime = MaterialLocalizations.of(context)
            .formatTimeOfDay(time, alwaysUse24HourFormat: true)
            .toString();
        SelectedTime.setTime(selectedTime);
      });
      if (active == true) {
        if (check == "true") {
          callScheduledNotification();
        }
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        onTap: () {
          displayTimeDialog();
        },
        leading: const Icon(
          Icons.notifications,
          size: 28,
        ),
        title: Text(
          'setting_reminder'.tr(),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        subtitle: Text(
          selectedTime != "" ? selectedTime : '00:00',
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),
        trailing: Switch(
          value: active,
          onChanged: (bool value) async {
            setState(
              () {
                active = value;
              },
            );
            if (active == true) {
              CheckScheduledNotification.setCheckNotificationActivate('true');
              callScheduledNotification();
            } else {
              CheckScheduledNotification.setCheckNotificationActivate('false');
              FlutterLocalNotificationsPlugin().cancelAll();
            }
          },
        ),
      ),
    );
  }
}
