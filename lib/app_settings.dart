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
  bool _rememberUser = false;  // Variable to track "Remember Me" checkbox state
  bool _rememberPassword = false;  // Variable to track "Remember Password" checkbox state

  @override
  void initState() {
    super.initState();
    _loadRememberUserPreference();  // Load remember user preference on init
  }

  // Function to load saved "Remember User" and "Remember Password" preferences
  _loadRememberUserPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberUser = prefs.getBool('rememberUser') ?? false;
      _rememberPassword = prefs.getBool('rememberPassword') ?? false;
    });
  }

  // Function to handle log out
  void _logOutUser(BuildContext context) async {
    // Clear any stored tokens or user data
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();  // Clear all stored preferences (user data)

    // Navigate to the login page and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()), // Replace 'LoginPage' with your login screen
          (Route<dynamic> route) => false,
    );
  }

  // Function to show log out confirmation dialog
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Log Out'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Remember Username and Password option in the dialog
              SwitchListTile(
                title: Text("Remember Username"),
                value: _rememberUser,
                onChanged: (bool value) {
                  setState(() {
                    _rememberUser = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text("Remember Password"),
                value: _rememberPassword,
                onChanged: (bool value) {
                  setState(() {
                    _rememberPassword = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();  // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _logOutUser(context);  // Log out the user
                _saveRememberUserPreference(widget.username, '');  // Save preference before logout
                Navigator.of(context).pop();  // Close the dialog
              },
              child: Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  // Function to save "Remember User" and "Remember Password" preferences
  _saveRememberUserPreference(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberUser', _rememberUser);
    await prefs.setBool('rememberPassword', _rememberPassword);

    if (_rememberUser) {
      await prefs.setString('username', username); // Save username
    } else {
      await prefs.remove('username'); // Remove username if not remembered
    }

    if (_rememberPassword) {
      await prefs.setString('password', password); // Save password
    } else {
      await prefs.remove('password'); // Remove password if not remembered
    }
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
            SizedBox(height: 20),

            // Remember User Option with Switch
            GestureDetector(
              onTap: () {
                setState(() {
                  _rememberUser = !_rememberUser;  // Toggle the switch state
                });
                _saveRememberUserPreference(widget.username, '');  // Save the state with empty password (for now)
              },
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
                    Icon(Icons.check_circle, color: _rememberUser ? Color.fromRGBO(153, 0, 76, 1) : Colors.grey, size: 30),
                    SizedBox(width: 20),
                    Text(
                      'Remember Username',
                      style: TextStyle(
                        fontFamily: 'CustomFont2',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    Switch(
                      value: _rememberUser,
                      onChanged: (bool value) {
                        setState(() {
                          _rememberUser = value;
                        });
                        _saveRememberUserPreference(widget.username, '');  // Save the new state
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Remember Password Option with Switch
            GestureDetector(
              onTap: () {
                setState(() {
                  _rememberPassword = !_rememberPassword;  // Toggle the switch state
                });
                _saveRememberUserPreference(widget.username, '');  // Save the state with empty password (for now)
              },
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
                    Icon(Icons.check_circle, color: _rememberPassword ? Color.fromRGBO(153, 0, 76, 1) : Colors.grey, size: 30),
                    SizedBox(width: 20),
                    Text(
                      'Remember Password',
                      style: TextStyle(
                        fontFamily: 'CustomFont2',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    Switch(
                      value: _rememberPassword,
                      onChanged: (bool value) {
                        setState(() {
                          _rememberPassword = value;
                        });
                        _saveRememberUserPreference(widget.username, '');  // Save the new state
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Log Out Button with Confirmation
            ElevatedButton(
              onPressed: () {
                _showLogoutConfirmationDialog(context);  // Show confirmation dialog on log-out press
              },
              child: Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor:  Color.fromRGBO(153, 0, 76, 1), // Set button color
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
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
