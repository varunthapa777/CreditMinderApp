import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RecordService {
  Future<void> addRecord(int userId, String name, String amount, bool settled,
      String dueDate, String phoneNumber) async {
    final url = 'http://139.84.167.74/addRecord';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'name': name,
        'amount': amount,
        'settled': settled,
        'due_date': dueDate,
        'phone_number': phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      print('Record added successfully');
    } else {
      print('Failed to add record');
    }
  }

  Future<void> updateRecord(
      int recordId, String name, String dueDate, String phoneNumber) async {
    final url = 'http://139.84.167.74/updateRecord';
    final response = await http.patch(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': recordId,
        'name': name,
        'due_date': dueDate,
        'phone_number': phoneNumber,
      }),
    );

    if (response.statusCode == 200) {
      print('Record updated successfully');
    } else {
      print('Failed to update record');
    }
  }

  Future<void> updateRecordAmount(
      int recordId, String amount, bool settled) async {
    final url = 'http://139.84.167.74/updateRecordAmount';
    final response = await http.patch(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': recordId,
        'amount': amount,
        'settled': settled,
      }),
    );

    if (response.statusCode == 200) {
      print('Record amount updated successfully');
    } else {
      print('Failed to update record amount');
    }
  }

  Future<void> deleteRecord(int recordId) async {
    final url = 'http://139.84.167.74/deleteRecord';
    final response = await http.delete(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'id': recordId}),
    );

    if (response.statusCode == 200) {
      print('Record deleted successfully');
    } else {
      print('Failed to delete record');
    }
  }

  Future<List<Map<String, dynamic>>> getRecords(int userId) async {
    final url = 'http://139.84.167.74/getRecords?userId=$userId';
    final response = await http
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      List<dynamic> records = jsonDecode(response.body);
      return records
          .map((record) => {
                'id': record['id'],
                'name': record['name'],
                'amount': record['amount'],
                'settled': record['settled'] == 1, // Convert 0/1 to boolean
                'due_date': record['due_date'],
                'phone_number': record['phone_number'],
                'created_at': record['created_at'],
              })
          .toList();
    } else {
      throw Exception('Failed to load records');
    }
  }
}
