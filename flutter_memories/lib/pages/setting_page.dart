import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  static const route = 'setting-page';
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: const Color(0xFFE5F5FF),
        title: const Text('Settings'),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
      backgroundColor: const Color(0xFFE5F5FF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Data Scurity
            const ComponentTitle(
              title: 'Data Security',
            ),
            SettingItems(
              icon: Icons.lock_outline,
              title: 'Diary Lock',
              onTap: () {
                Navigator.pushReplacementNamed(context, 'set-lock');
              },
            ),
            SettingItems(
              icon: Icons.cloud_upload_outlined,
              title: 'Backup & Restore',
              onTap: () {},
            ),

            // Notifications
            const ComponentTitle(
              title: 'Notifications',
            ),
            const RemindTimeTile(
              time: '21:10',
            ),

            // Appearance
            const ComponentTitle(
              title: 'Appearance',
            ),
            SettingItems(
              icon: Icons.color_lens_outlined,
              title: 'Theme',
              onTap: () {},
            ),

            // Other
            const ComponentTitle(
              title: 'Other',
            ),
            SettingItems(
              icon: Icons.security,
              title: 'Privacy Policy',
              onTap: () {},
            ),
            SettingItems(
              icon: Icons.shield,
              title: 'Tems & Conditions',
              onTap: () {},
            ),
            SettingItems(
              icon: Icons.info_outline,
              title: 'About us',
              onTap: () {},
            ),
          ],
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
          color: Colors.black,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Icon(
                icon,
                color: Colors.blueAccent,
                size: 28,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
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

bool active = true;

class _RemindTimeTileState extends State<RemindTimeTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Icon(
                Icons.notifications,
                size: 28,
                color: Colors.blueAccent,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reminder time',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    widget.time,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Switch(
                value: active,
                onChanged: (bool value) {
                  setState(
                    () {
                      active = value;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
