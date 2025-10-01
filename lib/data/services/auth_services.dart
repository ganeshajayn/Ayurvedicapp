import 'dart:convert';

import 'package:http/http.dart' as http;

class Authservice {
  static const String baseurl = "https://flutter-amr.noviindus.in/api/";
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse("${baseurl}Login");
    try {
      var response = await http.post(
        url,
        body: {"username": username, "password": password},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == true) {
          return data;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error logging in: $e");
    }
  }
}
