import 'dart:ffi';

import 'package:flutter/material.dart';

class AddEventDto {
  String name;
  String location;
  bool isEntranceFee;
  double? entranceFee;
  DateTime? eventDate;
  DateTime? startingHour;
  DateTime? endingHour;
  int userId;
  bool isConfirmed;


  AddEventDto({
    required this.name,
    required this.location,
    required this.isEntranceFee,
    this.entranceFee,
    required this.eventDate,
    required this.startingHour,
    required this.endingHour,
    required this.userId,
    required this.isConfirmed
  });

  factory AddEventDto.fromJson(Map<String, dynamic> json) {
    return AddEventDto(
        name: json['name'],
        location: json['location'],
        isEntranceFee: json['isEntranceFee'],
        entranceFee: json['entranceFee'],
        eventDate: DateTime.parse(json['eventDate']),
        startingHour:  DateTime.parse(json['startingHour']),
        endingHour: DateTime.parse(json['endingHour']),
        userId: json['userId'],
        isConfirmed: json['isConfirmed']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name' : name,
      'location': location,
      'is_entrance_fee': isEntranceFee,
      'entrance_fee': entranceFee,
      'event_date': eventDate?.toIso8601String(),
      'starting_hour': startingHour?.toIso8601String(),
      'ending_hour': endingHour?.toIso8601String(),
      'user_id': userId,
      'is_confirmed': isConfirmed
    };
  }

}