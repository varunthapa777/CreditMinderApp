import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/auth_page.dart';
import 'pages/home_page.dart';
import 'pages/intro_page.dart';
import 'theme/light_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
  print(hasSeenIntro);
  runApp(MyApp(
    hasSeenIntro: hasSeenIntro,
  ));
}

class MyApp extends StatelessWidget {
  final bool hasSeenIntro;
  const MyApp({super.key, required this.hasSeenIntro});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: hasSeenIntro ? const AuthPage() : const IntroPage(),
        routes: {
          '/home': (_) => HomePage(),
          '/auth': (_) => AuthPage(),
        });
  }
}
