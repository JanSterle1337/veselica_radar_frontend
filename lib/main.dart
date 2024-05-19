import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:veselica_radar/screens/login_screen.dart';
import 'package:veselica_radar/screens/user_profile_screen.dart';
import 'services/auth_provider.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/registration_screen.dart';
import 'widgets/bottom_navigation.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
          home: MainScreen(),
        )
    );
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final selectedItemColor = Colors.amber[800];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleLogout(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).logout();
    setState(() {
      _selectedIndex = 0; // Optionally reset the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isAuthenticated = Provider.of<AuthProvider>(context).isAuthenticated;
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: isAuthenticated
            ? <Widget>[
          HomeScreen(),
          UserProfileScreen(),
        ]
            : <Widget>[
          HomeScreen(),
          RegistrationScreen(
            onSuccess: () {
              setState(() {
                _selectedIndex = 0;
                isAuthenticated = true; // Update the state on success
              });
            },
          ),
          LoginScreen(
              onSuccess: () {
                setState(() {
                  _selectedIndex = 0;
                  isAuthenticated = true; // Update the state on success
                });
              })
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: isAuthenticated
            ? <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ]
            : <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration),
            label: 'Register',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Login',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          if (isAuthenticated && index == 2) {
            _handleLogout(context);
          } else {
            _onItemTapped(index);
          }
        },
      ),
    );
  }
}