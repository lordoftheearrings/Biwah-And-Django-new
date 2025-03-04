// import 'package:flutter/material.dart';
// import 'api_service.dart'; // Ensure this import points to your API service
// import 'chat_page.dart'; // Ensure this import points to your chat page
// import 'my_matches.dart'; // Ensure this import points to your matches page
//
// class MessagesPage extends StatefulWidget {
//   final String username;
//
//   const MessagesPage({Key? key, required this.username}) : super(key: key);
//
//   @override
//   _MessagesPageState createState() => _MessagesPageState();
// }
//
// class _MessagesPageState extends State<MessagesPage> {
//   List<Conversation> _conversations = [];
//   bool _isLoading = true;
//   String _errorMessage = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchChatRooms();
//   }
//
//
//   Future<void> _fetchChatRooms() async {
//     try {
//       final response = await ApiService().fetchChatRooms(widget.username);
//
//       if (response.isEmpty) {
//         setState(() {
//           _errorMessage = 'No conversations found';
//           _isLoading = false;
//         });
//       } else {
//         setState(() {
//           _conversations = response
//               .map((conversationData) => Conversation.fromJson(conversationData))
//               .toList();
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Error fetching chat rooms: $e';
//         _isLoading = false;
//       });
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text(
//           'Messages',
//           style: TextStyle(
//             fontFamily: 'CustomFont3',
//             fontSize: 32,
//             fontWeight: FontWeight.w700,
//             color: Colors.white,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.people_alt_rounded, color: Colors.white),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => MatchesPage(username: widget.username),
//                 ),
//               );
//             },
//           ),
//         ],
//         backgroundColor: const Color.fromRGBO(153, 0, 76, 1),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _errorMessage.isNotEmpty
//           ? Center(child: Text(_errorMessage))
//           : _conversations.isEmpty
//           ? const Center(child: Text('No conversations found'))
//           : ListView.builder(
//         itemCount: _conversations.length,
//         itemBuilder: (context, index) {
//           final conversation = _conversations[index];
//           return Card(
//             color: Color.fromRGBO(153, 0, 76, 1),
//             child: ListTile(
//               title: Text(
//                 conversation.partner,
//                 style: const TextStyle(color: Colors.white),
//               ),
//               subtitle: Text(
//                 conversation.createdAt,
//                 style: const TextStyle(color: Colors.white70),
//               ),
//               trailing: const Icon(
//                 Icons.arrow_forward_ios,
//                 color: Colors.white,
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ChatPage(
//                       sender: widget.username,
//                       roomName: conversation.roomName,
//                       receiver: conversation.partner,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class Conversation {
//   final String roomName;
//   final String partner;
//   final String createdAt;
//
//   Conversation({
//     required this.roomName,
//     required this.partner,
//     required this.createdAt,
//   });
//
//   factory Conversation.fromJson(Map<String, dynamic> json) {
//     return Conversation(
//       roomName: json['room_name'],
//       partner: json['partner'],
//       createdAt: json['created_at'],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'api_service.dart'; // Ensure this import points to your API service
import 'chat_page.dart'; // Ensure this import points to your chat page
import 'my_matches.dart'; // Ensure this import points to your matches page

class MessagesPage extends StatefulWidget {
  final String username;

  const MessagesPage({Key? key, required this.username}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  List<Conversation> _conversations = [];
  Map<String, Map<String, dynamic>> _profiles = {}; // Store profile data
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchChatRooms();
  }

  // Fetch chat rooms
  Future<void> _fetchChatRooms() async {
    try {
      final response = await ApiService().fetchChatRooms(widget.username);

      if (response.isEmpty) {
        setState(() {
          _errorMessage = 'No conversations found';
          _isLoading = false;
        });
      } else {
        _conversations = response
            .map((conversationData) => Conversation.fromJson(conversationData))
            .toList();

        await _fetchProfiles(); // Fetch profile details
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching chat rooms: $e';
        _isLoading = false;
      });
    }
  }

  // Fetch profile data for each partner
  Future<void> _fetchProfiles() async {
    for (var conversation in _conversations) {
      var profileData = await ApiService().loadProfile(conversation.partner);
      if (profileData != null) {
        setState(() {
          _profiles[conversation.partner] = profileData;
        });
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Messages',
          style: TextStyle(
            fontFamily: 'CustomFont3',
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people_alt_rounded, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchesPage(username: widget.username),
                ),
              );
            },
          ),
        ],
        backgroundColor: const Color.fromRGBO(153, 0, 76, 1),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : _conversations.isEmpty
          ? const Center(child: Text('No conversations found'))
          : ListView.builder(
        itemCount: _conversations.length,
        itemBuilder: (context, index) {
          final conversation = _conversations[index];
          final profile = _profiles[conversation.partner];

          // Extract profile data
          final String profileImage = profile?['profile_image'];
          final String name = profile?['name'] ?? conversation.partner;
          final String username = conversation.partner;

          return Card(
            color: const Color.fromRGBO(153, 0, 76, 1),
            child: Container(
              height: 90, // Adjust height as needed
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(profileImage),
                ),
                title: Text(
                  name,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '@$username',
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        sender: widget.username,
                        roomName: conversation.roomName,
                        receiver: conversation.partner,
                      ),
                    ),
                  );
                },
              ),
            ),
          );

        },
      ),
    );
  }
}

class Conversation {
  final String roomName;
  final String partner;
  final String createdAt;

  Conversation({
    required this.roomName,
    required this.partner,
    required this.createdAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      roomName: json['room_name'],
      partner: json['partner'],
      createdAt: json['created_at'],
    );
  }
}
