import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:veselica_radar/services/auth_provider.dart';
import 'package:veselica_radar/widgets/bottom_navigation.dart';
import '../services/event_service.dart';
import 'add_event_screen.dart';
import '../dto/event_dto.dart';
import '../services/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(46.149, 15.2);
  late Future<List<EventDto>> _events = Future.value([]);
  bool _attendanceStatus = false;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    //final authProvider = Provider.of<AuthProvider>(context, listen: false);
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      final events = await EventService().getAllEvents();
      setState(() {
        _events = Future.value(events);
        print(_events);
      });
    } catch (error) {
      print('Error fetching events: $error');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        print('Selected Date: $selectedDate');
      });
    }
  }

  void _resetFilter() {
    setState(() {
      selectedDate = null;
      fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        actions: [
          if (authProvider.isAuthenticated)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddEventScreen()),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  selectedDate == null
                      ? 'Select Date'
                      :  '${selectedDate!.toLocal()}'.split(' ')[0],
                ),
              ),
              TextButton(
                onPressed: _resetFilter,
                child: Text('Reset Filter'),
              ),
            ],

          ),
          Expanded(
            child: FutureBuilder<List<EventDto>>(
              future: _events,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<EventDto> filteredEvents = snapshot.data!;
                  if (selectedDate != null) {
                    filteredEvents = filteredEvents.where((event) {
                      return event.eventDate.year == selectedDate!.year &&
                          event.eventDate.month == selectedDate!.month &&
                          event.eventDate.day == selectedDate!.day;
                    }).toList();
                  }
                  if (filteredEvents.isEmpty) {
                    return Center(child: Text('No events found.'));
                  } else {
                    return GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _center,
                        zoom: 8.0,
                      ),
                      markers: _buildMarkers(filteredEvents),
                    );
                  }
                } else {
                  return Center(child: Text('Loading...'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> _buildMarkers(List<EventDto> events) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return events.map((event) {
      return Marker(
        markerId: MarkerId(event.name),
        position: LatLng(event.latitude, event.longitude),
        infoWindow: InfoWindow(
          title: event.name,
          snippet: event.location,
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text(
                      event.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          _buildEventDetail('Location', event.location),
                          _buildEventDetail('Entrance Fee', event.isEntranceFee ? event.entranceFee.toString() : 'No'),
                          _buildEventDetail('Event Date', event.eventDate.toLocal().toString().split(' ')[0]),
                          _buildEventDetail('Starting Hour', event.startingHour),
                          _buildEventDetail('Ending Hour', event.endingHour),
                          _buildEventDetail('Latitude', event.latitude.toString()),
                          _buildEventDetail('Longitude', event.longitude.toString()),
                          _buildEventDetail('Created At', event.createdAt.toLocal().toString().split(' ')[0]),
                          _buildEventDetail('Updated At', event.updatedAt.toLocal().toString().split(' ')[0]),
                        ],
                      ),
                    ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      );
    }).toSet();
  }

  Widget _buildEventDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateAttendanceStatus(bool newValue) async {
    if (newValue != null) {
      // Implement logic to send the updated status to the backend
      try {

        if (newValue == true) {
          _attendanceStatus = true;
        } else {
          _attendanceStatus = false;
        }

        print("SETTAMO STATUS NA ${newValue} and baje bomo klical backend endpoint");

        // Call the backend API to update the status
        // For example:
        // await EventService().updateAttendanceStatus(newValue);
        // Once the status is updated successfully, you may want to display a success message or perform other actions
      } catch (error) {
        // Handle any errors that occur during the API call
        print('Error updating attendance status: $error');
        // You may want to display an error message to the user
      }
    }
  }
}