import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'messages_page.dart';
import 'notification_page.dart';

class HomePage extends StatefulWidget {
  final String email;

  HomePage({required this.email});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[];

  // Demo data (Mock data simulating PostgreSQL entries)
  List<Map<String, dynamic>> profiles = List.generate(15, (index) {
    return {
      'name': 'User ${index + 1}',
      'bio': 'Bio for User ${index + 1}',
      'avatar': 'https://via.placeholder.com/150', // Placeholder image URL
    };
  });

  List<Map<String, dynamic>> posts = [
    {
      'user_id': 'User 1',
      'content': 'Just completed a new coding project! 🚀',
      'timestamp': '10:30 AM',
    },
    {
      'user_id': 'User 2',
      'content': 'Had an amazing workout today! 💪',
      'timestamp': '9:00 AM',
    },
    {
      'user_id': 'User 3',
      'content': 'Finally beat my favorite game! 🎮',
      'timestamp': '8:15 AM',
    },
    // Add more demo posts here
  ];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      _buildHomePage(),
      MessagesPage(),
      NotificationPage(),
      ProfilePage(email: widget.email),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  PreferredSizeWidget? _getAppBar() {
    if (_selectedIndex == 0) {
      return AppBar(
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
            icon: Icon(Icons.search, color: Colors.white),
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
      body: Center(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.pink,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
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
      child: PageView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          var profile = profiles[index];
          return _buildProfileCard(profile, index);
        },
        scrollDirection: Axis.vertical, // Scroll vertically for TikTok-style swiping
      ),
    );
  }

  Widget _buildProfileCard(Map<String, dynamic> profile, int index) {
    // Filter posts based on the user_id
    var profilePosts = posts.where((post) => post['user_id'] == profile['name']).toList();

    return GestureDetector(
      onVerticalDragUpdate: (details) {
        // Handle swipe up and down
        if (details.primaryDelta! > 0) {
          // Swipe Down (you can add functionality here)
          print('Swiped Down');
        } else if (details.primaryDelta! < 0) {
          // Swipe Up (you can add functionality here)
          print('Swiped Up');
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(profile['avatar']!),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              offset: Offset(0, 10),
              blurRadius: 30,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              profile['name']!,
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              profile['bio']!,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
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
            SizedBox(height: 15),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: profilePosts.length,
              itemBuilder: (context, postIndex) {
                return Card(
                  color: Colors.grey[900],
                  child: ListTile(
                    title: Text(
                      profilePosts[postIndex]['content'],
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      profilePosts[postIndex]['timestamp'],
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: HomePage(email: 'example@example.com'), // Replace with actual email
));
