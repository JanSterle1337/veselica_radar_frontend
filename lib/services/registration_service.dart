import '../models/user.dart';
import '../dto/user_register_dto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrationService {
  Future<http.Response> registerUser(UserRegisterDTO user) async {

      const String url = 'http://10.0.2.2:7000/api/auth/register';

      UserRegisterDTO userRegisterDTO = UserRegisterDTO(
          name: user.name,
          lastName: user.lastName,
          email: user.email,
          password: user.password,
          confirmedPassword: user.confirmedPassword,
          role: user.role);

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode(userRegisterDTO.toJson())
      );

      return response;
  }
}