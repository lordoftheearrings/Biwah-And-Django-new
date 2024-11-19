import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'edit_profile_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  final String email;

  ProfilePage({required this.email});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _name = '';
  String _phoneNumber = '';
  String _age = '';
  String _gender = 'Male';
  String _religion = '';
  String _caste = '';
  String _bio = '';
  String _errorMessage = '';
  String? _profileImageUrl;
  File? _profileImage;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  bool _isProfileExisting = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      DocumentSnapshot profile = await _firestore.collection('users').doc(widget.email).get();
      if (profile.exists) {
        setState(() {
          _isProfileExisting = true;
          _name = profile['name'];
          _phoneNumber = profile['phoneNumber'];
          _age = profile['age'];
          _gender = profile['gender'];
          _religion = profile['religion'];
          _caste = profile['caste'];
          _bio = profile['bio'];
          _profileImageUrl = profile['profileImage'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isProfileExisting = false;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load profile.';
        _isLoading = false;
      });
    }
  }

  Future<void> _pickProfileImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadProfileImage(File image) async {
    try {
      String fileName = '${widget.email}.jpg';
      UploadTask uploadTask = _storage.ref().child('profile_images/$fileName').putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image');
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _errorMessage = '';
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        if (_profileImage != null) {
          _profileImageUrl = await _uploadProfileImage(_profileImage!);
        }
        Map<String, dynamic> profileData = {
          'name': _name,
          'phoneNumber': _phoneNumber,
          'age': _age,
          'gender': _gender,
          'religion': _religion,
          'caste': _caste,
          'bio': _bio,
          'profileImage': _profileImageUrl,
        };
        await _firestore.collection('users').doc(widget.email).set(profileData);
        setState(() {
          _isProfileExisting = true;
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Profile update failed. Please try again.';
        });
      }
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                Navigator.pop(context);
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              } catch (e) {
                print('Error logging out: $e');
              }
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Loading...'),
          backgroundColor: Colors.black,
        ),
        body: Center(child: CircularProgressIndicator()),
        backgroundColor: Colors.black,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_name.isNotEmpty ? _name : 'Profile', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF9C004C),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage(email: widget.email)),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _confirmLogout,
          ),
        ],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isProfileExisting ? _buildProfileView() : _buildProfileForm(),
      ),
      backgroundColor: Color(0xFF121212),
    );
  }

  Widget _buildProfileView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Image Section with Shadow and Border
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickProfileImage, // When clicked, it opens the image picker
                  child: CircleAvatar(
                    radius: 90,
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : null,
                    backgroundColor: Colors.transparent,
                    child: _profileImageUrl == null
                        ? Icon(Icons.add_a_photo, color: Colors.white, size: 40)
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  _name,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  _bio,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey[400]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          Divider(color: Colors.grey, thickness: 0.5),
          // Profile Information Cards
          _buildProfileInfoCard('Phone Number', _phoneNumber),
          _buildProfileInfoCard('Age', _age),
          _buildProfileInfoCard('Gender', _gender),
          _buildProfileInfoCard('Religion', _religion),
          _buildProfileInfoCard('Caste', _caste),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            // Profile Image Picker with a Circular Border
            GestureDetector(
              onTap: _pickProfileImage,
              child: CircleAvatar(
                radius: 90,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : null,
                child: _profileImage == null
                    ? Icon(Icons.add_a_photo, color: Colors.white)
                    : null,
                backgroundColor: Color(0xFF9C004C),
              ),
            ),
            SizedBox(height: 20),
            _buildTextFormField('Name', _name, (value) => _name = value!),
            _buildTextFormField('Phone Number', _phoneNumber, (value) => _phoneNumber = value!),
            _buildTextFormField('Age', _age, (value) => _age = value!),
            _buildDropdownField('Gender', _gender, (value) => _gender = value!),
            _buildTextFormField('Religion', _religion, (value) => _religion = value!),
            _buildTextFormField('Caste', _caste, (value) => _caste = value!),
            _buildTextFormField('Bio', _bio, (value) => _bio = value!),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9C004C),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, String initialValue, Function(String?) onSave) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Color(0xFF1C1C1C),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        initialValue: initialValue,
        onSaved: onSave,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Color(0xFF1C1C1C),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: _genders.map((String gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: Text(gender),
          );
        }).toList(),
        onChanged: onChanged,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildProfileInfoCard(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        color: Color(0xFF1C1C1C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$label:',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(
                value,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
