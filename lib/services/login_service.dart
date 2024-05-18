import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:veselica_radar/dto/user_login_dto.dart';

class LoginService {
  Future<http.Response> login(UserLoginDTO user) async {
    const String url = 'http://10.0.2.2:7000/api/auth/login';

    UserLoginDTO userLoginDTO = UserLoginDTO(
      email: user.email,
      password: user.password
    );

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode(userLoginDTO.toJson())
    );

    return response;
  }
}