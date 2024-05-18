import 'package:flutter/material.dart';
import 'package:veselica_radar/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback onSuccess;

  const LoginScreen({Key? key, required this.onSuccess}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login')
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LoginForm(
          onSuccess: onSuccess,
        )
      ),
    );
  }
}