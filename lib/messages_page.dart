import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(), // Set the theme to dark
      debugShowCheckedModeBanner: false,
      home: MessagesPage(),
    );
  }
}

class MessagesPage extends StatelessWidget {
  final List<Conversation> _conversations = [
    Conversation(sender: 'User 1', message: 'Hello!', timestamp: '10:30 AM'),
    Conversation(sender: 'User 2', message: 'Hi there!', timestamp: '9:45 AM'),
    Conversation(sender: 'User 3', message: 'How are you?', timestamp: '8:15 AM'),
    // Add more conversations here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(
            fontFamily: 'CustomFont3',
            fontSize: 30,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
      ),
      body: Container(
        color: Colors.black, // Set the background color to black
        child: ListView.builder(
          itemCount: _conversations.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/logo10e.png'), // Set the profile picture here
                  ),
                  title: Text(
                    _conversations[index].sender,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _conversations[index].message,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                          overflow: TextOverflow.ellipsis, // To handle long messages
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    _conversations[index].timestamp,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  onTap: () {
                    // Removed navigation to ChatPage
                  },
                ),
                Divider(color: Colors.grey[800], height: 16), // Add a divider between the list items
              ],
            );
          },
        ),
      ),
    );
  }
}

class Conversation {
  final String sender;
  final String message;
  final String timestamp;

  Conversation({
    required this.sender,
    required this.message,
    required this.timestamp,
  });
}
