import 'dart:convert';
import 'dart:io'; // For handling files
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://8338-202-166-217-216.ngrok-free.app';

  // Register User
  Future<void> registerUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/biwah/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode   != 201) {
      final errorData = jsonDecode(response.body);
      throw Exception('Failed to register user: ${errorData['message'] ??
          'Unknown error'}');
    }
  }

  // Login User
  Future<bool> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/biwah/login/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(
          'Login failed: ${errorData['message'] ?? 'Invalid credentials'}');
    }
  }

  // Load Profile Data for a user
  Future<Map<String, dynamic>?> loadProfile(String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/biwah/user-profile/$username/'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {

      return jsonDecode(response.body);

    } else {
      print('Failed to load profile: ${response.statusCode}');
      return null;
    }
  }

  // Update Profile with Optional Images
  Future<bool> updateProfileWithOptionalImages({
    required String username,
    required Map<String, dynamic> profileData,
    File? profileImageSource,
    File? coverImageSource,
  }) async {
    try {
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse('$baseUrl/biwah/update-profile/$username/'),
      );

      // Add profile fields (name, phone number, etc.)
      profileData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add profile image if provided
      if (profileImageSource != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_image',
          profileImageSource.path,
        ));
      }

      // Add cover image if provided
      if (coverImageSource != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'cover_image',
          coverImageSource.path,
        ));
      }

      final response = await request.send();
      final responseBody = await response.stream
          .bytesToString(); // Decode response stream

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Profile update failed: $responseBody');
        return false;
      }
    } catch (e) {
      print('Error during profile update: $e');
      return false;
    }
  }

// Matchmaking - Fetch matched profiles based on preferences
  Future<Map<String, dynamic>?> getMatchmakingProfiles(String username) async {
    try {
      // Log the request details for debugging
      print('Fetching matchmaking profiles for user: $username');
      print('Request URL: $baseUrl/biwah/weighted_score/$username/');

      final response = await http.get(
        Uri.parse('$baseUrl/biwah/weighted_score/$username/'),
        headers: {'Content-Type': 'application/json'},
      );



      if (response.statusCode == 200) {
        // Log the successful response body for debugging
        print('Response Body: ${response.body}');

        // Parse the response body
        Map<String, dynamic> responseData = jsonDecode(response.body);



        // Return the parsed data (list of matched usernames, etc.)
        return responseData;
      } else if (response.statusCode == 404) {
        // Log when no user or matches were found
        print('User not found or no matches found for user: $username');
        return null;
      } else {
        // Log unexpected status codes for debugging
        print('Failed to load matchmaking profiles. Status Code: ${response.statusCode}');

        return null;
      }
    } catch (e) {
      // Log any errors during the HTTP request
      print('Error fetching matchmaking profiles: $e');
      return null;
    }
  }


// Generate Kundali
  Future<Map<String, dynamic>?> generateKundali({
    required String username,
    required int year,
    required int month,
    required int day,
    required int hour,
    required int minute,
    required int second,
    required double latitude,
    required double longitude,
    required String birthLocation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/biwah/generate_kundali/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'year': year,
          'month': month,
          'day': day,
          'hour': hour,
          'minute': minute,
          'second': second,
          'latitude': 65.0,
          'longitude': longitude,
          'birth_location': birthLocation,
        }),
      );

      if (response.statusCode == 200) {
        print('Saved Kundali: ${response.body}');
        return {'message': 'Kundali Saved'};


        // Return the SVG content and message in a Map


      } else {
        print('Failed to generate Kundali: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error generating Kundali: $e');
      return null;
    }
  }
  Future<String?> getKundaliSvg(String username) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/biwah/retrieve_kundali/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty && data[0] is String) {
          final svgContent = data[0] as String;
          return svgContent;
        } else {
          print('Unexpected response format: $data');
          return null;
        }
      } else {
        print('Failed to fetch Kundali: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching Kundali: $e');
      return null;
    }
  }

