import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String sender;

  ChatPage({required this.sender});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$sender'),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {
              // Add call logic here
            },
            tooltip: 'Call',
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {
              // Add video call logic here
            },
            tooltip: 'Video Call',
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {
              // Add photo sending logic here
            },
            tooltip: 'Send Photo',
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  _buildMessage("Hello!", true),
                  _buildMessage("How are you?", false),
                  _buildMessage("I'm good, thanks!", true),
                  _buildMessage("Are you free later today?", false),
                  _buildMessage("Yes, let's catch up!", true),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add_photo_alternate, color: Colors.white),
                    onPressed: () {
                      // Add photo logic
                    },
                  ),
                  Expanded(
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
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      // Add send message logic
                    },
                  ),
                ],
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
