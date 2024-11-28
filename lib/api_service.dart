import 'dart:convert';
import 'dart:io'; // For handling files
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://192.168.190.241:8000/biwah';

  // Register User
  Future<void> registerUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode != 201) {
      final errorData = jsonDecode(response.body);
      throw Exception('Failed to register user: ${errorData['message'] ??
          'Unknown error'}');
    }
  }

  // Login User
  Future<bool> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
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
      Uri.parse('$baseUrl/user-profile/$username/'),
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
        Uri.parse('$baseUrl/update-profile/$username/'),
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
      print('Request URL: $baseUrl/weighted_score/$username/');

      final response = await http.get(
        Uri.parse('$baseUrl/weighted_score/$username/'),
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
        Uri.parse('$baseUrl/generate_kundali/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'year': year,
          'month': month,
          'day': day,
          'hour': hour,
          'minute': minute,
          'second': second,
          'latitude': latitude,
          'longitude': longitude,
          'birth_location': birthLocation,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extract the SVG content directly from the response
        String kundaliSvgContent = data['kundali_svg_content'];

        print('Kundali generated successfully');
        print(kundaliSvgContent);
        // Return the SVG content and message in a Map
        return {
          'message': 'Kundali generated and saved',
          'kundali_svg_content': kundaliSvgContent,

        };
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

// Fetch Gun Milan Points
  Future<Map<String, dynamic>?> calculateAshtakootPoints(
      Map<String, dynamic> boyDetails, Map<String, dynamic> girlDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ashtakoot/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'year_boy': boyDetails['year'],
          'month_boy': boyDetails['month'],
          'day_boy': boyDetails['day'],
          'hour_boy': boyDetails['hour'],
          'minute_boy': boyDetails['minute'],
          'second_boy': boyDetails['second'],
          'latitude_boy': boyDetails['latitude'],
          'longitude_boy': boyDetails['longitude'],
          'year_girl': girlDetails['year'],
          'month_girl': girlDetails['month'],
          'day_girl': girlDetails['day'],
          'hour_girl': girlDetails['hour'],
          'minute_girl': girlDetails['minute'],
          'second_girl': girlDetails['second'],
          'latitude_girl': girlDetails['latitude'],
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
}