// Fetch Gun Milan Points
  Future<Map<String, dynamic>?> calculateAshtakootPoints(
      Map<String, dynamic> boyDetails, Map<String, dynamic> girlDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/biwah/ashtakoot/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'year_boy': boyDetails['year'],
          'month_boy': boyDetails['month'],
          'day_boy': boyDetails['day'],
          'hour_boy': boyDetails['hour'],
          'minute_boy': boyDetails['minute'],
          'second_boy': boyDetails['second'],
          'latitude_boy': 65.0,
          'longitude_boy': boyDetails['longitude'],
          'year_girl': girlDetails['year'],
          'month_girl': girlDetails['month'],
          'day_girl': girlDetails['day'],
          'hour_girl': girlDetails['hour'],
          'minute_girl': girlDetails['minute'],
          'second_girl': girlDetails['second'],
          'latitude_girl': 65.0,
          'longitude_girl': girlDetails['longitude'],
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to calculate Ashtakoot points: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error calculating Ashtakoot points: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> searchUsers({
    required String searchTerm,
    int? ageMin,
    int? ageMax,
    String? gender,
    String? religion,
    String? caste,
    String? gotra,
    int page = 1,
  }) async {
    final uri = Uri.parse('$baseUrl/biwah/search/').replace(queryParameters: {
      'search': searchTerm,
      if (ageMin != null) 'age_min': ageMin.toString(),
      if (ageMax != null) 'age_max': ageMax.toString(),
      if (gender != null && gender != 'Any') 'gender': gender,
      if (religion != null && religion != 'Any') 'religion': religion,
      if (caste != null && caste != 'Any') 'caste': caste,
      if (gotra != null && gotra != 'Any') 'gotra': gotra,
      'page': page.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }





  Future<Map<String, dynamic>> sendMatchRequest(String senderUsername,String receiverUsername) async {
    final url = Uri.parse('$baseUrl/chat/send_match_request/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',

      },
      body: json.encode({
        'sender_username': senderUsername,
        'receiver_username': receiverUsername
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else if(response.statusCode == 400){
      return {'message': json.decode(response.body)['message']};
    }else {
      return {'error': 'Failed to send match request'};
    }
  }

  Future<Map<String, dynamic>> cancelMatchRequest(String senderUsername, String receiverUsername) async {
    final url = Uri.parse('$baseUrl/chat/cancel_match_request/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'sender_username': senderUsername,
        'receiver_username': receiverUsername,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 400) {
      final errorMessage = json.decode(response.body)['error'];
      return {'error': errorMessage};
    } else {
      return {'error': 'Failed to cancel match request'};
    }
  }

  Future<Map<String, dynamic>> acceptMatchRequest(String sender, String receiver) async {
    final url = Uri.parse('$baseUrl/chat/accept_match_request/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'sender': sender, 'receiver': receiver}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'error': 'Failed to accept match request'};
    }
  }

  Future<Map<String, dynamic>> declineMatchRequest(String sender, String receiver) async {
    final url = Uri.parse('$baseUrl/chat/decline_match_request/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'sender': sender, 'receiver': receiver}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'error': 'Failed to decline match request'};
    }
  }


  Future<Map<String, dynamic>> listMatchRequests(String username) async {
    final url = Uri.parse('$baseUrl/chat/list_match_requests/?username=$username');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {'error': 'Failed to fetch match requests'};
    }
  }

  Future<List< dynamic>> fetchChatRooms(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/chat/fetch-chat-rooms/?username=$username'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception ( "Failed to load chat rooms");
      }
    } catch (e) {
      throw Exception('Error fetching chat rooms: $e');
    }
  }


  // Future<Map<String, dynamic>> sendMessage(String roomName, String senderUsername, String content) async {
  //   final url = Uri.parse('$baseUrl/chat/send-message/');
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: json.encode({
  //       'room_name': roomName,
  //       'sender_username': senderUsername,
  //       'content': content,
  //     }),
  //   );
  //
  //   if (response.statusCode == 201) {
  //     return json.decode(response.body);
  //   } else {
  //     return {'error': 'Failed to send message'};
  //   }
  // }

  Future<List<Map<String, dynamic>>> getMessages(String roomName) async {
    final url = Uri.parse('$baseUrl/chat/get-messages/?room_name=$roomName');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(json.decode(response.body));
      // Access the 'messages_data' key, which should contain the list of messages
      return List<Map<String, dynamic>>.from(responseData['messages_data']);
    } else {
      return [];
    }
  }


  Future<List<dynamic>> fetchNotifications(String username) async {
    final response = await http.get(Uri.parse('$baseUrl/chat/notifications/?username=$username'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['notifications'];
    } else {
      throw Exception('Failed to load notifications');
    }
  }


  Future<bool> savePreferences(String username, Map<String, dynamic> preferencesData) async {
    final url = Uri.parse('$baseUrl/biwah/save-preferences/'); // Replace with actual server URL

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'username': username,
          'p_age_min': preferencesData['age_range']['min'],
          'p_age_max': preferencesData['age_range']['max'],
          'p_religion': preferencesData['religion'],
          'p_caste': preferencesData['caste'],
          'p_gotra': preferencesData['gotra'],
          'p_height_min': preferencesData['height_range']['min'],
          'p_height_max': preferencesData['height_range']['max'],
          'p_weight_min': preferencesData['weight_range']['min'],
          'p_weight_max': preferencesData['weight_range']['max'],
          'p_habits_drinking': preferencesData['drinking_habit'],
          'p_habits_eating': preferencesData['eating_habit'],
          'p_habits_smoking': preferencesData['smoking_habit'],
          'p_zodiac': preferencesData['zodiac'],
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Preferences saved successfully!');
        return true; // Return true on success
      } else {
        print('Failed to save preferences');
        return false; // Return false on failure
      }
    } catch (e) {
      print('Error saving preferences: $e');
      return false; // Return false if there was an error
    }
  }

  Future<bool> saveWeights(String username, Map<String, dynamic> weightsData) async {
    try {
      final url = Uri.parse('$baseUrl/biwah/save-weights/'); // Replace with actual server URL
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'username': username,
          'age_weight': weightsData['age_weight'],
          'religion_weight': weightsData['religion_weight'],
          'caste_weight': weightsData['caste_weight'],
          'gotra_weight': weightsData['gotra_weight'],
          'height_weight': weightsData['height_weight'],
          'weight_weight': weightsData['weight_weight'],
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true; // Indicating success
      } else {
        return false; // Indicating failure
      }
    } catch (e) {
      print('Error: $e');
      return false; // Indicating error in API call
    }
  }



}

