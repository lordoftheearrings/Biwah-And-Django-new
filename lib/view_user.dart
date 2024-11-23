import 'package:flutter/material.dart';
import 'api_service.dart'; // Import the ApiService to call the backend

class ViewUser extends StatefulWidget {
  final String username;

  ViewUser({required this.username});

  @override
  _ViewUserState createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  bool isLoading = true;
  Map<String, dynamic>? profileData;
  Map<String, dynamic>? matchmakingData;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Fetch the full profile data and matchmaking data
  Future<void> _loadProfileData() async {
    try {
      var profileResponse = await _apiService.loadProfile(widget.username);
      var matchmakingResponse = await _apiService.getMatchmakingProfiles(widget.username);

      if (profileResponse != null && matchmakingResponse != null) {
        setState(() {
          profileData = profileResponse;
          matchmakingData = matchmakingResponse;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading profile data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Avatar
              if (profileData != null) ...[
                Center(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: NetworkImage(profileData!['avatar']),
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),

                // Name
                Text(
                  profileData!['name'],
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),

                // Age
                Text(
                  'Age: ${profileData!['age']}',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),

                // Bio
                Text(
                  'Bio:',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  profileData!['bio'],
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 30),

                // Matchmaking Info (Compatibility Score)
                if (matchmakingData != null) ...[
                  Text(
                    'Matchmaking Results:',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Compatibility Score: ${matchmakingData!['compatibility_score']}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Preferences Match: ${matchmakingData!['preferences_match']}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 30),
                ],

                // Follow Button (optional)
                ElevatedButton(
                  onPressed: () {
                    // Implement follow functionality
                  },
                  child: Text('Follow'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
