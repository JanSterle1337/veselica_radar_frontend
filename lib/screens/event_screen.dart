import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dto/event_dto.dart';  // Make sure this file contains the EventDto model
import '../services/event_service.dart';
import '../screens/event_specific_screen.dart';


class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late Future<List<EventDto>> _events;

  @override
  void initState() {
    super.initState();
    _events = EventService().getAllEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Events'),
      ),
      body: FutureBuilder<List<EventDto>>(
        future: _events,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No events found.'));
          } else {
            // Split events into confirmed and unconfirmed lists
            List<EventDto> confirmedEvents =
            snapshot.data!.where((event) => event.isConfirmed).toList();
            List<EventDto> unconfirmedEvents =
            snapshot.data!.where((event) => !event.isConfirmed).toList();

            return ListView(
              children: [
                _buildEventSection('Confirmed Events', confirmedEvents),
                _buildEventSection('Unconfirmed Events', unconfirmedEvents),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildEventSection(String title, List<EventDto> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return ListTile(
              leading: Icon(
                event.isConfirmed ? Icons.arrow_forward_ios_rounded : Icons.close_rounded,
                color: event.isConfirmed ? Colors.green : Colors.red,
              ),
              title: Text(event.name),
              subtitle: Text(event.location),
              onTap: () {

                if (event.isConfirmed) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventSpecificScreen(event: event),
                    )
                  );
                }

                // Handle tap if needed
              },
            );
          },
        ),
      ],
    );
  }
}