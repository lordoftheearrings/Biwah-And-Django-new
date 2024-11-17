import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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
  String _gender = 'Male'; // default value
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
                Navigator.pushReplacementNamed(context, '/login'); // Update route as needed
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
        title: Text(_name.isNotEmpty ? _name : 'Profile', style: TextStyle(fontFamily: 'CustomFont2',fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
        actions: [
          IconButton(
            icon: Icon(Icons.edit,color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage(email: widget.email)),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout,color: Colors.white),
            onPressed: _confirmLogout,
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isProfileExisting ? _buildProfileView() : _buildProfileForm(),
      ),
      floatingActionButton: _isProfileExisting
          ? FloatingActionButton(
        onPressed: () {
          // Navigate to Add Post screen
        },
        child: Icon(Icons.post_add),
        backgroundColor: Colors.pink,
      )
          : null,
      backgroundColor: Colors.black,
    );
  }

  Widget _buildProfileView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                if (_profileImageUrl != null)
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(_profileImageUrl!),
                  ),
                SizedBox(height: 16),
                Text(
                  _name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Divider(color: Colors.grey),
          _buildProfileInfoRow('Phone Number', _phoneNumber),
          _buildProfileInfoRow('Age', _age),
          _buildProfileInfoRow('Gender', _gender),
          _buildProfileInfoRow('Religion', _religion),
          _buildProfileInfoRow('Caste', _caste),
          _buildProfileInfoRow('Bio', _bio),
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
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            GestureDetector(
              onTap: _pickProfileImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : null,
                child: _profileImage == null
                    ? Icon(Icons.add_a_photo)
                    : null,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.grey)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              initialValue: _name,
              onSaved: (value) {
                _name = value!;
              },
              style: TextStyle(color: Colors.white),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Phone Number', labelStyle: TextStyle(color: Colors.grey)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
              initialValue: _phoneNumber,
              onSaved: (value) {
                _phoneNumber = value!;
              },
              style: TextStyle(color: Colors.white),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Age', labelStyle: TextStyle(color: Colors.grey)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                return null;
              },
              initialValue: _age,
              onSaved: (value) {
                _age = value!;
              },
              style: TextStyle(color: Colors.white),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Gender', labelStyle: TextStyle(color: Colors.grey)),
              value: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
              items: _genders.map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              style: TextStyle(color: Colors.white),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Religion', labelStyle: TextStyle(color: Colors.grey)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your religion';
                }
                return null;
              },
              initialValue: _religion,
              onSaved: (value) {
                _religion = value!;
              },
              style: TextStyle(color: Colors.white),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Caste', labelStyle: TextStyle(color: Colors.grey)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your caste';
                }
                return null;
              },
              initialValue: _caste,
              onSaved: (value) {
                _caste = value!;
              },
              style: TextStyle(color: Colors.white),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Bio', labelStyle: TextStyle(color: Colors.grey)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your bio';
                }
                return null;
              },
              initialValue: _bio,
              onSaved: (value) {
                _bio = value!;
              },
              style: TextStyle(color: Colors.white),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save Profile'),
              style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(153, 0, 76, 1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String email;

  EditProfilePage({required this.email});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  String _name = '';
  String _phoneNumber = '';
  String _age = '';
  String _gender = 'Male'; // default value
  String _religion = '';
  String _caste = '';
  String _bio = '';
  String _errorMessage = '';
  String? _profileImageUrl;
  File? _profileImage;

  final List<String> _genders = ['Male', 'Female', 'Other'];
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
        Navigator.pop(context);
      } catch (e) {
        setState(() {
          _errorMessage = 'Profile update failed. Please try again.';
        });
      }
    }
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
        title: Text('Edit Profile',style: TextStyle(
          fontFamily: 'CustomFont2',
          fontSize: 20,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildProfileForm(),
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildProfileForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            GestureDetector(
              onTap: _pickProfileImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : (_profileImageUrl != null
                    ? NetworkImage(_profileImageUrl!)
                    : null),
                child: _profileImage == null && _profileImageUrl == null
                    ? Icon(Icons.add_a_photo)
                    : null,
              ),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.grey)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              initialValue: _name,
              onSaved: (value) {
                _name = value!;
              },
              style: TextStyle(color: Colors.white),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Phone Number', labelStyle: TextStyle(color: Colors.grey)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
              initialValue: _phoneNumber,
              onSaved: (value) {
                _phoneNumber = value!;
              },
              style: TextStyle(color: Colors.white),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Age', labelStyle: TextStyle(color: Colors.grey)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                return null;
              },
              initialValue: _age,
              onSaved: (value) {
                _age = value!;
              },
              style: TextStyle(color: Colors.white),
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Gender', labelStyle: TextStyle(color: Colors.grey)),
              value: _gender,
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
              items: _genders.map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              style: TextStyle(color: Colors.white),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Religion', labelStyle: TextStyle(color: Colors.grey)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your religion';
                }
                return null;
              },
              initialValue: _religion,
              onSaved: (value) {
                _religion = value!;
              },
              style: TextStyle(color: Colors.white),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Caste', labelStyle: TextStyle(color: Colors.grey)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your caste';
                }
                return null;
              },
              initialValue: _caste,
              onSaved: (value) {
                _caste = value!;
              },
              style: TextStyle(color: Colors.white),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Bio', labelStyle: TextStyle(color: Colors.grey)),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your bio';
                }
                return null;
              },
              initialValue: _bio,
              onSaved: (value) {
                _bio = value!;
              },
              style: TextStyle(color: Colors.white),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Save Profile'),
              style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(153, 0, 76, 1)),
            ),
          ],
        ),
      ),
    );
  }
}
