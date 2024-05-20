import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:veselica_radar/dto/user_login_dto.dart';
import 'package:veselica_radar/dto/user_profile_dto.dart';

class UserProfileService {
  Future<http.Response> show(int id, String token, String role) async {
    final String url = 'http://10.0.2.2:7000/api/user/$id';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    Map<String, dynamic> body = {
      'role': role
    };

    return await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body)
    );

  }
}