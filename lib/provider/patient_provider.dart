import 'package:flutter/material.dart';
import 'package:noviindus_ayurvedic/data/services/patience_services.dart';
import 'package:noviindus_ayurvedic/model/patients_model.dart';

class PatientProvider with ChangeNotifier {
  final PatienceApiservices _patienceApiservices = PatienceApiservices();
  List<Patient> _patients = [];
  bool _isloading = false;
  String? _errormessagel;
  List<Patient> get patients => _patients;
  bool get isloading => _isloading;
  String? get errormessagel => _errormessagel;
  Future<void> Fetchpatients(String token) async {
    _isloading = true;
    notifyListeners();
    try {
      _patients = await _patienceApiservices.getpatient(token);
      _errormessagel = null;
    } catch (e) {
      _errormessagel = e.toString();
    }
    _isloading = false;
    notifyListeners();
  }
}
