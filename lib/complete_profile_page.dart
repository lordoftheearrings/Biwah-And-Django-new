import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'api_service.dart';
import 'dart:io';
import 'home_page.dart';

class CompleteProfilePage extends StatefulWidget {
  final String username;

  CompleteProfilePage({required this.username});

  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phoneNumber = '';
  String _age = '';
  String _gender = 'Male';
  String _bio = '';
  String _caste = 'Other';
  String _religion = 'Other';
  String _gotra = 'Bharadwaj';
  String _height = '';
  String _weight = '';
  String _zodiac = 'Mesha';
  String _education = '';
  String _profession = '';
  String _familyType = 'Nuclear';
  String _address = '';
  String _complexion = '';
  String _maritalStatus = 'Single';
  String _habitsDrinking = 'Non-Alcoholic';
  String _habitsEating = 'Veg';
  String _habitsSmoking = 'Non-Smoker';
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
          _caste = ['Bharadwaj', 'Kashyap', 'Vashishtha', 'Vishwamitra', 'Gautam', 'Jamadagni', 'Atri', 'Agastya', 'Bhrigu', 'Angirasa', 'Parashar', 'Mudgala', 'Other'].contains(profileData['caste']) ? profileData['caste']
              : 'Other';
          _religion = ['Hindu', 'Muslim', 'Christian', 'Buddhism', 'Jewish', 'Other'].contains(profileData['religion']) ? profileData['religion']
              : 'Other';
          _gotra = ['Bharadwaj', 'Kashyap', 'Vashishtha', 'Vishwamitra', 'Gautam', 'Jamadagni', 'Atri', 'Agastya', 'Bhrigu', 'Angirasa', 'Parashar', 'Mudgala', 'Other'].contains(profileData['gotra']) ? profileData['gotra']
              : 'Bharadwaj';
          _height = profileData['height']?.toString() ?? '';
          _weight = profileData['weight']?.toString() ?? '';
          _zodiac = ['Mesha', 'Vrishabha', 'Mithuna', 'Karka', 'Simha', 'Kanya', 'Tula', 'Vrischika', 'Dhanu', 'Makara', 'Kumbha', 'Meena'].contains(profileData['zodiac']) ? profileData['zodiac']
              : 'Mesha';
          _education = profileData['education'] ?? '';
          _profession = profileData['profession'] ?? '';
          _familyType = ['Nuclear', 'Joint'].contains(profileData['family_type']) ? profileData['family_type']
              : 'Nuclear';
          _address = profileData['address'] ?? '';
          _complexion = profileData['complexion'] ?? '';
          _maritalStatus = ['Single', 'Divorce', 'Married'].contains(profileData['marital_status']) ? profileData['marital_status']
              : 'Single';
          _habitsDrinking = ['Alcoholic', 'Non-Alcoholic'].contains(profileData['habits_drinking']) ? profileData['habits_drinking']
              : 'Non-Alcoholic';
          _habitsEating = ['Veg', 'Non-Veg'].contains(profileData['habits_eating']) ? profileData['habits_eating']
              : 'Veg';
          _habitsSmoking = ['Smoker', 'Non-Smoker'].contains(profileData['habits_smoking']) ? profileData['habits_smoking']
              : 'Non-Smoker';
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
        'caste': _caste,
        'religion': _religion,
        'gotra': _gotra,
        'height': double.tryParse(_height) ?? 0.0,
        'weight': double.tryParse(_weight) ?? 0.0,
        'zodiac': _zodiac,
        'education': _education,
        'profession': _profession,
        'family_type': _familyType,
        'address': _address,
        'complexion': _complexion,
        'marital_status': _maritalStatus,
        'habits_drinking': _habitsDrinking,
        'habits_eating': _habitsEating,
        'habits_smoking': _habitsSmoking,
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
        Navigator.pushReplacementNamed(context, '/home', arguments: widget.username); // Go to Home Page
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
          'Complete Your Profile',
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
            child: Text('Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
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
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                onSaved: (value) => _name = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _phoneNumber,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                onSaved: (value) => _phoneNumber = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _age,
                decoration: InputDecoration(
                  labelText: 'Age',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                onSaved: (value) => _age = value!,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                items: ['Bharadwaj', 'Kashyap', 'Vashishtha', 'Vishwamitra', 'Gautam', 'Jamadagni', 'Atri', 'Agastya', 'Bhrigu', 'Angirasa', 'Parashar', 'Mudgala', 'Other']
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
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                items: ['Hindu', 'Muslim', 'Christian', 'Buddhism', 'Jewish', 'Other']
                    .map((religion) => DropdownMenuItem(
                  value: religion,
                  child: Text(religion, style: TextStyle(color: Colors.white)),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _religion = value ?? 'Other'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _gotra,
                decoration: InputDecoration(
                  labelText: 'Gotra',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                items: ['Bharadwaj', 'Kashyap', 'Vashishtha', 'Vishwamitra', 'Gautam', 'Jamadagni', 'Atri', 'Agastya', 'Bhrigu', 'Angirasa', 'Parashar', 'Mudgala', 'Other']
                    .map((gotra) => DropdownMenuItem(
                  value: gotra,
                  child: Text(gotra, style: TextStyle(color: Colors.white)),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _gotra = value ?? 'Bharadwaj'),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _height,
                decoration: InputDecoration(
                  labelText: 'Height (cm)',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                onSaved: (value) => _height = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _weight,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                onSaved: (value) => _weight = value!,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _zodiac,
                decoration: InputDecoration(
                  labelText: 'Zodiac',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                items: ['Mesha(Aries)', 'Vrish(Taurus)', 'Mithun(Gemini)', 'Karkat(Cancer)', 'Simha(Leo)', 'Kanya(Virgo)', 'Tula(Libra)', 'Vrischika(Scorpio)', 'Dhanu(Sagittarius)', 'Makara(Capricorn)', 'Kumbha(Aquarius)', 'Meen(Pisces)']
                    .map((zodiac) => DropdownMenuItem(
                  value: zodiac,
                  child: Text(zodiac, style: TextStyle(color: Colors.white)),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _zodiac = value ?? 'Mesha'),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _education,
                decoration: InputDecoration(
                  labelText: 'Education',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                maxLines: 3,
                onSaved: (value) => _education = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _profession,
                decoration: InputDecoration(
                  labelText: 'Profession',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                onSaved: (value) => _profession = value!,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _familyType,
                decoration: InputDecoration(
                  labelText: 'Family Type',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                items: ['Nuclear', 'Joint']
                    .map((familyType) => DropdownMenuItem(
                  value: familyType,
                  child: Text(familyType, style: TextStyle(color: Colors.white)),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _familyType = value ?? 'Nuclear'),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _address,
                decoration: InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                maxLines: 3,
                onSaved: (value) => _address = value!,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _complexion,
                decoration: InputDecoration(
                  labelText: 'Complexion',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                onSaved: (value) => _complexion = value!,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _maritalStatus,
                decoration: InputDecoration(
                  labelText: 'Marital Status',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                items: ['Single', 'Divorce', 'Married']
                    .map((maritalStatus) => DropdownMenuItem(
                  value: maritalStatus,
                  child: Text(maritalStatus, style: TextStyle(color: Colors.white)),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _maritalStatus = value ?? 'Single'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _habitsDrinking,
                decoration: InputDecoration(
                  labelText: 'Drinking Habits',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                items: ['Alcoholic', 'Non-Alcoholic']
                    .map((habitsDrinking) => DropdownMenuItem(
                  value: habitsDrinking,
                  child: Text(habitsDrinking, style: TextStyle(color: Colors.white)),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _habitsDrinking = value ?? 'Non-Alcoholic'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _habitsEating,
                decoration: InputDecoration(
                  labelText: 'Eating Habits',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                items: ['Veg', 'Non-Veg']
                    .map((habitsEating) => DropdownMenuItem(
                  value: habitsEating,
                  child: Text(habitsEating, style: TextStyle(color: Colors.white)),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _habitsEating = value ?? 'Veg'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _habitsSmoking,
                decoration: InputDecoration(
                  labelText: 'Smoking Habits',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
                items: ['Smoker', 'Non-Smoker']
                    .map((habitsSmoking) => DropdownMenuItem(
                  value: habitsSmoking,
                  child: Text(habitsSmoking, style: TextStyle(color: Colors.white)),
                ))
                    .toList(),
                onChanged: (value) => setState(() => _habitsSmoking = value ?? 'Non-Smoker'),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _bio,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
