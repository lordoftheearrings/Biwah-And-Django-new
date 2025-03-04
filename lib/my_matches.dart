// import 'dart:convert';
// import 'custom_snackbar.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'view_user.dart'; // Import ViewUser page
// import 'api_service.dart'; // Import the ApiService
//
// class MatchesPage extends StatefulWidget {
//   final String username; // Add a username parameter
//
//   MatchesPage({required this.username}); // Make the username parameter required
//
//   @override
//   _MatchesPageState createState() => _MatchesPageState();
// }
//
// class _MatchesPageState extends State<MatchesPage> {
//   int _selectedIndex = 0;
//   final List<String> _tabs = ['Matches', 'Pending', 'Received'];
//   late Future<Map<String, dynamic>> _matchData; // Future to hold API data
//
//   final ApiService _apiService = ApiService(); // Create an instance of ApiService
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchMatchData(); // Fetch match data on page load
//   }
//
//   void _fetchMatchData() {
//     setState(() {
//       _matchData = _apiService.listMatchRequests(widget.username); // Pass the username
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text(
//           'My Matches',
//           style: TextStyle(
//             fontFamily: 'CustomFont3',
//             fontSize: 30,
//             fontWeight: FontWeight.w500,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Color.fromRGBO(153, 0, 76, 1),
//         elevation: 4,
//       ),
//       body: Column(
//         children: [
//           Container(
//             color: Color.fromRGBO(153, 0, 76, 1),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: List.generate(_tabs.length, (index) {
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _selectedIndex = index;
//                     });
//                   },
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: Text(
//                           _tabs[index],
//                           style: TextStyle(
//                             color: _selectedIndex == index ? Colors.white : Colors.white60,
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       if (_selectedIndex == index)
//                         Container(
//                           height: 2,
//                           width: 40,
//                           color: Colors.white,
//                         ),
//                     ],
//                   ),
//                 );
//               }),
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder<Map<String, dynamic>>(
//               future: _matchData,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!['error'] != null) {
//                   return Center(child: Text('Failed to load matches'));
//                 }
//
//                 final matchData = snapshot.data!;
//                 return _buildContent(matchData);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildContent(Map<String, dynamic> matchData) {
//     switch (_selectedIndex) {
//       case 0:
//         return _buildMatches(matchData['current_matches']);
//       case 1:
//         return _buildPending(matchData['sent_requests']);
//       case 2:
//         return _buildReceived(matchData['received_requests']);
//       default:
//         return _buildMatches(matchData['current_matches']);
//     }
//   }
//
//   Widget _buildMatches(List matches) {
//     return _buildListView(matches, 'partner', false);
//   }
//
//   Widget _buildPending(List pending) {
//     return _buildListView(pending, 'receiver', false);
//   }
//
//   Widget _buildReceived(List received) {
//     return _buildListView(received, 'sender', true);
//   }
//
//   Widget _buildListView(List items, String key, bool showButtons) {
//     return ListView.builder(
//       itemCount: items.length,
//       itemBuilder: (context, index) {
//         final item = items[index];
//         bool isReceiver = item.containsKey('receiver') && item['receiver'] == widget.username; // Ensure receiver condition
//
//         print('Item: $item'); // Debug print to check the item data
//         print('isReceiver: $isReceiver'); // Debug print to check the isReceiver condition
//         print('showButtons: $showButtons'); // Debug print to check the showButtons condition
//
//         return Container(
//           padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Padding around each profile card
//           margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Margin between the cards
//           decoration: BoxDecoration(
//             color: Color.fromRGBO(153, 0, 76, 1.0),
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.3),
//                 spreadRadius: 2,
//                 blurRadius: 5,
//               ),
//             ],
//           ),
//           child: ListTile(
//             contentPadding: EdgeInsets.all(10), // Padding inside the ListTile
//             title: Text(
//               item[key],
//               style: TextStyle(fontSize: 18,color: Colors.white),
//             ),
//             //subtitle: Text('Sent at: ${item['sent_at']}'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ViewUser(username: item[key]),
//                 ),
//               );
//             },
//             trailing: showButtons && isReceiver
//                 ? Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.check_outlined, color: Colors.white),
//                   onPressed: () {
//                     _acceptMatchRequest(item['sender'], item['receiver']);
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.close_outlined, color: Colors.white),
//                   onPressed: () {
//                     _declineMatchRequest(item['sender'], item['receiver']);
//                   },
//                 ),
//               ],
//             )
//                 : null,
//           ),
//         );
//       },
//     );
//   }
//
//   void _acceptMatchRequest(String sender, String receiver) async {
//     final response = await _apiService.acceptMatchRequest(sender, receiver);
//     if (response['error'] == null) {
//       CustomSnackbar.showSuccess(context, "Match request accepted");
//       _fetchMatchData(); // Reload match data
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: ${response['error']}")),
//       );
//     }
//   }
//
//   void _declineMatchRequest(String sender, String receiver) async {
//     final response = await _apiService.declineMatchRequest(sender, receiver);
//     if (response['error'] == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Match request declined!")),
//       );
//       _fetchMatchData(); // Reload match data
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error: ${response['error']}")),
//       );
//     }
//   }
// }
import 'dart:convert';
import 'custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'view_user.dart'; // Import ViewUser page
import 'api_service.dart'; // Import the ApiService

class MatchesPage extends StatefulWidget {
  final String username; // Add a username parameter

  MatchesPage({required this.username}); // Make the username parameter required

  @override
  _MatchesPageState createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  int _selectedIndex = 0;
  final List<String> _tabs = ['Matches', 'Pending', 'Received'];
  late Future<Map<String, dynamic>> _matchData; // Future to hold API data

  final ApiService _apiService = ApiService(); // Create an instance of ApiService

  @override
  void initState() {
    super.initState();
    _fetchMatchData(); // Fetch match data on page load
  }

  void _fetchMatchData() {
    setState(() {
      _matchData = _apiService.listMatchRequests(widget.username); // Pass the username
    });
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
          'My Matches',
          style: TextStyle(
            fontFamily: 'CustomFont3',
            fontSize: 30,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
        elevation: 4,
      ),
      body: Column(
        children: [
          Container(
            color: Color.fromRGBO(153, 0, 76, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_tabs.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          _tabs[index],
                          style: TextStyle(
                            color: _selectedIndex == index
                                ? Colors.white
                                : Colors.white60,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (_selectedIndex == index)
                        Container(
                          height: 2,
                          width: 40,
                          color: Colors.white,
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: _matchData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!['error'] != null) {
                  return Center(child: Text('Failed to load matches'));
                }

                final matchData = snapshot.data!;
                return _buildContent(matchData);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> matchData) {
    switch (_selectedIndex) {
      case 0:
        return _buildMatches(matchData['current_matches']);
      case 1:
        return _buildPending(matchData['sent_requests']);
      case 2:
        return _buildReceived(matchData['received_requests']);
      default:
        return _buildMatches(matchData['current_matches']);
    }
  }

  Widget _buildMatches(List matches) {
    return _buildListView(matches, 'partner', false);
  }

  Widget _buildPending(List pending) {
    return _buildListView(pending, 'receiver', false);
  }

  Widget _buildReceived(List received) {
    return _buildListView(received, 'sender', true);
  }

  Widget _buildListView(List items, String key, bool showButtons) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchAllProfiles(items, key),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading profiles: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No profiles found'));
        }

        final profiles = snapshot.data!;
        return ListView.builder(
          itemCount: profiles.length,
          itemBuilder: (context, index) {
            final profileData = profiles[index];
            final String profileImage = profileData['profile_image'] ?? 'assets/default_profile.png';
            final String name = profileData['name'] ?? 'Unknown';
            final String username = profileData['username'] ?? 'No username';

            return Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(153, 0, 76, 1.0),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(profileImage),
                ),
                title: Text(
                  name,
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                subtitle: Text(
                  '@$username',
                  style: TextStyle(color: Colors.white70),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewUser(username: profileData['username'],currentUsername: widget.username,),
                    ),
                  );
                },
                trailing: showButtons && profileData.containsKey('isReceiver') && profileData['isReceiver']
                    ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      elevation: 5.0, // Adjust the elevation as needed
                      shape: CircleBorder(), // Keeps the button circular
                      child: IconButton(
                        icon: Icon(Icons.check_outlined, color: Color.fromRGBO(153, 0, 76, 1.0)),
                        onPressed: () {
                          _acceptMatchRequest(profileData['sender'], profileData['receiver']);
                        },
                      ),
                    ),
                    SizedBox(width: 10), // Add some space between the buttons
                    Material(
                      elevation: 5.0, // Adjust the elevation as needed
                      shape: CircleBorder(), // Keeps the button circular
                      child: IconButton(
                        icon: Icon(Icons.close_outlined, color: Color.fromRGBO(153, 0, 76, 1.0)),
                        onPressed: () {
                          _declineMatchRequest(profileData['sender'], profileData['receiver']);
                        },
                      ),
                    ),
                  ],

                )
                    : null,
              ),
            );
          },
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchAllProfiles(List items, String key) async {
    List<Future<Map<String, dynamic>?>> futures = items.map((item) async {
      final profileData = await _apiService.loadProfile(item[key]);
      if (profileData != null) {
        profileData['isReceiver'] = item.containsKey('receiver') && item['receiver'] == widget.username;
        profileData['sender'] = item['sender'];
        profileData['receiver'] = item['receiver'];
      }
      return profileData;
    }).toList();

    final results = await Future.wait(futures);
    return results.whereType<Map<String, dynamic>>().toList();
  }

  void _acceptMatchRequest(String sender, String receiver) async {
    final response = await _apiService.acceptMatchRequest(sender, receiver);
    if (response['error'] == null) {
      CustomSnackbar.showSuccess(context, "Match request accepted");
      _fetchMatchData(); // Reload match data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response['error']}")),
      );
    }
  }

  void _declineMatchRequest(String sender, String receiver) async {
    final response = await _apiService.declineMatchRequest(sender, receiver);
    if (response['error'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Match request declined!")),
      );
      _fetchMatchData(); // Reload match data
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response['error']}")),
      );
    }
  }
}
