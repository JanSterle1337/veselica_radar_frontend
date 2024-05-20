import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:veselica_radar/dto/add_event_dto.dart';
import 'package:intl/intl.dart';
import 'package:veselica_radar/services/event_service.dart';
import 'package:veselica_radar/services/registration_service.dart';
import '../services/auth_provider.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String location = '';
  bool isEntranceFee = false;
  double entranceFee = 0.0;
  DateTime? eventDate;
  DateTime? startingHour;
  DateTime? endingHour;

  final EventService _eventService = EventService();
  late AuthProvider authProvider;
  bool _isLoading = false;


  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      authProvider = Provider.of<AuthProvider>(context, listen: false);
    });

  }

  void _submitForm() async {


    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
    }

    print("ENTRANCE FEE JE ${entranceFee}");


    AddEventDto newEvent = AddEventDto(
      name: name,
      location: location,
      isEntranceFee: isEntranceFee,
      entranceFee: entranceFee,
      eventDate: eventDate,
      startingHour: startingHour,
      endingHour: endingHour,
      userId: authProvider.userId ?? 1,
      isConfirmed: false
    );

    final token = authProvider.token;
    final role = authProvider.role;

    if (token != null && token.isNotEmpty && role != null && role == 'user') {
      try {

        print("Token: ${token}");
        print("Role: ${role}");

        print(newEvent.toJson());

        final response = await _eventService
            .storeEvent(newEvent, token, role)
            .timeout(const Duration(seconds: 8));


        if (response.statusCode == 200 || response.statusCode == 201) {
          print(jsonDecode(response.body));

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Event added successfuly')),
          );

          Navigator.pushReplacementNamed(context, '/');
        } else {

          print("Ni ok");
          print(jsonDecode(response.body));
          final responseBody = jsonDecode(response.body);

          if (responseBody.containsKey('errors')) {
            responseBody['errors'].forEach((field, messages) {
              for (var message in messages) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message),)
                );
              }

              setState(() {
                _isLoading = false;
              });
            });


          }
          else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('An error occurred. Please try again.')),
            );
          }

        }

      } on TimeoutException catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request timed out. Please try again.')),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        print("Error: ${e.toString()}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101)
    );

    if (picked != null && picked != eventDate) {
      setState(() {
        eventDate = picked;
      });
    }
  }

  Future<void> _selectStartingHour(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(startingHour ?? DateTime.now()),
    );
    if (picked != null) {
      setState(() {
        startingHour = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Future<void> _selectEndingHour(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(endingHour ?? DateTime.now()),
    );
    if (picked != null) {
      setState(() {
        endingHour = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event name';
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event location';
                  }
                  return null;
                },
                onSaved: (value) {
                  location = value!;
                },
              ),
              SwitchListTile(
                title: Text('Is there an entrance fee?'),
                value: isEntranceFee,
                onChanged: (value) {
                  setState(() {
                    isEntranceFee = value;
                  });
                },
              ),
              Visibility(
                visible: isEntranceFee,
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Entrance Fee'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the entrance fee";
                    }

                    // Check if the value is a valid number (integer or double)
                    if (double.tryParse(value) == null) {
                      return "Entrance fee must be a number";
                    }

                    return null;
                  },
                  onSaved: (value) {
                    entranceFee = double.tryParse(value ?? '') ?? 0.0;
                    // Save the entrance fee value
                  },
                ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Date'),
                controller: TextEditingController(
                  text: eventDate != null ? DateFormat('yyyy-MM-dd').format(eventDate!) : '',
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (value) {
                  if (eventDate == null) {
                    return 'Please select the event date';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null && value.isNotEmpty) {
                    eventDate = DateTime.parse(value);
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Starting Hour'),
                readOnly: true,
                controller: TextEditingController(
                  text: startingHour != null
                      ? TimeOfDay.fromDateTime(startingHour!).format(context)
                      : '',
                ),
                onTap: () => _selectStartingHour(context),
                validator: (value) {
                  if (startingHour == null) {
                    return 'Please select the starting hour';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Ending Hour'),
                readOnly: true,
                controller: TextEditingController(
                  text: endingHour != null
                      ? TimeOfDay.fromDateTime(endingHour!).format(context)
                      : '',
                ),
                onTap: () => _selectEndingHour(context),
                validator: (value) {
                  if (endingHour == null) {
                    return 'Please select the ending hour';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add event'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}