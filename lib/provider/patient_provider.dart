import 'package:flutter/material.dart';
import 'package:noviindus_ayurvedic/data/services/patience_services.dart';
import 'package:noviindus_ayurvedic/model/patientmodel/patients_model.dart';

class PatientProvider with ChangeNotifier {
  final PatienceApiservices _patienceApiservices = PatienceApiservices();
  List<Patient> _patients = [];
  bool _isLoading = false;
  String? _errorMessage;
  List<Patient> get patients => _patients;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Future<void> fetchPatients(String token) async {
    _isLoading = true;
    notifyListeners();
    try {
      _patients = await _patienceApiservices.getpatient(token);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addPatient({
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
    _isLoading = true;
    notifyListeners();

    try {
      final success = await _patienceApiservices.registerPatient(
        token: token,
        name: name,
        executive: executive,
        payment: payment,
        phone: phone,
        address: address,
        totalAmount: totalAmount,
        discountAmount: discountAmount,
        advanceAmount: advanceAmount,
        balanceAmount: balanceAmount,
        dateTime: dateTime,
        branchId: branchId,
        maleTreatmentIds: maleTreatmentIds,
        femaleTreatmentIds: femaleTreatmentIds,
      );

      if (success) {
        await fetchPatients(token);
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
