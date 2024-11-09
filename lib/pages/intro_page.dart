import 'package:credit_minder_app/components/my_button.dart';
import 'package:credit_minder_app/pages/auth_page.dart';
import 'package:credit_minder_app/pages/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  void _getStarted(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monetization_on,
                size: 100, color: Colors.green.shade900),
            const SizedBox(height: 10),
            Text(
              'Credit Minder',
              style: TextStyle(
                  color: Colors.grey.shade900,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Never miss a repayment again!",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 150),
            MyButton(text: "Get started", onTap: () => _getStarted(context)),
          ],
        ),
      )),
    );
  }
}
