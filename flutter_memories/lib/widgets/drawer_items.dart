import 'package:flutter/material.dart';

class DrawerItems extends StatelessWidget {
  const DrawerItems({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      leading: Icon(
        icon,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}
