import 'package:flutter/material.dart';
import '../pages/setting_page.dart';
import 'drawer_items.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
  }) : super(key: key);

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
                decoration: const BoxDecoration(
                  color: Color(0xFFE5F5FF),
                ),
                child: Image.asset('assets/images/drawer_header.png'),
              ),
              DrawerItems(
                icon: Icons.color_lens_outlined,
                title: "Theme",
                onTap: () {},
              ),
              const Divider(
                height: 10.0,
                indent: 15,
                endIndent: 20,
                thickness: 1,
              ),
              DrawerItems(
                icon: Icons.lock_outlined,
                title: "Diary Lock",
                onTap: () {},
              ),
              DrawerItems(
                icon: Icons.backup_outlined,
                title: "Backup & Restore",
                onTap: () {},
              ),
              const Divider(
                indent: 20,
                endIndent: 20,
                thickness: 1,
              ),
              DrawerItems(
                icon: Icons.card_giftcard_outlined,
                title: "Donate",
                onTap: () {},
              ),
              DrawerItems(
                icon: Icons.share_outlined,
                title: "Share App",
                onTap: () {},
              ),
              DrawerItems(
                icon: Icons.settings_outlined,
                title: "Settings",
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
