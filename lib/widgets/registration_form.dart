import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veselica_radar/services/auth_provider.dart';
import '../dto/user_register_dto.dart';
import '../services/registration_service.dart';


class RegistrationForm extends StatefulWidget {

  final VoidCallback onSuccess;

  const RegistrationForm({Key? key, required this.onSuccess}) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _roleController = TextEditingController();
  bool _isLoading = false;

  final RegistrationService _registrationService = RegistrationService();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      UserRegisterDTO newUser = UserRegisterDTO(
        name: _nameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        confirmedPassword: _confirmPasswordController.text,
        role: 'user',
      );



      try {
        final response = await _registrationService
            .registerUser(newUser)
            .timeout(const Duration(seconds: 8));

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 200 || response.statusCode == 201) {

          print(jsonDecode(response.body));
          final responseData = jsonDecode(response.body);
          final token = responseData['token'];
          final role = responseData['role'];
          final userId = responseData['user_id'];

          Provider.of<AuthProvider>(context, listen: false).login(token, role, userId);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration successful!')),
          );
          Navigator.pushReplacementNamed(context, '/');
        } else if (response.statusCode == 500) {
          print('Response body: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Internal Server Error. Please try again later.')),
          );
        } else if (response.statusCode == 422) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Either email is already taken or password is too short.'))
          );
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed.')),
          );
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
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
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _lastNameController,
            decoration: InputDecoration(labelText: 'Last Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
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
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          _isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
            onPressed: _register,
            child: Text('Register'),
          ),
        ],
      ),
    );
  }

}