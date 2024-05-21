import 'dart:convert';

import 'package:flutter/material.dart';
import '../dto/event_dto.dart';
import '../services/auth_provider.dart';
import 'package:provider/provider.dart';
import '../services/status_service.dart';
import 'package:http/http.dart' as http;

class EventSpecificScreen extends StatefulWidget {
  final EventDto event;

  EventSpecificScreen({required this.event});

  @override
  _EventSpecificScreenState createState() => _EventSpecificScreenState();
}

class _EventSpecificScreenState extends State<EventSpecificScreen> {
  bool _isAttending = false; // Initialize attendance status to false
  Future<http.Response>? _userStatusFuture;
  int? userId;
  int? eventId;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    userId = authProvider.userId;
    eventId = widget.event.id; // Assuming you get eventId from the event passed to the widget

    _fetchUserEventAttendanceStatus();
  }

  void updateUserStatus() {
    setState(() {
      _userStatusFuture = StatusService().updateUserEventAttendance(
        userId!,
        widget.event.id!,
        _isAttending ? 'Going' : 'Not Going', // Switch status based on the value
      );
    });
  }
  
  void _fetchUserEventAttendanceStatus() async {
    final response = await StatusService().getUserEventAttendanceStatus(userId!, eventId!);

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        _isAttending = responseData['status'] == 'Going';
      });
    } else {
      print('Failed to load status');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${widget.event.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Location: ${widget.event.location}'),
            SizedBox(height: 8),
            Text('Event Date: ${widget.event.eventDate.toLocal().toString().split(' ')[0]}'),
            SizedBox(height: 8),
            Text('Starting Hour: ${widget.event.startingHour}'),
            SizedBox(height: 8),
            Text('Ending Hour: ${widget.event.endingHour}'),
            SizedBox(height: 8),
            Text('Is Confirmed: ${widget.event.isConfirmed}'),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Will you attend the event?'),
                Switch(
                  value: _isAttending,
                  onChanged: (value) {
                    setState(() {
                      _isAttending = value;
                    });
                    updateUserStatus();
                  },
                ),
              ],
            ),
            FutureBuilder<http.Response>(
              future: _userStatusFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('Updating status...');
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text('Failed to update status');
                  } else if (snapshot.hasData && snapshot.data!.statusCode == 201) {
                    return Text('Status updated successfully');
                  } else {
                    return Text('Unexpected error');
                  }
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}