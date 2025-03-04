import 'package:flutter/material.dart';
import 'api_service.dart';
import 'custom_snackbar.dart';

class ViewUser extends StatefulWidget {
  final String username;
  final String currentUsername;

  ViewUser({required this.username,required this.currentUsername});

  @override
  _ViewUserState createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  late Future<Map<String, dynamic>?> _profileDataFuture;
  bool _isExpanded = false;
  double _swipeStart = 0.0; // To track the start position of the swipe
  bool isMatchSent = false; // State variable to track match request status
  final ApiService _apiService = ApiService(); // Create an instance of ApiService

  @override
  void initState() {
    super.initState();
    _profileDataFuture = _apiService.loadProfile(widget.username); // Load profile data initially
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
                        Row(
                          children: [
                            Text(
                              _getFieldValue(profileData, 'name'),
                              style: TextStyle(fontFamily: 'CustomFont2', color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 8),
                            StatefulBuilder(
                              builder: (context, setState) {
                                return IconButton(
                                  icon: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    child: Icon(
                                      isMatchSent ? Icons.favorite : Icons.favorite_border,
                                      color: isMatchSent ? Colors.red : Colors.white,
                                      size: 50,
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (!isMatchSent) {
                                      var response = await _apiService.sendMatchRequest(widget.currentUsername, profileData['username']);
                                      if (response != null && response['message'] == 'Match request sent successfully.') {
                                        setState(() {
                                          isMatchSent = true;
                                        });
                                        CustomSnackbar.showSuccess(context, 'Match request sent to ${profileData['username']}');
                                      } else if (response != null && response['message'] == 'Match request already accepted.') {
                                        CustomSnackbar.showSuccess(context, 'Match request already accepted');
                                      } else if (response != null && response['message'] == 'Match request already sent.') {
                                        CustomSnackbar.showSuccess(context, 'Match request already sent');
                                      } else {
                                        CustomSnackbar.showError(context, 'Failed to send match request. Try again.');
                                      }
                                    } else {
                                      var response = await _apiService.cancelMatchRequest(widget.username, profileData['username']);
                                      if (response != null && response['message'] == 'Match request canceled successfully.') {
                                        setState(() {
                                          isMatchSent = false;
                                        });
                                        CustomSnackbar.showSuccess(context, 'Match request canceled');
                                      } else {
                                        CustomSnackbar.showError(context, 'Failed to cancel match request. Try again.');
                                      }
                                    }
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '@${widget.username}',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildInfoColumn('Bio', _getFieldValue(profileData, 'bio')),
                        _buildInfoColumn('Phone', _getFieldValue(profileData, 'phone_number')),
                      ],
                    ),
                    if (_isExpanded) ...[

                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoColumn('Religion', _getFieldValue(profileData, 'religion')),
                          _buildInfoColumn('Caste', _getFieldValue(profileData, 'caste')),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoColumn('Gotra', _getFieldValue(profileData, 'gotra')),
                          _buildInfoColumn('Height', _getFieldValue(profileData, 'height')),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoColumn('Weight', _getFieldValue(profileData, 'weight')),
                          _buildInfoColumn('Zodiac', _getFieldValue(profileData, 'zodiac')),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoColumn('Education', _getFieldValue(profileData, 'education')),
                          _buildInfoColumn('Profession', _getFieldValue(profileData, 'profession')),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoColumn('Family Type', _getFieldValue(profileData, 'family_type')),
                          _buildInfoColumn('Address', _getFieldValue(profileData, 'address')),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoColumn('Complexion', _getFieldValue(profileData, 'complexion')),
                          _buildInfoColumn('Marital Status', _getFieldValue(profileData, 'marital_status')),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoColumn('Drinking Habits', _getFieldValue(profileData, 'habits_drinking')),
                          _buildInfoColumn('Eating Habits', _getFieldValue(profileData, 'habits_eating')),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoColumn('Smoking Habits', _getFieldValue(profileData, 'habits_smoking')),
                          // Add more fields if needed
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
        leading: IconButton( // Add back button
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to previous page
          },
        ),
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
