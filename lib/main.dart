import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'home_page.dart';
import 'notification_page.dart';
import 'edit_profile_page.dart';
import 'chat_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/sign_up': (context) => SignUpPage(),
        '/home': (context) => HomePage(username: ModalRoute.of(context)!.settings.arguments as String),
      },
    );
  }
}
