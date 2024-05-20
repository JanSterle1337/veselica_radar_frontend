import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:veselica_radar/dto/event_dto.dart';
import '../dto/add_event_dto.dart';

class EventService {
  Future<http.Response> storeEvent(AddEventDto event, String token, String role) async {
    const String url = 'http://10.0.2.2:7000/api/events';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    AddEventDto newEventDTO = AddEventDto(
        name: event.name,
        location: event.location,
        isEntranceFee: event.isEntranceFee,
        entranceFee: event.entranceFee,
        eventDate: event.eventDate,
        startingHour: event.startingHour,
        endingHour: event.endingHour,
        userId: event.userId,
        isConfirmed: false,
    );

    print("new event dto: ${newEventDTO}");

    Map<String, dynamic> roleInfo = {
      'is_confirmed': false,
      'role': role
    };

    print("Role info: ${roleInfo}");

    Map<String, dynamic> combinedData = {
      ...newEventDTO.toJson(),
      'role': roleInfo
    };

    print("Combined data: ${combinedData}");


    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(combinedData)
    );



    return response;

  }

  Future<List<EventDto>> getAllEvents() async {

    print("Delamo request na backend da dobimo evente");

    const String url = 'http://10.0.2.2:7000/api/events';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      print("RESPONSE BODY: ${response.body}");
      //print("Baje da smo dobil data: ${data.toString()}");

      return data.map((json) => EventDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to laod events');
    }

  }


}