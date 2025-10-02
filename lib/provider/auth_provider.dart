import 'dart:ffi';

import 'package:flutter/widgets.dart';
import 'package:noviindus_ayurvedic/data/services/auth_services.dart';
import 'package:noviindus_ayurvedic/model/usermodel/user_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final Authservice _authservice = Authservice();
  String? _token;
  UserModel? _user;
  bool isloading = false;
  //Getters
  String? get token => _token;
  UserModel? get user => _user;
  bool get isAuthenticated => _token != null;
  bool get isLoading => isloading;

  ///login
  Future<void> login(String username, String password) async {
    isloading = true;
    notifyListeners();
    try {
      final data = await _authservice.login(username, password);
      _token = data["token"];
      _user = UserModel.fromJson(data["user_details"]);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("auth_token", token!);
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  ///autologin
  Future<void> loadtoken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString("auth_token");
    notifyListeners();
  }

  ///logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");
    _token = null;
    _user = null;
    notifyListeners();
  }
}
