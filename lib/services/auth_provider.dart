import 'dart:ffi';

import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _role;
  int? _userId;

  String? get token => _token;
  String? get role => _role;
  int? get userId => _userId;

  bool get isAuthenticated => _token != null;

  void login(String token, String role, int userId) {
    _token = token;
    _role = role;
    _userId = userId;
    notifyListeners();
  }

  void logout() {
    _token = null;
    _role = null;
    _userId = null;
    notifyListeners();
  }
}