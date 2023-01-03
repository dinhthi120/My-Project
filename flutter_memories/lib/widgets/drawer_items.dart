import 'package:flutter/material.dart';

class DrawerItems extends StatelessWidget {
  const DrawerItems({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.blue,
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
