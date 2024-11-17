import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'messages_page.dart';

class HomePage extends StatefulWidget {
  final String email;

  HomePage({required this.email});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[];

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      _buildHomePage(),
      SearchPage(),
      MessagesPage(),
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
            fontSize: 40,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
        automaticallyImplyLeading: false,
      );
    } else {
      return null; // No AppBar for other pages
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.pink, // Set your desired color
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            backgroundColor: Colors.blue, // Set your desired color
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
            backgroundColor: Colors.green, // Set your desired color
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            backgroundColor: Colors.orange, // Set your desired color
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromRGBO(255,182,193, 1),
        unselectedItemColor: Color.fromRGBO(192,192,192, 1),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomePage() {
    // Example data for posts
    final List<String> posts = List.generate(20, (index) => 'Post $index');

    return Container(
      color: Colors.black, // Set the background color to black for dark mode
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            elevation: 4.0,
            color: Colors.grey[900], // Set the card color to a dark grey
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Text(
                posts[index],
                style: TextStyle(color: Colors.white), // Set the text color to white
              ),
              subtitle: Text(
                'Details for $index',
                style: TextStyle(color: Colors.white), // Set the text color to white
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.grey[800], // Set the avatar background color to a dark grey
                child: Text(
                  'U$index',
                  style: TextStyle(color: Colors.white), // Set the text color to white
                ),
              ),
              trailing: Icon(
                Icons.favorite_border,
                color: Colors.white, // Set the icon color to white
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: HomePage(email: 'example@example.com'), // Replace with actual email
));
