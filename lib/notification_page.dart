import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(68, 29, 47, 1.0),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Notifications',
            style: TextStyle(
              fontFamily: 'CustomFont3', // Add custom font if needed
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Color.fromRGBO(153, 0, 76, 1),
          elevation: 5,
        ),
      body: Center(
        child: Text("Here are your notifications!"),
      ),
    );
  }
}
