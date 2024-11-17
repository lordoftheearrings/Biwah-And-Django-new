import 'package:flutter/material.dart';
import 'dart:ui';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  String _selectedGender = 'Any';
  String _selectedAgeGroup = 'Any';
  String _selectedReligion = 'Any';
  String _selectedCaste = 'Any';
  String _selectedEducationalLevel = 'Any';
  String _selectedProfession = 'Any';

  final List<String> _genders = ['Any', 'Male', 'Female', 'Other'];
  final List<String> _ageGroups = ['Any', '18-25', '26-35', '36-45', '46+'];
  final List<String> _religions = ['Any', 'Christianity', 'Islam', 'Hinduism', 'Buddhism', 'Other'];
  final List<String> _castes = ['Any', 'Brahmin', 'Kshatriya', 'Vaishya', 'Shudra', 'Other'];
  final List<String> _educationalLevels = ['Any', 'High School', 'Undergraduate', 'Graduate', 'Postgraduate'];
  final List<String> _professions = ['Any', 'Engineer', 'Doctor', 'Teacher', 'Lawyer', 'Other'];

  void _search() {
    if (_searchController.text.isNotEmpty) {
      // Perform the search
      setState(() {
        _searchResults = List.generate(10, (index) {
          return 'Result $index for "${_searchController.text}" (Gender: $_selectedGender, Age Group: $_selectedAgeGroup, Religion: $_selectedReligion, Caste: $_selectedCaste, Educational Level: $_selectedEducationalLevel, Profession: $_selectedProfession)';
        });
      });
      Navigator.pop(context); // Close the bottom sheet after searching
    } else {
      // Show an error message or do nothing if the search field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a search query'),
        ),
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
                color: Color.fromRGBO(153, 0, 76, 1), // Background color of the bottom sheet
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Filter By:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'CustomFont2')),
                  SizedBox(height: 16),
                  _buildDropdownRow('Gender:', _selectedGender, _genders, (newValue) {
                    setState(() {
                      _selectedGender = newValue!;
                    });
                  }),
                  _buildDropdownRow('Age Group:', _selectedAgeGroup, _ageGroups, (newValue) {
                    setState(() {
                      _selectedAgeGroup = newValue!;
                    });
                  }),
                  _buildDropdownRow('Religion:', _selectedReligion, _religions, (newValue) {
                    setState(() {
                      _selectedReligion = newValue!;
                    });
                  }),
                  _buildDropdownRow('Caste:', _selectedCaste, _castes, (newValue) {
                    setState(() {
                      _selectedCaste = newValue!;
                    });
                  }),
                  _buildDropdownRow('Educational Level:', _selectedEducationalLevel, _educationalLevels, (newValue) {
                    setState(() {
                      _selectedEducationalLevel = newValue!;
                    });
                  }),
                  _buildDropdownRow('Profession:', _selectedProfession, _professions, (newValue) {
                    setState(() {
                      _selectedProfession = newValue!;
                    });
                  }),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: _search,
                      child: Text('Apply Filters', style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(255, 182, 193, 1), // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
          Expanded(
            flex: 3,
            child: DropdownButton<String>(
              value: selectedValue,
              onChanged: (String? newValue) {
                onChanged(newValue);
                // Ensure the dropdown reflects the change immediately
                setState(() {});
              },
              items: values.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              isExpanded: true,
              underline: Container(), // Remove the underline
              style: TextStyle(color: Colors.black), // Dropdown text color
              dropdownColor: Colors.white, // Dropdown menu background color
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Black background container
          Container(
            color: Colors.black, // Fully black background
          ),
          // PNG image with color filter
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bridegroom2.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), // Darker color overlay
                  BlendMode.srcOver, // Use srcOver mode to overlay black color
                ),
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                color: Colors.black.withOpacity(0.4), // Darker overlay
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(fontFamily: 'CustomFont2'),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.search, color: Colors.black),
                                  onPressed: _search,
                                ),
                                IconButton(
                                  icon: Icon(Icons.filter_list, color: Colors.black),
                                  onPressed: () => _showFilterBottomSheet(context),
                                ),
                              ],
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.85),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
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
                      return ListTile(
                        title: Text(_searchResults[index]),
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

void main() => runApp(MaterialApp(
  home: SearchPage(),
));
