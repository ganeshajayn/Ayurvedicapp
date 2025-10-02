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

  Future<bool> registerPatient({
    required String token,
    required String name,
    required String executive,
    required String payment,
    required String phone,
    required String address,
    required double totalAmount,
    required double discountAmount,
    required double advanceAmount,
    required double balanceAmount,
    required String dateTime,
    required String branchId,
    required List<int> maleTreatmentIds,
    required List<int> femaleTreatmentIds,
  }) async {
    final url = Uri.parse("${baseUrl}PatientUpdate");

    // Validate that we have at least some treatments
    if (maleTreatmentIds.isEmpty && femaleTreatmentIds.isEmpty) {
      throw Exception("At least one treatment must be selected");
    }

    // Ensure all required fields are not empty
    if (name.trim().isEmpty ||
        executive.trim().isEmpty ||
        phone.trim().isEmpty ||
        address.trim().isEmpty ||
        branchId.trim().isEmpty) {
      throw Exception("All required fields must be filled");
    }

    // Ensure numeric values are valid
    if (totalAmount < 0 ||
        discountAmount < 0 ||
        advanceAmount < 0 ||
        balanceAmount < 0) {
      throw Exception("Amount values cannot be negative");
    }

    final body = {
      "name": name.trim(),
      "excecutive": executive.trim(), // API spelling is "excecutive"
      "payment": payment.trim(),
      "phone": phone.trim(),
      "address": address.trim(),
      "total_amount": totalAmount.toStringAsFixed(
        0,
      ), // Remove decimals like Postman
      "discount_amount": discountAmount.toStringAsFixed(0),
      "advance_amount": advanceAmount.toStringAsFixed(0),
      "balance_amount": balanceAmount.toStringAsFixed(0),
      "date_nd_time": dateTime.trim(), // Format: 01/02/2024-10:24 AM
      "id": "", // Pass empty string as per API docs
      "male": maleTreatmentIds.isEmpty ? "" : maleTreatmentIds.join(","),
      "female": femaleTreatmentIds.isEmpty ? "" : femaleTreatmentIds.join(","),
      "branch": branchId.trim(),
      "treatments": [...maleTreatmentIds, ...femaleTreatmentIds].join(","),
    };

    try {
      print("=== PATIENT REGISTRATION DEBUG ===");
      print("URL: $url");
      print(
        "Token: ${token.substring(0, 20)}...",
      ); // Show first 20 chars of token
      print("Request body:");
      body.forEach((key, value) {
        print("  $key: $value");
      });

      final response = await http.post(
        url,
        headers: {"Authorization": "Bearer $token"},
        body: body, // Send as form data (Map<String, String>)
      );

      print("Response status: ${response.statusCode}");
      print("Response headers: ${response.headers}");
      print(
        "Response body (first 500 chars): ${response.body.length > 500 ? response.body.substring(0, 500) : response.body}",
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["status"] == true) {
          return true; // ✅ success
        } else {
          throw Exception(data["message"] ?? "Failed to register patient");
        }
      } else {
        throw Exception(
          "Failed with status: ${response.statusCode}. Response: ${response.body}",
        );
      }
    } catch (e) {
      print("Register Patient Exception : $e");
      throw Exception("Error registering patient: $e");
    }
  }
}
