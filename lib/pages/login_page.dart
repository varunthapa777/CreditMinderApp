import 'package:credit_minder_app/components/my_button.dart';
import 'package:credit_minder_app/components/my_textfield.dart';
import 'package:credit_minder_app/components/sqaure_tile.dart';
import 'package:credit_minder_app/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatelessWidget {
  final Function()? toggleLoginRegister;

  LoginPage({super.key, required this.toggleLoginRegister});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  void logUserIn(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;

    final success = await authService.logUserIn(email, password);
    if (success) {
      Navigator.pushNamed(context, '/home');
    } else {
      // Handle login failure
      Fluttertoast.showToast(
        msg: "Failed to login",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        textColor: Theme.of(context).colorScheme.inversePrimary,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // logo
                  Stack(alignment: Alignment.center, children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    Icon(Icons.person,
                        size: 100,
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ]),

                  const SizedBox(height: 25),
                  // welcome message
                  Text(
                    'Welcome back! You\'ve been missed!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 50),
                  // email input
                  MyTextfield(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),
                  const SizedBox(height: 25),

                  // password input
                  MyTextfield(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  // forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // login button
                  MyButton(text: "Login", onTap: () => logUserIn(context)),

                  // sign up
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade400)),
                      const SizedBox(width: 10),
                      Text(
                        "Or continue with",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Divider(color: Colors.grey.shade400)),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SqaureTile(
                          imagePath: 'assets/images/google.png', onTap: () {})
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16,
                          )),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: toggleLoginRegister,
                        child: Text("Register now",
                            style: TextStyle(
                              color: Colors.blue.shade400,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
