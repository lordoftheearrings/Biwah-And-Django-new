// import 'package:flutter/material.dart';
//
// class NotificationPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(68, 29, 47, 1.0),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(
//           'Notifications',
//           style: TextStyle(
//             fontFamily: 'CustomFont3',
//             fontSize: 32,
//             fontWeight: FontWeight.w700,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Color.fromRGBO(153, 0, 76, 1),
//         elevation: 0,
//       ),
//       body: Container(
//         color: Colors.white,
//         child: ListView(
//           padding: EdgeInsets.all(16.0),
//           children: [
//             Text(
//               "Today",
//               style: TextStyle(
//                 fontFamily: 'CustomFont2',
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//                 color: Color.fromRGBO(153, 0, 76, 1),
//               ),
//             ),
//             SizedBox(height: 8),
//             _buildNotificationCard(
//               title: "Match Request Sent by John",
//               description: "John has sent you a match request. View his profile!",
//               time: "5 mins ago",
//               icon: Icons.favorite,
//               iconColor: Colors.pink,
//             ),
//             _buildNotificationCard(
//               title: "Kundali Request Sent by Raj",
//               description: "Raj has requested to view your Kundali details.",
//               time: "30 mins ago",
//               icon: Icons.accessibility,
//               iconColor: Colors.blue,
//             ),
//             _buildNotificationCard(
//               title: "Ashtakoot Guna Milan Points Updated",
//               description: "You can now view the Ashtakoot Guna Milan points in your profile.",
//               time: "1 hour ago",
//               icon: Icons.star,
//               iconColor: Colors.orange,
//             ),
//             SizedBox(height: 16),
//             Text(
//               "Yesterday",
//               style: TextStyle(
//                 fontFamily: 'CustomFont2',
//                 fontSize: 20,
//                 fontWeight: FontWeight.w700,
//                 color: Color.fromRGBO(153, 0, 76, 1),
//               ),
//             ),
//             SizedBox(height: 8),
//             _buildNotificationCard(
//               title: "New Profile Visit by Priya",
//               description: "Priya has viewed your profile. Check her profile now!",
//               time: "12 hours ago",
//               icon: Icons.visibility,
//               iconColor: Colors.green,
//             ),
//             _buildNotificationCard(
//               title: "Profile Match Suggestion",
//               description: "Based on your preferences, we suggest a new match.",
//               time: "1 day ago",
//               icon: Icons.thumb_up,
//               iconColor: Colors.purple,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNotificationCard({
//     required String title,
//     required String description,
//     required String time,
//     required IconData icon,
//     required Color iconColor,
//   }) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       color: Color.fromRGBO(153, 0, 76, 1),
//       child: ListTile(
//         contentPadding: EdgeInsets.all(16),
//         leading: CircleAvatar(
//           backgroundColor: iconColor.withOpacity(0.2),
//           child: Icon(icon, color: iconColor),
//         ),
//         title: Text(
//           title,
//           style: TextStyle(
//             fontFamily: 'PoppinsBold',
//             fontSize: 18,
//             fontWeight: FontWeight.w700,
//             color: Colors.white,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               description,
//               style: TextStyle(
//                 fontFamily: 'PoppinsReg',
//                 fontSize: 14,
//                 fontWeight: FontWeight.w400,
//                 color: Colors.white70,
//               ),
//             ),
//             SizedBox(height: 4),
//             Text(
//               time,
//               style: TextStyle(
//                 fontFamily: 'PoppinsReg',
//                 fontSize: 12,
//                 fontWeight: FontWeight.w400,
//                 color: Colors.grey[500],
//               ),
//             ),
//           ],
//         ),
//         trailing: Icon(
//           Icons.arrow_forward_ios,
//           size: 16,
//           color: Colors.grey[500],
//         ),
//         onTap: () {
//           // Define navigation to detailed notification if needed
//         },
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'my_matches.dart'; // Import MatchesPage

import 'main.dart';

class NotificationPage extends StatefulWidget {
  final String username;

  NotificationPage({required this.username});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<List<dynamic>> _notificationsFuture;
  late Timer _timer;
  final ApiService _apiService = ApiService();
  List<dynamic> _currentNotifications = [];

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _apiService.fetchNotifications(widget.username);

    // Set up periodic fetching of notifications every 20 seconds
    _timer = Timer.periodic(Duration(seconds: 20), (timer) async {
      List<dynamic> newNotifications = await _apiService.fetchNotifications(widget.username);
      setState(() {
        _notificationsFuture = Future.value(newNotifications);
      });

      // Check for new notifications and show popup
      for (var notification in newNotifications) {
        if (!_currentNotifications.any((n) => n['id'] == notification['id'])) {
          _showNotification(notification['title'], notification['description']);
        }
      }

      _currentNotifications = newNotifications;
    });


  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Show local notification
  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'match_notifications', 'Match Requests', // Use a meaningful channel ID and name
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );


  }



  // Navigate to MatchesPage
  void _navigateToMatchesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MatchesPage(username: widget.username)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Notifications',
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
      body: FutureBuilder<List<dynamic>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notifications'));
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final notification = snapshot.data![index];
                return _buildNotificationCard(
                  title: notification['title'],
                  description: notification['description'],
                  time: notification['time'],
                  icon: Icons.notifications,
                  iconColor: Colors.white,
                  onTap: () {
                    if (notification['title'].toLowerCase().contains('match request') ||
                        notification['description'].toLowerCase().contains('match request')) {
                      _navigateToMatchesPage();
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String description,
    required String time,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Color.fromRGBO(153, 0, 76, 1),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'PoppinsBold',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              description,
              style: TextStyle(
                fontFamily: 'PoppinsReg',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontFamily: 'PoppinsReg',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[500],
        ),
        onTap: onTap, // Handle tap action dynamically
      ),
    );
  }
}
