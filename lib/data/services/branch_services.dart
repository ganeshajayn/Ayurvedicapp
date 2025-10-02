import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:noviindus_ayurvedic/model/patientmodel/patients_model.dart';

class BranchServices {
  static const String baseurl = "https://flutter-amr.noviindus.in/api/";
  Future<List<Branch>> getbranch(String token) async {
    try {
      final url = Uri.parse("${baseurl}BranchList");
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == true) {
          return (data["branches"] as List)
              .map((json) => Branch.fromJson(json))
              .toList();
        } else {
          throw Exception(data["message"]);
        }
      } else {
        print("failed to load branches");
        throw Exception("Failed to load branches");
      }
    } catch (e) {
      print("error in branch :$e");
      throw Exception("Failed to fetch branches: $e");
    }
  }

  Future<List<Treatment>> gettreatment(String token) async {
    try {
      final url = Uri.parse("${baseurl}TreatmentList");
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == true) {
          return (data["treatments"] as List)
              .map((json) => Treatment.fromJson(json))
              .toList();
        } else {
          throw Exception(data["message"]);
        }
      } else {
        throw Exception("Failed to load treatments: ${response.statusCode}");
      }
    } catch (e) {
      print("error in treatment: $e");
      throw Exception("Failed to fetch treatments: $e");
    }
  }
}
