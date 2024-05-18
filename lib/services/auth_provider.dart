import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _role;

  String? get token => _token;
  String? get role => _role;

  bool get isAuthenticated => _token != null;

  void login(String token, String role) {
    _token = token;
    _role = role;
    notifyListeners();
  }

  void logout() {
    _token = null;
    _role = null;
    notifyListeners();
  }
}