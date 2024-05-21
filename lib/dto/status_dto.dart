class StatusDto {
  final int userId;
  final int eventId;
  final String status;

  StatusDto({
    required this.userId,
    required this.eventId,
    required this.status
  });

  factory StatusDto.fromJson(Map<String, dynamic> json) {
    return StatusDto(
        userId: json['user_id'],
        eventId: json['event_id'],
        status: json['status']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'event_id': eventId,
      'status': status
    };
  }

}