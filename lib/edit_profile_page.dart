import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api_service.dart';
import 'dart:io';


class EditProfilePage extends StatefulWidget {
  final String username;

  EditProfilePage({required this.username});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phoneNumber = '';
  String _age = '';
  String _gender = 'Male';
  String _bio = '';
  String _caste = 'Other';
  String _religion = 'Other';
  bool _isLoading = false;
  File? _profileImage;
  File? _coverImage;

  @override
  void initState() {
    super.initState();
    _loadExistingProfile();
  }
  Future<void> _loadExistingProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profileData = await ApiService().loadProfile(widget.username);
      if (profileData != null) {
        setState(() {
          _name = profileData['name'] ?? '';
          _phoneNumber = profileData['phone_number']?.toString() ?? '';
          _age = profileData['age']?.toString() ?? '';
          _gender = ['Male', 'Female', 'Other'].contains(profileData['gender'])
              ? profileData['gender']
              : 'Male';
          _bio = profileData['bio'] ?? '';
          _caste = ['Newar', 'Brahmin', 'Chhetri','Tamang','Gurung','Lama','Limbu','Other'].contains(profileData['caste']) ? profileData['caste']
              : 'Other';
          _religion= ['Hindu', 'Muslim', 'Christian','Buddhism','Jewish','Other'].contains(profileData['religion']) ? profileData['religion']
              : 'Other';
        });
      }
    } catch (e) {
      print('Error loading profile for editing: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      Map<String, dynamic> profileData = {
        'name': _name,
        'phone_number': int.tryParse(_phoneNumber) ?? 0,
        'age': int.tryParse(_age) ?? 0,
        'gender': _gender,
        'bio': _bio,
        'caste':_caste,
        'religion':_religion,
      };
      bool success = await ApiService().updateProfileWithOptionalImages(
        username: widget.username,
        profileData: profileData,
        profileImageSource: _profileImage, // Pass the actual image file (File?)
        coverImageSource: _coverImage,     // Pass the actual image file (File?)
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        Navigator.pop(context); // Go back to Profile Page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile')),
        );
      }
    }
  }
  Future<void> _pickImage(bool isProfileImage) async {
    if ((isProfileImage && _profileImage != null) || (!isProfileImage && _coverImage != null)) {
      return; // Exit if an image is already selected
    }

    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isProfileImage) {
          _profileImage = File(pickedFile.path);
        } else {
          _coverImage = File(pickedFile.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(68, 29, 47, 1.0), // Set background color to black
      appBar: AppBar(
        leading: IconButton(  // Add back button
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);  // Go back to previous page
          },
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'CustomFont3', // Add custom font if needed
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
        elevation: 5,
        actions: [
          ElevatedButton(
            onPressed: _saveProfile,
            child: Text('Save', style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15, color: Colors.black)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(255, 182, 193, 1),
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: 10,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          SizedBox(width: 10), // Add some space to the right of the button
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile Image', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              Center(
                child: GestureDetector(
                  onTap: () => _pickImage(true),

                  child: CircleAvatar(

                    radius: 75,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : null,

                    child: _profileImage == null
                        ? Icon(Icons.photo_camera_back, size: 50, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 25),
              Text('Cover Image', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 15),
              GestureDetector(
                onTap: () => _pickImage(false),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(5),
                    image: _coverImage != null
                        ? DecorationImage(
                      image: FileImage(_coverImage!),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: _coverImage == null
                      ? Center(child: Icon(Icons.photo_camera_back, size: 50, color: Colors.grey))
                      : null,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(fontWeight:FontWeight.bold,color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
                onSaved: (value) => _name = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _phoneNumber,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(fontWeight:FontWeight.bold,color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Please enter your phone number' : null,
                onSaved: (value) => _phoneNumber = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _age,
                decoration: InputDecoration(
                  labelText: 'Age',
                  labelStyle: TextStyle(fontWeight:FontWeight.bold,color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter your age' : null,
                onSaved: (value) => _age = value!,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  labelStyle: TextStyle(fontWeight:FontWeight.bold,color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                dropdownColor: Colors.black,
                style: TextStyle(color: Colors.white),
                onChanged: (newValue) {
                  setState(() {
                    _gender = newValue!;
                  });
                },
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                items: ['Male', 'Female', 'Other']

                    .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(gender, style: TextStyle(color: Colors.white)),
                ))
                    .toList(),
              ),
              SizedBox(height: 16),


              DropdownButtonFormField<String>(
                value: _caste,
                decoration: InputDecoration(
                  labelText: 'Caste',
                  labelStyle: TextStyle(fontWeight:FontWeight.bold,color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                dropdownColor: Colors.black,
                style: TextStyle(color: Colors.white),
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                items: ['Brahmin', 'Chhetri', 'Newar', 'Tharu', 'Tamang','Rai','Magar','Limbu','Other']
                    .map((caste) => DropdownMenuItem(
                  value: caste,
                  child: Text(caste, style: TextStyle(color: Colors.white)),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _caste = value ?? 'Other'),
              ),
              SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _religion,
                decoration: InputDecoration(
                  labelText: 'Religion',
                  labelStyle: TextStyle(fontWeight:FontWeight.bold,color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                dropdownColor: Colors.black,
                style: TextStyle(color: Colors.white),
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                items: ['Hindu', 'Muslim', 'Christian','Buddhism','Jewish','Other']
                    .map((religion) => DropdownMenuItem(
                  value: religion,
                  child: Text(religion, style: TextStyle(color: Colors.white)),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _religion = value ?? 'Other'),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _bio,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  labelStyle: TextStyle(fontWeight:FontWeight.bold,color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                maxLines: 3,
                onSaved: (value) => _bio = value!,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
