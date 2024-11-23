import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'messages_page.dart';
import 'notification_page.dart';
import 'view_user.dart';
import 'api_service.dart';

class HomePage extends StatefulWidget {
  final String username;

  HomePage({required this.username});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool isLoading = true;
  bool loadingMore = false;
  List<Map<String, dynamic>> profiles = [];
  int offset = 0;  // Track offset for batch loading
  final int limit = 10;  // Define batch size

  final ApiService _apiService = ApiService();
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _loadProfiles();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Fetch user profiles based on matchmaking results
  Future<void> _loadProfiles() async {
    if (loadingMore) return; // Avoid multiple concurrent API calls
    setState(() {
      loadingMore = true;
    });

    try {
      var response = await _apiService.getMatchmakingProfiles(widget.username);
      print('API response: $response');

      if (response != null && response['matches'] != null) {
        List<String> usernames = List<String>.from(response['matches']);

        if (usernames.isNotEmpty) {
          List<Map<String, dynamic>> newProfiles = [];
          for (var username in usernames) {
            var fullProfile = await _apiService.loadProfile(username);
            print('Full profile: $fullProfile');

            if (fullProfile != null) {
              newProfiles.add(fullProfile);
            }
          }

          setState(() {
            profiles.addAll(newProfiles);  // Add the profiles with full details to the list
            offset += limit;  // Update offset for next batch
            isLoading = false;  // Stop loading indicator
            loadingMore = false;  // Reset loadingMore flag
          });
        } else {
          setState(() {
            loadingMore = false;  // No more profiles to load
          });
        }
      } else {
        setState(() {
          loadingMore = false;  // Handle case if response doesn't include profiles
        });
      }
    } catch (e) {
      print('Error fetching profiles: $e');
      setState(() {
        loadingMore = false;  // Reset flag if an error occurs
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      _loadProfiles();
    } else {
      // Handle refresh for other pages
      setState(() {
        // force refresh (clear state, reload data, etc.)
        isLoading = true;
        profiles.clear();
      });
    }
  }

  void _onPageChanged(int index) {
    if (index >= profiles.length - 5 && !loadingMore) {
      _loadProfiles();
    }
  }

  // Build the body for each tab
  Widget _buildPageContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return MessagesPage();
      case 2:
        return NotificationPage();
      case 3:
        return ProfilePage(username: widget.username);
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
      body: _buildPageContent(),
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
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomePage() {
    return Container(
      color: Colors.black,
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : profiles.isEmpty
          ? Center(child: Text('No matches found!'))
          : PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: profiles.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          var profile = profiles[index];
          return GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.primaryDelta! < 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewUser(username: profile['username']),
                  ),
                );
              }
            },
            child: _buildProfileCard(profile),
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> profile) {
    bool isMatchSent = false; // Track if match request is sent

    return Container(
      height: MediaQuery.of(context).size.height, // Set a fixed height
      child: Stack(
        children: [
          // Cover image as background
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: profile['cover_image'] != null
                    ? NetworkImage(profile['cover_image'])
                    : AssetImage('assets/bgimg6.jpg') as ImageProvider, // Default image if cover_image is null
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Profile information on the left
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Circular profile picture
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: profile['profile_image'] != null
                            ? NetworkImage(profile['profile_image'])
                            : AssetImage('assets/logo10.png') as ImageProvider, // Default image if profile_image is null
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
                          profile['name'] ?? 'Unknown', // Default value if name is null
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      // Age, gender, religion, bio, etc.
                      Text(
                        'Age: ${profile['age'] ?? 'Unknown'}', // Display age if available
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Religion: ${profile['religion'] ?? 'Unknown'}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  // Match button on the right
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isMatchSent = !isMatchSent; // Toggle match status
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isMatchSent ? Colors.red : Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text(isMatchSent ? 'Cancel Match' : 'Send Match'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
