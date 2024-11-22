import 'package:flutter/material.dart';

class ViewUser extends StatelessWidget {
  final String name;
  final int? age;
  final String? bio;
  final String? avatar;

  ViewUser({
    required this.name,
    this.age,
    this.bio,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 80,

              backgroundColor: Colors.black,
            ),
            SizedBox(height: 20),
            Text(
              name,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Age: $age',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'bio',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}