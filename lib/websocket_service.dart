import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  // Singleton pattern
  static final WebSocketService _singleton = WebSocketService._internal();
  factory WebSocketService() => _singleton;

  late WebSocketChannel _channel;
  Stream<dynamic>? _stream;

  // Callbacks for different events
  Function(String)? onIncomingCall;
  Function()? onCallAccepted;
  Function()? onCallEnded;
  Function(String, String)? onNewMessage;

  WebSocketService._internal();

  // Connect to the WebSocket server
  void connect(String roomName) {
    if (_channel != null) return; // Prevent multiple connections

    // Establish WebSocket connection
    _channel = IOWebSocketChannel.connect('ws://127.0.0.1:8000/ws/chat/$roomName/'); // Replace with actual URL
    _stream = _channel.stream;

    // Listen for incoming messages (calls and responses)
    _stream!.listen((message) {
      final data = jsonDecode(message);

      // Handling different events
      switch (data['event']) {
        case 'start_call':
          if (onIncomingCall != null) onIncomingCall!(data['sender_username']);
          break;
        case 'accept_call':
          if (onCallAccepted != null) onCallAccepted!();
          break;
        case 'end_call':
          if (onCallEnded != null) onCallEnded!();
          break;
        case 'chat_message':
          if (onNewMessage != null) onNewMessage!(data['message'], data['sender_username']);
          break;
        default:
          break;
      }
    });
  }

  // Send message through WebSocket
  void sendMessage(String message, String senderUsername) {
    if (_channel != null) {
      _channel.sink.add(jsonEncode({
        'event': 'chat_message',
        'message': message,
        'sender_username': senderUsername,
      }));
    }
  }


  // Listen for incoming messages (this can be used in the chat page)
  Stream<dynamic>? get stream => _stream;

  // Close the WebSocket connection
  void closeConnection() {
    _channel.sink.close();
    _stream = null; // Clear stream after closing the connection
  }
}
