import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io'; // For handling files

class ApiService {
  final String baseUrl = 'http://192.168.0.101:8000/biwah';

  // Register User
  Future<void> registerUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register user: ${response.body}');
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
      return false;
    }
  }

  // Load Profile Data
  Future<Map<String, dynamic>?> loadProfile(String username) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user-profile/$username/'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      return null;
    }
  }

  // Update Profile with Optional Images
  Future<bool> updateProfileWithOptionalImages({
    required String username,
    required Map<String, dynamic> profileData,
    File? profileImageSource, // Expecting File, not ImageSource
    File? coverImageSource,   // Expecting File, not ImageSource
  }) async {
    try {
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse('$baseUrl/update-profile/$username/'),
      );

      // Add other profile data (e.g., name, phone number, etc.)
      profileData.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Add Profile Image (if selected)
      if (profileImageSource != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_image',
          profileImageSource.path,  // Use file path here
        ));
      }

      // Add Cover Image (if selected)
      if (coverImageSource != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'cover_image',
          coverImageSource.path,  // Use file path here
        ));
      }

      final response = await request.send();

      return response.statusCode == 200;
    } catch (e) {
      print('Error during profile update with images: $e');
      return false;
    }
  }
}
