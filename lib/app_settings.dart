import 'package:flutter/material.dart';
import 'change_pw.dart'; // Import ChangePasswordPage

class AppSettings extends StatefulWidget {
  final String username;

  AppSettings({required this.username});

  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  @override
  void initState() {
    super.initState();
    // ApiService().loadProfile(widget.username); // Uncomment to load profile if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(68, 29, 47, 1.0),
      appBar: AppBar(
        leading: IconButton(  // Add back button
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);  // Go back to previous page
          },
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'CustomFont3',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Only Change Password Option with Styling
            _buildSettingsOption(
              context,
              'Change Password',
              Icons.lock,
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePasswordPage(username: widget.username),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Custom widget for settings options
  Widget _buildSettingsOption(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Color.fromRGBO(153, 0, 76, 1), size: 30),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'CustomFont2',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.black, size: 20), // Arrow indicating a next page
          ],
        ),
      ),
    );
  }
}
