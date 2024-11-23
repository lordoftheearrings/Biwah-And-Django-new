import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'messages_page.dart';
import 'notification_page.dart';
import 'view_user.dart';  // Ensure ViewUser is imported
import 'api_service.dart';  // Import the ApiService

class HomePage extends StatefulWidget {
  final String username;

  HomePage({required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool isLoading = true;
  List<Map<String, dynamic>> profiles = [];

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  // Fetch user profiles based on matchmaking results
  Future<void> _loadProfiles() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Call the matchmaking API to fetch profiles based on compatibility score
      var response = await _apiService.getMatchmakingProfiles(widget.username);
      if (response != null && response['profiles'].isNotEmpty) {
        setState(() {
          profiles = List<Map<String, dynamic>>.from(response['profiles']);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching profiles: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Refresh profiles when the Home tab (index 0) is selected
    if (_selectedIndex == 0) {
      _loadProfiles(); // Reload profiles on home tab selection
    }
  }

  // Build the body for each tab
  Widget _buildPageContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return MessagesPage(); // Show Messages page
      case 2:
        return NotificationPage(); // Show Notifications page
      case 3:
        return ProfilePage(username: widget.username); // Show Profile page
      default:
        return _buildHomePage();
    }
  }

  PreferredSizeWidget? _getAppBar() {
    if (_selectedIndex == 0) {
      return AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Biwah Bandhan',
          style: TextStyle(
            fontFamily: 'CustomFont3',
            fontSize: 36,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
        ],
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: _buildPageContent(),  // Dynamic body based on selected index
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
            backgroundColor: Colors.pink,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            label: 'Messages',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_rounded),
            label: 'Notifications',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_outlined),
            label: 'Profile',
            backgroundColor: Colors.orange,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromRGBO(255, 182, 193, 1),
        unselectedItemColor: Colors.white,
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,  // Handle tap for navigation
      ),
    );
  }

  Widget _buildHomePage() {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // Display loading indicator or no profiles message
          isLoading
              ? Center(child: CircularProgressIndicator())
              : profiles.isEmpty
              ? Center(child: Text('No matches found!'))
              : Expanded(
            child: PageView.builder(
              itemCount: profiles.length,
              itemBuilder: (context, index) {
                var profile = profiles[index];
                return _buildProfileCard(profile, index);
              },
              scrollDirection: Axis.vertical,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> profile, int index) {
    return Stack(
      children: [
        // Cover image as background
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(profile['avatar']),
              fit: BoxFit.cover,
            ),
          ),
          height: double.infinity,
          width: double.infinity,
        ),
        // Gradient overlay for readability
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
        ),
        // Profile details
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Profile information on the left
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Circular profile picture
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(profile['avatar']),
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(height: 10),
                    // Username (Clickable)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewUser(username: profile['username']),
                          ),
                        );
                      },
                      child: Text(
                        profile['name'],
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    // Age field
                    Text(
                      'Age: ${profile['age']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              // Follow button on the right
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Add follow action
                  },
                  child: Text("Follow"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
