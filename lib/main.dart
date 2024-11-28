import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biwah Bandhan',
      initialRoute: '/splash_screen',  // Set the initial route to SplashScreen
      routes: {
         '/splash_screen': (context) => SplashScreen(), // Splash screen route
         '/login_page': (context) => LoginPage(),
         '/sign_up': (context) => SignUpPage(),
        '/home': (context) => HomePage(username: ModalRoute.of(context)!.settings.arguments as String),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  // Function to navigate to Home page after a delay
  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 2));
    Navigator.pushReplacementNamed(context, '/login_page'); // Navigate to login page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purple], // Gradient background
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Image.asset(
              'assets/logo10e.png', // Path to your logo
              height: 250,             // Adjust size of the logo
              width: 250,
            ),
          ),
        ),
      ),
    );
  }
}
