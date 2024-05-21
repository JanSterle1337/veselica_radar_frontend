import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dto/status_dto.dart';

class StatusService {
  Future<http.Response> updateUserEventAttendance(int userId, int eventId, String status) async {
    const String url = 'http://10.0.2.2:7000/api/statuses';

    StatusDto statusDto = StatusDto(
        userId: userId,
        eventId: eventId,
        status: status
    );

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode(statusDto.toJson())
    );

    print("PRINTAMO V SERVICU");


    return response;

  }

  Future<http.Response> getUserEventAttendanceStatus(int userId, int eventId) async {
    final String url = 'http://10.0.2.2:7000/api/statuses/$userId/$eventId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print("Get Status Response from server: ${response.body}");
    return response;
  }

}