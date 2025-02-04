import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'api_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ChatPage extends StatefulWidget {
  final String sender;
  final String roomName;
  final String receiver;

  ChatPage({required this.sender, required this.roomName, required this.receiver});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late WebSocketChannel channel;
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  late ScrollController _scrollController; // ScrollController to manage scroll position
  bool _isInitialFetchComplete = false; // Track if initial fetch is done

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(); // Initialize ScrollController

    // Connect to WebSocket
    if (kIsWeb) {
      channel = WebSocketChannel.connect(
        Uri.parse('ws://192.168.156.15:8000/ws/chat/${widget.roomName}/'), // Replace with actual URL
      );
    } else {
      channel = IOWebSocketChannel.connect(
        'ws://192.168.156.15:8000/ws/chat/${widget.roomName}/', // Replace with actual URL
      );
    }

    // Listen for incoming messages from WebSocket
    channel.stream.listen((message) {
      setState(() {
        final decodedMessage = jsonDecode(message);
        _messages.add({
          'sender': decodedMessage['sender_username'],
          'content': decodedMessage['message'],
        });
      });

      // Scroll to the bottom when a new message arrives
      _scrollToBottom();
    });

    // Fetch initial messages only once
    _fetchMessages();
  }

  void _fetchMessages() async {
    if (_isInitialFetchComplete) return; // Avoid fetching again if already done

    final response = await ApiService().getMessages(widget.roomName);
    if (response.isEmpty) {
      print("Error: Failed to get messages or no messages found.");
    } else {
      setState(() {
        _messages.clear(); // Clear the existing messages before adding the new ones
        for (var message in response) {
          _messages.add({
            'sender': message['sender'],
            'content': message['content'],
          });
        }
        _isInitialFetchComplete = true; // Mark initial fetch as complete
      });

      // Scroll to the bottom after fetching initial messages
      _scrollToBottom();
    }
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      // Send message through WebSocket
      channel.sink.add(jsonEncode({
        'message': _controller.text,
        'sender_username': widget.sender,
      }));
      _controller.clear();
    }
  }

  void _scrollToBottom() {
    // Scroll to the bottom of the ListView
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    _scrollController.dispose(); // Dispose of the ScrollController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.receiver,
          style: TextStyle(
            fontSize: 28,
            fontFamily: 'CustomFont2',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
        actions: [
          IconButton(
            icon: Icon(Icons.call,color: Colors.white),
            onPressed: () {
              // Add call logic here
            },
            tooltip: 'Call',
          ),
          IconButton(
            icon: Icon(Icons.videocam,color: Colors.white),
            onPressed: () {
              // Add video call logic here
            },
            tooltip: 'Video Call',
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: _scrollController, // Attach the ScrollController here
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _buildMessage(
                    _messages[index]['content']!,
                    _messages[index]['sender'] == widget.sender,
                  );
                },
              ),
            ),
            Container(
              color: Color.fromRGBO(153, 0, 76, 1), // Set your desired background color
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.blueGrey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            )

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
            color: isSent ? Color.fromRGBO(153, 0, 76, 1) : Colors.grey[400],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            message,
            style:isSent ? TextStyle(color: Colors.white, fontSize: 16) : TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
