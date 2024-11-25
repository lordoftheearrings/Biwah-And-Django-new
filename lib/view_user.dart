import 'package:flutter/material.dart';
import 'api_service.dart'; // Import your ApiService


class ViewUser extends StatefulWidget {
  final String username;

  ViewUser({required this.username});

  @override
  _ViewUserState createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  late Future<Map<String, dynamic>?> _profileDataFuture;
  bool _isExpanded = false;
  double _swipeStart = 0.0;  // To track the start position of the swipe

  @override
  void initState() {
    super.initState();
    _profileDataFuture = ApiService().loadProfile(widget.username); // Load profile data initially
  }

  String _getFieldValue(Map<String, dynamic>? data, String field) {
    return data?[field]?.toString() ?? 'Not provided';
  }

  Widget _buildProfileView(BuildContext context, Map<String, dynamic> profileData) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cover Image with Gradient Overlay
          Stack(
            children: [
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
              Container(
                height: MediaQuery.of(context).size.height * 0.50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(153, 0, 76, 0.8),
                      Colors.transparent
                    ],
                    begin: Alignment.bottomRight,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 20,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.white,
                      backgroundImage: profileData['profile_image'] != null
                          ? NetworkImage(profileData['profile_image'])
                          : AssetImage('assets/default_profile.png') as ImageProvider,
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getFieldValue(profileData, 'name'),
                          style: TextStyle(fontFamily: 'CustomFont2', color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
            child: Card(
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
                            _isExpanded ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_outlined,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoColumn('Age', _getFieldValue(profileData, 'age')),
                        _buildInfoColumn('Gender', _getFieldValue(profileData, 'gender')),
                      ],
                    ),
                    SizedBox(height: 16),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'CustomFont2',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'CustomFont2',
              fontSize: 14,
              color: Colors.white,
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
        leading: IconButton(  // Add back button
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);  // Go back to previous page
          },
        ),
        title: Text( '${widget.username}',
          style: TextStyle(
            fontSize: 28,
            fontFamily: 'CustomFont2',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
      ),
      body: GestureDetector(
        onHorizontalDragStart: (details) {
          _swipeStart = details.localPosition.dx;
        },
        onHorizontalDragEnd: (details) {
          if (_swipeStart < MediaQuery.of(context).size.width / 1 && details.primaryVelocity! > 0) {
            // Swipe is sufficiently long and moving from left to right
            Navigator.pop(context);
          }
        },
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _profileDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return Center(child: Text('Error loading profile data'));
            }

            return _buildProfileView(context, snapshot.data!);
          },
        ),
      ),
    );
  }
}
