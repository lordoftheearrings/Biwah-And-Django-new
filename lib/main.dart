import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'home_page.dart';
import 'complete_profile_page.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
        '/complete_profile': (context) => CompleteProfilePage(username: ModalRoute.of(context)!.settings.arguments as String), // New route for Complete Profile
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
    await Future.delayed(Duration(seconds: 1));
    Navigator.pushReplacementNamed(context, '/login_page'); // Navigate to login page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purple], // Gradient background
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo with Scale and Fade Effect
              Image.asset(
                'assets/logo10e.png', // Path to your logo
                height: 180,
                width: 180,
              )
                  .animate()
                  .scaleXY(begin: 0.5, end: 1.5, duration: 1.seconds, curve: Curves.fastEaseInToSlowEaseOut)
                  .fadeIn(duration: 1.seconds),

              SizedBox(height: 50),


            ],
          ),
        ),
      ),
    );
  }
}
