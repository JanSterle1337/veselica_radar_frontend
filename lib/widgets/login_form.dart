import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veselica_radar/dto/user_login_dto.dart';
import 'package:veselica_radar/services/auth_provider.dart';
import 'package:veselica_radar/services/login_service.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onSuccess;

  const LoginForm({Key? key, required this.onSuccess}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  final LoginService _loginService = LoginService();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      UserLoginDTO newUser = UserLoginDTO(
          email: _emailController.text,
          password: _passwordController.text
      );

      try {
        final response = await _loginService
            .login(newUser)
            .timeout(const Duration(seconds: 8));

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = jsonDecode(response.body);
          final token = responseData['token'];
          final role = responseData['role'];
          final userId = responseData['user_id'];

          Provider.of<AuthProvider>(context, listen: false).login(token, role, userId);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login successful!')),
          );

          Navigator.pushReplacementNamed(context, '/');

        }


      } on TimeoutException catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request timed out. Please try again'))
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
      }


    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }

              return null;
            },
          ),
          SizedBox(height: 20),
          _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
              onPressed: _login,
              child: Text('Login')
          ),
        ],
      ),
    );
  }
}