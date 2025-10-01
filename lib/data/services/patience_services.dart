import 'dart:convert';

import 'package:noviindus_ayurvedic/model/patients_model.dart';
import 'package:http/http.dart' as http;

class PatienceApiservices {
  static const String baseUrl = "https://flutter-amr.noviindus.in/api/";
  Future<List<Patient>> getpatient(String token) async {
    final url = Uri.parse("${baseUrl}PatientList");
    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == true) {
          List patientjson = data['patient'];
          return patientjson.map((e) => Patient.fromJson(e)).toList();
        } else {
          throw Exception(data["message"]);
        }
      } else {
        throw Exception("Failed to Load Patient");
      }
    } catch (e) {
      print("Exception :$e");
      throw Exception("Error Fetching Patient :$e ");
    }
  }
}
