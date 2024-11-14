import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../util/auth_response.dart';

class AuthService {
  Future<AuthResponse> logUserIn(String email, String password) async {
    final url = 'http://139.84.167.74/login';
    print(email);
    print(password);
    print("login...");
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final userId = responseData['userId'];
      final userName = responseData['userName'];

      // Save user ID in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', userName);
      await prefs.setInt('userId', userId);

      return AuthResponse(success: true, message: 'Login successful.');
    } else {
      return AuthResponse(
          success: false, message: 'Login failed. Please try again.');
    }
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }

  Future<void> logUserOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
    await prefs.remove('userId');
  }

  Future<AuthResponse> registerUser(
      String name, String email, String password) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      return AuthResponse(success: false, message: 'All fields are required.');
    }

    // Validate email format
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      return AuthResponse(success: false, message: 'Invalid email format.');
    }

    // Validate password length
    if (password.length < 6) {
      return AuthResponse(
          success: false,
          message: 'Password must be at least 6 characters long.');
    }

    final url = 'http://139.84.167.74/register';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return AuthResponse(success: true, message: 'Registration successful.');
    } else {
      return AuthResponse(
          success: false, message: 'Registration failed. Please try again.');
    }
  }
}
