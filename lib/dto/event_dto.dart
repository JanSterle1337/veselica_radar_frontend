import 'package:flutter/material.dart';

class EventDto {
  final int id;
  final String name;
  final String location;
  final bool isEntranceFee;
  final double entranceFee;
  final DateTime eventDate;
  final String startingHour;
  final String endingHour;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int userId;
  final bool isConfirmed;


  EventDto({
    required this.id,
    required this.name,
    required this.location,
    required this.isEntranceFee,
    required this.entranceFee,
    required this.eventDate,
    required this.startingHour,
    required this.endingHour,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.isConfirmed,
  });

  factory EventDto.fromJson(Map<String, dynamic> json) {
    return EventDto(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      location: json['location'] as String? ?? '',
      isEntranceFee: json['is_entrance_fee'] as bool? ?? false,
      entranceFee: (json['entrance_fee'] as num?)?.toDouble() ?? 0.0,
      eventDate: json['event_date'] != null ? DateTime.parse(json['event_date']) : DateTime.now(),
      startingHour: json['starting_hour'] as String? ?? '',
      endingHour: json['ending_hour'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
      userId: json['user_id'] as int? ?? 0,
      isConfirmed: json['is_confirmed'] as bool? ?? false,
    );
  }

  /*factory EventDto.fromJson(Map<String, dynamic> json) {
    return EventDto(
        name: json['name'],
        location: json['location'],
        isEntranceFee: json['isEntranceFee'],
        entranceFee: json['entranceFee'],
        eventDate: DateTime.parse(json['eventDate']),
        startingHour:  DateTime.parse(json['startingHour']),
        endingHour: DateTime.parse(json['endingHour']),
        latitude: json['latitude'],
        longitude: json['longitude'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        userId: json['user'],
        isConfirmed: json['isConfirmed']
    );
  }*/

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'is_entrance_fee': isEntranceFee,
      'entrance_fee': entranceFee,
      'event_date': eventDate.toIso8601String(),
      'starting_hour': startingHour,
      'ending_hour': endingHour,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user_id': userId,
      'is_confirmed': isConfirmed,
    };
  }

}