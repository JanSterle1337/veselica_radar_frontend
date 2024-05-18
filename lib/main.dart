import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:veselica_radar/screens/login_screen.dart';
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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.logout();
    dynamic isAuthenticated = authProvider.isAuthenticated;
    print('Is authenticated: ${isAuthenticated}');

  }

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);
    final isAuthenticated = authProvider.isAuthenticated;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          HomeScreen(),
          RegistrationScreen(
            onSuccess: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
          ),
          LoginScreen(
              onSuccess: () {
                setState(() {
                  _selectedIndex = 0;
                });
              })
        ],
      ),
      bottomNavigationBar: isAuthenticated ? BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          if (isAuthenticated && index == 1) {
            print("Handlamo login");
            _handleLogout(context);
          } else {
            print("change view wuhuuu");
            _onItemTapped(index);
          }
        },
      ) : BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
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
              label: 'Login'
            )
          ],

          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (index) {
          if (isAuthenticated && index == 1) {
            print("Handlamo login");
            _handleLogout(context);
          } else {
            print("change view wuhuuu");
            _onItemTapped(index);
          }
      },
      ),

    );
  }
}