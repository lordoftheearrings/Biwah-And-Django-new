import 'dart:convert';
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
                            color: _selectedIndex == index ? Colors.white : Colors.white60,
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
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        bool isReceiver = item.containsKey('receiver') && item['receiver'] == widget.username; // Ensure receiver condition

        print('Item: $item'); // Debug print to check the item data
        print('isReceiver: $isReceiver'); // Debug print to check the isReceiver condition
        print('showButtons: $showButtons'); // Debug print to check the showButtons condition

        return Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Padding around each profile card
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10), // Margin between the cards
          decoration: BoxDecoration(
            color: Colors.white,
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
            contentPadding: EdgeInsets.all(10), // Padding inside the ListTile
            title: Text(
              item[key],
              style: TextStyle(fontSize: 18),
            ),
            subtitle: Text('Sent at: ${item['sent_at']}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewUser(username: item[key]),
                ),
              );
            },
            trailing: showButtons && isReceiver
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    _acceptMatchRequest(item['sender'], item['receiver']);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    _declineMatchRequest(item['sender'], item['receiver']);
                  },
                ),
              ],
            )
                : null,
          ),
        );
      },
    );
  }

  void _acceptMatchRequest(String sender, String receiver) async {
    final response = await _apiService.acceptMatchRequest(sender, receiver);
    if (response['error'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Match request accepted!")),
      );
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
