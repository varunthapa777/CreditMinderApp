import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RecordService {
  Future<void> addRecord(int userId, String name, String amount, bool settled,
      String dueDate) async {
    final url = 'http://139.84.167.74/addRecord';

    print(dueDate);

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'name': name,
        'amount': amount,
        'settled': settled,
        'due_date': dueDate,
      }),
    );

    if (response.statusCode == 200) {
      print('Record added successfully');
    } else {
      print('Failed to add record');
    }
  }

  Future<List<Map<String, dynamic>>> getRecords(int userId) async {
    final url = 'http://139.84.167.74/getRecords?userId=$userId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> records = jsonDecode(response.body);
      return records
          .map((record) => {
                'id': record['id'],
                'name': record['name'],
                'amount': record['amount'],
                'settled': record['settled'] == 1, // Convert 0/1 to boolean
                'due_date': record['due_date'],
                'created_at': record['created_at'],
              })
          .toList();
    } else {
      throw Exception('Failed to load records');
    }
  }
}
