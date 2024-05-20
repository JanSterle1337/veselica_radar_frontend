import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:veselica_radar/widgets/bottom_navigation.dart';
import '../services/event_service.dart';
import 'add_event_screen.dart';
import '../dto/event_dto.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late GoogleMapController mapController;
  final LatLng _center = const LatLng(46.149, 15.2);
  late Future<List<EventDto>> _events = Future.value([]);

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Events'),
          actions: [
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
        body: FutureBuilder<List<EventDto>>(
          future: _events,
          builder: (context, snapshot) {
            if (_events == null) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(child: Text('No events found.'));
              } else {
                return GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 8.0
                  ),

                  markers: _buildMarkers(snapshot.data!),
                );
              }
            } else {
              return Center(child: Text('Loading...'));
            }
          },
        )
    );
  }

  Set<Marker> _buildMarkers(List<EventDto> events) {
    return events.map((event) {
      return Marker(
        markerId: MarkerId(event.name),
        position: LatLng(event.latitude, event.longitude),
        infoWindow: InfoWindow(
          title: event.name,
          snippet: event.location
        )
      );
    }).toSet();
  }
}