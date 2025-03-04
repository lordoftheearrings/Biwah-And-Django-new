import 'set_preferences.dart';
import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'messages_page.dart';
import 'notification_page.dart';
import 'view_user.dart';
import 'api_service.dart';
import 'custom_snackbar.dart';

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
  int offset = 0; // Track offset for batch loading
  final int limit = 10; // Define batch size

  final ApiService _apiService = ApiService();
  late PageController _pageController;

  double _swipeStart = 0.0;

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

  Future<void> _loadProfiles() async {
    if (loadingMore) return; // Avoid multiple concurrent API calls
    setState(() {
      loadingMore = true;
    });

    try {
      var response = await _apiService.getMatchmakingProfiles(widget.username);

      if (response != null && response['matches'] != null) {
        List<String> usernames = List<String>.from(response['matches']);

        if (usernames.isNotEmpty) {
          List<Map<String, dynamic>> newProfiles = [];
          for (var username in usernames) {
            var fullProfile = await _apiService.loadProfile(username);
            if (fullProfile != null) {
              newProfiles.add(fullProfile);
            }
          }

          setState(() {
            profiles.addAll(newProfiles);
            offset += limit;
            isLoading = false;
            loadingMore = false;
          });
        } else {
          setState(() {
            loadingMore = false;
          });
        }
      } else {
        setState(() {
          loadingMore = false;
        });
      }
    } catch (e) {
      print('Error fetching profiles: $e');
      setState(() {
        loadingMore = false;
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
      setState(() {
        isLoading = true;
        profiles.clear();
      });
    }
  }

  void _onPageChanged(int index) {
    if (index >= profiles.length - 6 && !loadingMore) {
      _loadProfiles();
    }
  }

  Widget _buildPageContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return MessagesPage(username: widget.username);
      case 2:
        return NotificationPage(username: widget.username);
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
            icon: Icon(Icons.interests_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SetPreferencePage(username: widget.username)),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage(username:widget.username)),
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1 ? Icons.message : Icons.message_outlined,
            ),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2 ? Icons.notifications : Icons.notifications_none_rounded,
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 3 ? Icons.person : Icons.person_outline_outlined,
            ),
            label: 'Profile',
          ),
        ],
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
                _swipeStart = details.localPosition.dx;
              }
            },
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! < -500) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ViewUser(username: profile['username'],currentUsername:widget.username),
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
    bool isMatchSent = false;

    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: profile['cover_image'] != null
                    ? NetworkImage(profile['cover_image'])
                    : AssetImage('assets/bgimg6.jpg') as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
            height: double.infinity,
            width: double.infinity,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: profile['profile_image'] != null
                            ? NetworkImage(profile['profile_image'])
                            : AssetImage('assets/logo10.png') as ImageProvider,
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ViewUser(username: profile['username'],currentUsername:widget.username),
                            ),
                          );
                        },
                        child: Text(
                          profile['name'] ?? 'Unknown',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      Text(
                        'Age: ${profile['age'] ?? 'Unknown'}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        'Caste: ${profile['caste'] ?? 'Unknown'}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        'Religion: ${profile['religion'] ?? 'Unknown'}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
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
                            // Send match request
                            var response = await _apiService.sendMatchRequest(widget.username, profile['username']);
                            if (response != null && response['message'] == 'Match request sent successfully.') {
                              setState(() {
                                isMatchSent = true;
                              });
                              CustomSnackbar.showSuccess(context, 'Match request sent to ${profile['username']}');
                            } else if (response != null && response['message'] == 'Match request already accepted.') {
                              CustomSnackbar.showSuccess(context, 'Match request already accepted');
                            } else if (response != null && response['message'] == 'Match request already sent.') {
                              CustomSnackbar.showSuccess(context, 'Match request already sent');
                            } else {
                              CustomSnackbar.showError(context, 'Failed to send match request. Try again.');
                            }
                          } else {
                            // Cancel match request
                            var response = await _apiService.cancelMatchRequest(widget.username, profile['username']);
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
            ),
          ),
        ],
      ),
    );
  }
}
