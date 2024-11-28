import 'package:flutter/material.dart';
import 'chat_page.dart'; // Import the ChatPage class

class MessagesPage extends StatelessWidget {
  final List<Conversation> _conversations = [
    Conversation(sender: 'User 1', message: 'Hello!', timestamp: '10:30 AM'),
    Conversation(sender: 'User 2', message: 'Hi there! How’s it going?', timestamp: '9:45 AM'),
    Conversation(sender: 'User 3', message: 'How are you doing?', timestamp: '8:15 AM'),
    Conversation(sender: 'User 4', message: 'Are you free later today?', timestamp: '7:00 AM'),
    Conversation(sender: 'User 5', message: 'Can we talk later?', timestamp: 'Yesterday'),
    Conversation(sender: 'User 6', message: 'What’s up?', timestamp: 'Yesterday'),
    // Add more conversations here as needed
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
            fontFamily: 'CustomFont3',
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0), // Reduced padding
          itemCount: _conversations.length,
          itemBuilder: (context, index) {
            return _buildConversationTile(context, _conversations[index]);
          },
        ),
      ),
    );
  }

  Widget _buildConversationTile(BuildContext context, Conversation conversation) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Reduced vertical padding
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(sender: conversation.sender), // Navigate to ChatPage
            ),
          );
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Color.fromRGBO(153, 0, 76, 1),
          child: ListTile(
            contentPadding: EdgeInsets.all(8), // Reduced padding
            leading: CircleAvatar(
              radius: 28, // Slightly smaller avatar
              backgroundImage: AssetImage('assets/logo10e.png'), // Replace with your image
            ),
            title: Text(
              conversation.sender,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            subtitle: Row(
              children: [
                Expanded(
                  child: Text(
                    conversation.message,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 6), // Reduced spacing
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.green, // Green dot for online status
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
            trailing: Text(
              conversation.timestamp,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
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
