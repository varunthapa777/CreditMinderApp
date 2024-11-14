import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final Color? titleColor;
  final Function()? onTap;
  const DrawerItem(
      {super.key,
      required this.icon,
      required this.title,
      this.onTap,
      this.iconColor,
      this.titleColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        leading: Icon(
          icon,
          color: iconColor ?? Theme.of(context).colorScheme.inversePrimary,
          size: 30,
        ),
        title: Text(
          title,
          style: TextStyle(
              color:
                  titleColor ?? Theme.of(context).colorScheme.inversePrimary),
        ),
        onTap: onTap,
      ),
    );
  }
}
