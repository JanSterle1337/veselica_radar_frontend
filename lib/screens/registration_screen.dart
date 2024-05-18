import 'package:flutter/material.dart';
import 'package:veselica_radar/widgets/bottom_navigation.dart';
import 'package:veselica_radar/widgets/registration_form.dart';

class RegistrationScreen extends StatelessWidget {

  final VoidCallback onSuccess;

  const RegistrationScreen({Key? key, required this.onSuccess}) : super(key : key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RegistrationForm(
          onSuccess: onSuccess,
        ),
      ),
    );
  }
}