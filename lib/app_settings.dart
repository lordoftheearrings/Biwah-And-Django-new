import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';  // Import shared_preferences for saving login state
import 'change_pw.dart'; // Import ChangePasswordPage
import 'login_page.dart';

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
  }

  // Function to handle log out
  void _logOutUser(BuildContext context) async {
    // Clear any stored user data or tokens (if applicable)
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();  // Clear all stored preferences (user data)

    // Navigate to the login page and replace the current screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to LoginPage
    );
  }

  // Function to show log out confirmation dialog with styling
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Confirm Log Out',
            style: TextStyle(
              fontFamily: 'CustomFont2',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(153, 0, 76, 1),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to log out?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color:Color.fromRGBO(153, 0, 76, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _logOutUser(context);  // Log out the user
                Navigator.of(context).pop();  // Close the dialog
              },
              child: Text(
                'Log Out',
                style: TextStyle(
                  color:Color.fromRGBO(153, 0, 76, 1),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

            ),
          ],
        );
      },
    );
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
        actions: [
          // Log Out Button in AppBar
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              _showLogoutConfirmationDialog(context);  // Show confirmation dialog
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Change Password Option with Styling
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
          ],
        ),
      ),
    );
  }
}
