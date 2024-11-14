import 'package:credit_minder_app/components/edit_text.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Edit Profile",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 40),
                EditText(
                    label: "Name: ",
                    text: "varun",
                    controller: nameController,
                    hintText: "Name",
                    obscureText: false)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
