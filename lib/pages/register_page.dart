import 'package:credit_minder_app/components/my_button.dart';
import 'package:credit_minder_app/components/my_textfield.dart';
import 'package:credit_minder_app/components/sqaure_tile.dart';
import 'package:credit_minder_app/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatelessWidget {
  final Function()? toggleLoginRegister;

  RegisterPage({super.key, required this.toggleLoginRegister});

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  AuthService auth = AuthService();

  void registerUser() async {
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final name = nameController.text;

    if (password != confirmPassword) {
      // Handle password mismatch
      print('Passwords do not match');
      return;
    }

    try {
      // Register user
      await auth.registerUser(name, email, password);
      toggleLoginRegister!();
    } catch (e) {
      // Handle registration failure
      Fluttertoast.showToast(
        msg: "failed to register",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
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
                      radius: 30,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    Icon(Icons.person,
                        size: 50,
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ]),

                  const SizedBox(height: 25),
                  // welcome message
                  Text(
                    'Make an account to get started.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  // name input
                  MyTextfield(
                    controller: nameController,
                    hintText: "Full Name",
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  // email input
                  MyTextfield(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),

                  // password input
                  MyTextfield(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),

                  // password input
                  MyTextfield(
                    controller: confirmPasswordController,
                    hintText: "Confirm password",
                    obscureText: true,
                  ),

                  const SizedBox(height: 25),
                  // login button
                  MyButton(text: "Register", onTap: registerUser),

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
                      Text('Already have an account?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 16,
                          )),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: toggleLoginRegister,
                        child: Text("Login",
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
