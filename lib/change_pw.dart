import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  final String username; // Accept username as a parameter

  ChangePasswordPage({required this.username}); // Pass username through constructor

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _usernameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () {
          Navigator.pop(context); // Go back to the previous page
        },
      ),
      title: Text(
        'Change Password',
        style: TextStyle(
          fontFamily: 'CustomFont3',
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Color.fromRGBO(153, 0, 76, 1), // Same as the card color
      elevation: 5,
    ),
      body: SingleChildScrollView( // Allow the content to scroll if necessary
        child: Container(
          color: Colors.white, // Set background to white
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Username input field (for verification) wrapped in a card
              _buildInputField(
                controller: _usernameController,
                label: 'Enter Username',
                obscureText: false,
              ),
              SizedBox(height: 10),
              // Current Password input field wrapped in a card
              _buildInputField(
                controller: _currentPasswordController,
                label: 'Current Password',
                obscureText: true,
              ),
              SizedBox(height: 10),
              // New Password input field wrapped in a card
              _buildInputField(
                controller: _newPasswordController,
                label: 'New Password',
                obscureText: true,
              ),
              SizedBox(height: 10),
              // Confirm New Password input field wrapped in a card
              _buildInputField(
                controller: _confirmPasswordController,
                label: 'Confirm New Password',
                obscureText: true,
              ),
              SizedBox(height: 20),
              // Change Password button styled like a card
              ElevatedButton(
                onPressed: () {
                  String enteredUsername = _usernameController.text;
                  String currentPassword = _currentPasswordController.text;
                  String newPassword = _newPasswordController.text;
                  String confirmPassword = _confirmPasswordController.text;

                  // Check if entered username matches passed-in username
                  if (enteredUsername != widget.username) {
                    // Show error if usernames don't match
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Username does not match!')),
                    );
                    return;
                  }

                  // Proceed if new passwords match
                  if (newPassword == confirmPassword) {
                    // Handle password change logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password changed successfully!')),
                    );
                  } else {
                    // Show error if new passwords don't match
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('New passwords do not match!')),
                    );
                  }
                },
                child: Text('Change Password'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color.fromRGBO(153, 0, 76, 1), // Same color as the cards
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: TextStyle(fontSize: 18, color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable widget to create the input fields styled as cards
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
  }) {
    return Container(
      width: double.infinity, // Make the card take full width
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Increased vertical padding
      child: Card(
        color: Color.fromRGBO(153, 0, 76, 1), // Color matching the app bar
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0), // Increased padding for height
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: Colors.white, // White text for labels
              ),
              border: InputBorder.none, // Remove the border for a card-like effect
            ),
            style: TextStyle(
              color: Colors.white, // White text for input
            ),
            obscureText: obscureText,
          ),
        ),
      ),
    );
  }
}
