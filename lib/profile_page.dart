import 'package:flutter/material.dart';
import 'api_service.dart'; // Import your ApiService
import 'edit_profile_page.dart'; // Import EditProfilePage
import 'app_settings.dart';
import 'image_button.dart'; // Import the image_buttons.dart file

class ProfilePage extends StatefulWidget {
  final String username;

  ProfilePage({required this.username});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>?> _profileDataFuture;
  bool _isExpanded = false; // To track the expanded state

  @override
  void initState() {
    super.initState();
    _fetchProfileData(); // Load profile data initially
  }

  void _fetchProfileData() {
    setState(() {
      _profileDataFuture = ApiService().loadProfile(widget.username);
    });
  }

  String _getFieldValue(Map<String, dynamic>? data, String field) {
    if (data == null || data[field] == null || data[field].toString().isEmpty) {
      return 'Not provided';
    }
    return data[field].toString();
  }

  Widget _buildProfileView(BuildContext context, Map<String, dynamic> profileData) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cover Image with Gradient Overlay
          Stack(
            children: [
              // Cover Image
              Container(
                height: MediaQuery.of(context).size.height * 0.50, // Cover Image takes 50% height
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: profileData['cover_image'] != null
                        ? NetworkImage(profileData['cover_image'])
                        : AssetImage('assets/default_cover.jpg') as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Gradient Overlay
              Container(
                height: MediaQuery.of(context).size.height * 0.50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(153, 0, 76, 1), // Same color as AppBar background
                      Colors.transparent
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              // Profile Image, Name, and Username inside cover image
              Positioned(
                bottom: 10,
                left: 20,
                child: Row(
                  children: [
                    // Profile Image (larger size)
                    CircleAvatar(
                      radius: 65, // Larger size
                      backgroundColor: Colors.white,
                      backgroundImage: profileData['profile_image'] != null
                          ? NetworkImage(profileData['profile_image'])
                          : AssetImage('assets/default_profile.png') as ImageProvider,
                    ),
                    SizedBox(width: 16),
                    // Name and Username
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getFieldValue(profileData, 'name'),
                          style: TextStyle(fontFamily: 'CustomFont2', color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '@ ${widget.username}',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Profile Info Section with Expandable Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildExpandableInfoCard(profileData),
          ),
          SizedBox(height: 20),
          // Image Buttons Row at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: KundaliImageButton(
                    onPressed: () {
                      print('Kundali button pressed!');
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AshtakootMilanImageButton(
                    onPressed: () {
                      print('Ashtakoot Milan button pressed!');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method to build an expandable card for profile info
  Widget _buildExpandableInfoCard(Map<String, dynamic> profileData) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      color: Color.fromRGBO(153, 0, 76, 1),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Title: Details with arrow on the right side
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Details',
                  style: TextStyle(color: Colors.white, fontFamily: 'CustomFont2', fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.pinkAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded; // Toggle the expanded state
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            // Always visible: First row with 2 pieces of information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn('Age', _getFieldValue(profileData, 'age')),
                _buildInfoColumn('Gender', _getFieldValue(profileData, 'gender')),

              ],
            ),
            SizedBox(height: 16),
            // If expanded, show other information
            if (_isExpanded) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn('Bio', _getFieldValue(profileData, 'bio')),
                  _buildInfoColumn('Phone', _getFieldValue(profileData, 'phone_number')),

                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoColumn('Religion', _getFieldValue(profileData, 'religion')),
                  _buildInfoColumn('Caste', _getFieldValue(profileData, 'caste')),

                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper method to build each info column in 1x2 format
  Widget _buildInfoColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'CustomFont2', // Font family set to CustomFont2
              fontWeight: FontWeight.bold,
              fontSize: 14, // Adjust font size as needed
              color: Colors.white, // Text color set to white
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white, // Text color set to white
              fontSize: 16, // Adjust font size as needed
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          '${widget.username}',
          style: TextStyle(
            fontSize: 28,
            fontFamily: 'CustomFont2',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
        actions: [
          // Edit Profile button to the left of settings icon
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(username: widget.username),
                ),
              );
              _fetchProfileData(); // Refresh data
            },
          ),
          // Settings Icon
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppSettings(username: widget.username)),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>( // Use FutureBuilder to load profile data
        future: _profileDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading profile.'));
          }

          final profileData = snapshot.data;
          if (profileData == null || profileData.isEmpty) {
            return Center(child: Text('No profile found!'));
          }
          return _buildProfileView(context, profileData);
        },
      ),
    );
  }
}
