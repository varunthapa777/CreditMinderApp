import 'package:credit_minder_app/components/drawer_item.dart';
import 'package:credit_minder_app/service/auth_service.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final String? userName;
  MyDrawer({super.key, required this.userName});

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Drawer(
      child: Column(
        children: [
          Container(
            height: isPortrait ? 200 : 150,
            width: double.infinity,
            color: Colors.green,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  userName ?? "User",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DrawerItem(
                    icon: Icons.home,
                    title: "Home",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  DrawerItem(
                    icon: Icons.settings,
                    title: "Settings",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  DrawerItem(
                    icon: Icons.compare_arrows,
                    title: "Transactions",
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          ),
          DrawerItem(
            icon: Icons.logout,
            iconColor: Colors.red,
            title: "Logout",
            titleColor: Colors.red,
            onTap: () async {
              await authService.logUserOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/auth', (Route<dynamic> route) => false);
            },
          ),
          isPortrait ? const SizedBox(height: 25) : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
