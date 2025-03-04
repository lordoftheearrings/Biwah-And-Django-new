import 'package:flutter/material.dart';
import 'dart:ui';
import 'api_service.dart';
import 'view_user.dart';

class SearchPage extends StatefulWidget {

  final String username; // Add a username parameter

  SearchPage({required this.username});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  String _selectedGender = 'Any';
  String _selectedReligion = 'Any';
  String _selectedCaste = 'Any';
  String _selectedGotra = 'Any';
  RangeValues _ageRange = RangeValues(18, 30);

  final ApiService _apiService = ApiService();

  final List<String> _genders = ['Any', 'Male', 'Female', 'Other'];
  final List<String> _religions = ['Any', 'Hindu', 'Buddhist', 'Islam', 'Christian', 'Jain', 'Kiranti'];
  final List<String> _castes = ['Any', 'Bahun', 'Chhetri', 'Thakuri', 'Magar', 'Tharu', 'Tamang', 'Newar', 'Rai', 'Gurung', 'Limbu', 'Sherpa', 'Yadav', 'Kami', 'Damai', 'Sarki'];
  final List<String> _gotras = ['Any', 'Bharadwaj', 'Kashyap', 'Vashishtha', 'Vishwamitra', 'Gautam', 'Jamadagni', 'Atri', 'Agastya', 'Bhrigu', 'Angirasa', 'Parashar', 'Mudgala'];

  void _search() async {
    try {
      final data = await _apiService.searchUsers(
        searchTerm: _searchController.text,
        ageMin: _ageRange.start.round(),
        ageMax: _ageRange.end.round(),
        gender: _selectedGender,
        religion: _selectedReligion,
        caste: _selectedCaste,
        gotra: _selectedGotra,
      );
      print('API Response: $data'); // Debug API response
      setState(() {
        _searchResults = data['users'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching search results', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      );
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Color.fromRGBO(153, 0, 76, 1),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Filter By:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  _buildDropdownRow('Gender:', _selectedGender, _genders, (newValue) => setState(() => _selectedGender = newValue!)),
                  _buildDropdownRow('Religion:', _selectedReligion, _religions, (newValue) => setState(() => _selectedReligion = newValue!)),
                  _buildDropdownRow('Caste:', _selectedCaste, _castes, (newValue) => setState(() => _selectedCaste = newValue!)),
                  _buildDropdownRow('Gotra:', _selectedGotra, _gotras, (newValue) => setState(() => _selectedGotra = newValue!)),
                  SizedBox(height: 16),
                  Text('Age Group:', style: TextStyle(fontSize: 16, color: Colors.white)),
                  RangeSlider(
                    values: _ageRange,
                    min: 18,
                    max: 100,
                    divisions: 82,
                    labels: RangeLabels(
                      _ageRange.start.round().toString(),
                      _ageRange.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        _ageRange = values;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: _search,
                      child: Text('Apply Filters', style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(255, 182, 193, 1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDropdownRow(String label, String selectedValue, List<String> values, ValueChanged<String?> onChanged) {
    return Row(
      children: [
        Expanded(flex: 2, child: Text(label, style: TextStyle(fontSize: 16, color: Colors.white))),
        Expanded(
          flex: 3,
          child: DropdownButton<String>(
            value: selectedValue,
            onChanged: onChanged,
            items: values.map((value) => DropdownMenuItem(value: value, child: Text(value, style: TextStyle(color: Colors.white)))).toList(),
            isExpanded: true,
            underline: Container(),
            dropdownColor: Colors.black,
          ),
        ),
      ],
    );
  }

  void _navigateToViewUserPage(dynamic user) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ViewUser(username: user['username'],currentUsername: widget.username,)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(color: Colors.black),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bridegroom2.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.srcOver,
                ),
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(icon: Icon(Icons.search, color: Colors.black), onPressed: _search),
                                IconButton(icon: Icon(Icons.filter_list, color: Colors.black), onPressed: () => _showFilterBottomSheet(context)),
                              ],
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.85),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final user = _searchResults[index];
                      return FutureBuilder<Map<String, dynamic>?>(
                        future: _apiService.loadProfile(user['username']),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return ListTile(
                              title: Text('Loading...', style: TextStyle(color: Colors.white)),
                            );
                          }

                          if (snapshot.hasError || !snapshot.hasData) {
                            return ListTile(
                              title: Text('Error loading profile', style: TextStyle(color: Colors.white)),
                            );
                          }

                          final profileData = snapshot.data!;
                          final name = profileData['name'] ?? 'N/A';
                          final profileImage = profileData['profile_image'] ?? '';
                          final username = profileData['username'] ?? 'N/A';

                          return Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: profileImage.isNotEmpty ? NetworkImage(profileImage) : null,
                                ),
                                title: Text(name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                subtitle: Text(username, style: TextStyle(color: Colors.white)),
                                onTap: () => _navigateToViewUserPage(user),
                              ),
                              Divider(color: Colors.white.withOpacity(0.5)),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
