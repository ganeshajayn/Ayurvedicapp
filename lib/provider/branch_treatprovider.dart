import 'package:flutter/material.dart';
import 'package:noviindus_ayurvedic/data/services/branch_services.dart';
import 'package:noviindus_ayurvedic/model/patients_model.dart';

class Brachtreatmentprovider with ChangeNotifier {
  final BranchServices _branchServices = BranchServices();
  bool isLoading = false;
  String? errorMessage;

  List<Branch> branches = [];
  Future<void> fetchbranches(String token) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      branches = await _branchServices.getbranch(token);
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }
}
