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
      backgroundColor: Color.fromRGBO(68, 29, 47, 1.0),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Messages',
          style: TextStyle(
            fontFamily: 'CustomFont3', // Add custom font if needed
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
        elevation: 5,
      ),
      body: Container(
        color: Colors.black,
        child: ListView.builder(
          itemCount: _conversations.length,
          itemBuilder: (context, index) {
            return _buildConversationTile(context, _conversations[index]);
          },
        ),
      ),
    );
  }

  // Function to build each conversation tile
  Widget _buildConversationTile(BuildContext context, Conversation conversation) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: () {
          // Navigate to the ChatPage when the conversation tile is tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(sender: conversation.sender),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.grey[900],
          elevation: 4,
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/logo10e.png'), // Set the profile picture here
            ),
            title: Text(
              conversation.sender,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Text(
                    conversation.message,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    overflow: TextOverflow.ellipsis, // To handle long messages
                  ),
                ),
                SizedBox(width: 8),
                // Online status indicator
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
              conversation.timestamp,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
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

class ChatPage extends StatelessWidget {
  final String sender;

  ChatPage({required this.sender});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$sender'),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1), // Same as MessagesPage
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  // Chat bubbles will go here
                  _buildMessage("Hello!", true),
                  _buildMessage("How are you?", false),
                  _buildMessage("I'm good, thanks!", true),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[800],
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: Icon(Icons.send, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(String message, bool isSent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Align(
        alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: isSent ? Colors.purple : Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
