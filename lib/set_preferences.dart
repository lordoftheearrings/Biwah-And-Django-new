// import 'package:flutter/material.dart';
// import 'weight_preference.dart'; // Importing weight preference page
//
// class SetPreferencePage extends StatefulWidget {
//
//   final String username;
//
//   SetPreferencePage({required this.username});
//
//   @override
//   _SetPreferencePageState createState() => _SetPreferencePageState();
// }
//
// class _SetPreferencePageState extends State<SetPreferencePage> {
//   // Selected values for dropdowns
//   String selectedReligion = 'Hindu'; // Default value as in profileData
//   String selectedCaste = 'Bahun';   // Default value as in profileData
//   String selectedGotra = 'Bharadwaj'; // Default value as in profileData
//   String selectedZodiac = 'Mesha';  // Default value as in profileData
//   String drinkingHabit = 'Non-Alcoholic'; // Default value as in profileData
//   String smokingHabit = 'Non-Smoker'; // Default value as in profileData
//   String eatingHabit = 'Veg';  // Default value as in profileData
//
// // Range sliders
//   RangeValues ageRange = RangeValues(18, 60); // Default range
//   RangeValues heightRange = RangeValues(140, 200); // Default range
//   RangeValues weightRange = RangeValues(30, 150); // Default range
//
// // Dropdown lists
//   final List<String> religions = ['Hindu', 'Islam', 'Christian', 'Buddhist', 'Jain', 'Kiranti'];
//   final List<String> castes = [
//     'Bahun', 'Chhetri', 'Thakuri', 'Magar', 'Tharu', 'Tamang', 'Newar', 'Rai',
//     'Gurung', 'Limbu', 'Sherpa', 'Yadav', 'Kami', 'Damai', 'Sarki'
//   ];
//   final List<String> gotras = [
//     'Bharadwaj', 'Kashyap', 'Vashishtha', 'Vishwamitra', 'Gautam', 'Jamadagni',
//     'Atri', 'Agastya', 'Bhrigu', 'Angirasa', 'Parashar', 'Mudgala'
//   ];
//   final List<String> zodiacs = [
//     'Mesha', 'Vrishabha', 'Mithuna', 'Karka', 'Simha', 'Kanya', 'Tula', 'Vrischika',
//     'Dhanu', 'Makara', 'Kumbha', 'Meena'
//   ];
//   final List<String> habits = ['Alcoholic', 'Non-Alcoholic']; // For drinking habits
//   final List<String> smokingHabits = ['Smoker', 'Non-Smoker']; // For smoking habits
//   final List<String> eatingHabits = ['Veg', 'Non-Veg']; // For eating habits
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(  // Add back button
//           icon: Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context);  // Go back to previous page
//           },
//         ),
//         title: Text(
//           'Set Preferences',
//           style: TextStyle(
//             fontFamily: 'CustomFont3',
//             fontSize: 32,
//             fontWeight: FontWeight.w700,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Color.fromRGBO(153, 0, 76, 1),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.tune, color: Colors.white), // Weight preferences button
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => WeightPreferencePage(username: widget.username,)),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView(
//                 children: [
//                   buildRangeSlider("Preferred Age Range", ageRange, 18, 60, (RangeValues newRange) {
//                     setState(() {
//                       ageRange = newRange;
//                     });
//                   }),
//
//                   buildDropdown("Religion", selectedReligion, religions, (newValue) {
//                     setState(() {
//                       selectedReligion = newValue!;
//                     });
//                   }),
//
//                   buildDropdown("Caste", selectedCaste, castes, (newValue) {
//                     setState(() {
//                       selectedCaste = newValue!;
//                     });
//                   }),
//
//                   buildDropdown("Gotra", selectedGotra, gotras, (newValue) {
//                     setState(() {
//                       selectedGotra = newValue!;
//                     });
//                   }),
//
//                   buildRangeSlider("Preferred Height (cm)", heightRange, 140, 200, (RangeValues newRange) {
//                     setState(() {
//                       heightRange = newRange;
//                     });
//                   }),
//
//                   buildRangeSlider("Preferred Weight (kg)", weightRange, 30, 150, (RangeValues newRange) {
//                     setState(() {
//                       weightRange = newRange;
//                     });
//                   }),
//
//                   buildDropdown("Zodiac", selectedZodiac, zodiacs, (newValue) {
//                     setState(() {
//                       selectedZodiac = newValue!;
//                     });
//                   }),
//
//                   buildDropdown("Drinking Habit", drinkingHabit, habits, (newValue) {
//                     setState(() {
//                       drinkingHabit = newValue!;
//                     });
//                   }),
//
//                   buildDropdown("Smoking Habit", smokingHabit, habits, (newValue) {
//                     setState(() {
//                       smokingHabit = newValue!;
//                     });
//                   }),
//
//                   buildDropdown("Eating Habit", eatingHabit, habits, (newValue) {
//                     setState(() {
//                       eatingHabit = newValue!;
//                     });
//                   }),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//
//       // Floating Action Button for Save Preferences
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Handle save logic here
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Preferences saved successfully!")),
//           );
//         },
//         child: Icon(Icons.save),
//         backgroundColor: Color.fromRGBO(153, 0, 76, 1),
//       ),
//     );
//   }
//
//   // Function to build dropdowns
//   Widget buildDropdown(String label, String selectedValue, List<String> options, ValueChanged<String?> onChanged) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(153, 0, 76, 1)),
//         ),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             border: Border.all(color: Color.fromRGBO(153, 0, 76, 1)),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: selectedValue,
//               isExpanded: true,
//               onChanged: onChanged,
//               icon: Icon(Icons.arrow_drop_down, color: Colors.black), // Arrow aligned right
//               items: options.map((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//               style: TextStyle(fontSize: 16, color: Colors.black),
//             ),
//           ),
//         ),
//         SizedBox(height: 15),
//       ],
//     );
//   }
//
//   // Function to build range sliders
//   Widget buildRangeSlider(String label, RangeValues values, double min, double max, ValueChanged<RangeValues> onChanged) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(153, 0, 76, 1)),
//         ),
//         Text("${values.start.round()} - ${values.end.round()}", style: TextStyle(fontSize: 16)),
//         RangeSlider(
//           values: values,
//           min: min,
//           max: max,
//           divisions: (max - min).toInt(),
//           labels: RangeLabels(
//             '${values.start.round()}',
//             '${values.end.round()}',
//           ),
//           onChanged: onChanged,
//         ),
//         SizedBox(height: 15),
//       ],
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'api_service.dart'; // Importing the ApiService
import 'weight_preference.dart'; // Importing weight preference page

class SetPreferencePage extends StatefulWidget {
  final String username;

  SetPreferencePage({required this.username});

  @override
  _SetPreferencePageState createState() => _SetPreferencePageState();
}

class _SetPreferencePageState extends State<SetPreferencePage> {
  // Selected values for dropdowns
  String selectedReligion = 'Hindu'; // Default value as in profileData
  String selectedCaste = 'Bahun';   // Default value as in profileData
  String selectedGotra = 'Bharadwaj'; // Default value as in profileData
  String selectedZodiac = 'Mesha';  // Default value as in profileData
  String drinkingHabit = 'Non-Alcoholic'; // Default value as in profileData
  String smokingHabit = 'Non-Smoker'; // Default value as in profileData
  String eatingHabit = 'Veg';  // Default value as in profileData

  // Range sliders
  RangeValues ageRange = RangeValues(18, 60); // Default range
  RangeValues heightRange = RangeValues(140, 200); // Default range
  RangeValues weightRange = RangeValues(30, 150); // Default range

  // Dropdown lists
  final List<String> religions = ['Hindu', 'Islam', 'Christian', 'Buddhist', 'Jain', 'Kiranti'];
  final List<String> castes = [
    'Bahun', 'Chhetri', 'Thakuri', 'Magar', 'Tharu', 'Tamang', 'Newar', 'Rai',
    'Gurung', 'Limbu', 'Sherpa', 'Yadav', 'Kami', 'Damai', 'Sarki'
  ];
  final List<String> gotras = [
    'Bharadwaj', 'Kashyap', 'Vashishtha', 'Vishwamitra', 'Gautam', 'Jamadagni',
    'Atri', 'Agastya', 'Bhrigu', 'Angirasa', 'Parashar', 'Mudgala'
  ];
  final List<String> zodiacs = [
    'Mesha', 'Vrishabha', 'Mithuna', 'Karka', 'Simha', 'Kanya', 'Tula', 'Vrischika',
    'Dhanu', 'Makara', 'Kumbha', 'Meena'
  ];
  final List<String> drinkingHabits = ['Alcoholic', 'Non-Alcoholic']; // For drinking habits
  final List<String> smokingHabits = ['Smoker', 'Non-Smoker']; // For smoking habits
  final List<String> eatingHabits = ['Veg', 'Non-Veg']; // For eating habits

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(  // Add back button
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);  // Go back to previous page
          },
        ),
        title: Text(
          'Set Preferences',
          style: TextStyle(
            fontFamily: 'CustomFont3',
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
        actions: [
          IconButton(
            icon: Icon(Icons.tune, color: Colors.white), // Weight preferences button
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WeightPreferencePage(username: widget.username)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  buildRangeSlider("Preferred Age Range", ageRange, 18, 60, (RangeValues newRange) {
                    setState(() {
                      ageRange = newRange;
                    });
                  }),

                  buildDropdown("Religion", selectedReligion, religions, (newValue) {
                    setState(() {
                      selectedReligion = newValue!;
                    });
                  }),

                  buildDropdown("Caste", selectedCaste, castes, (newValue) {
                    setState(() {
                      selectedCaste = newValue!;
                    });
                  }),

                  buildDropdown("Gotra", selectedGotra, gotras, (newValue) {
                    setState(() {
                      selectedGotra = newValue!;
                    });
                  }),

                  buildRangeSlider("Preferred Height (cm)", heightRange, 140, 200, (RangeValues newRange) {
                    setState(() {
                      heightRange = newRange;
                    });
                  }),

                  buildRangeSlider("Preferred Weight (kg)", weightRange, 30, 150, (RangeValues newRange) {
                    setState(() {
                      weightRange = newRange;
                    });
                  }),

                  buildDropdown("Zodiac", selectedZodiac, zodiacs, (newValue) {
                    setState(() {
                      selectedZodiac = newValue!;
                    });
                  }),

                  buildDropdown("Drinking Habit", drinkingHabit, drinkingHabits, (newValue) {
                    setState(() {
                      drinkingHabit = newValue!;
                    });
                  }),

                  buildDropdown("Smoking Habit", smokingHabit, smokingHabits, (newValue) {
                    setState(() {
                      smokingHabit = newValue!;
                    });
                  }),

                  buildDropdown("Eating Habit", eatingHabit, eatingHabits, (newValue) {
                    setState(() {
                      eatingHabit = newValue!;
                    });
                  }),
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button for Save Preferences
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Prepare preferences data to be sent
          Map<String, dynamic> preferencesData = {
            'age_range': {'min': ageRange.start, 'max': ageRange.end},
            'religion': selectedReligion,
            'caste': selectedCaste,
            'gotra': selectedGotra,
            'height_range': {'min': heightRange.start, 'max': heightRange.end},
            'weight_range': {'min': weightRange.start, 'max': weightRange.end},
            'zodiac': selectedZodiac,
            'drinking_habit': drinkingHabit,
            'smoking_habit': smokingHabit,
            'eating_habit': eatingHabit,
          };

          // Call savePreferences function from ApiService
          bool success = await ApiService().savePreferences(widget.username, preferencesData);

          // Show feedback
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Preferences saved successfully!")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Failed to save preferences. Please try again.")),
            );
          }
        },
        child: Icon(Icons.save,color: Colors.white,),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
      ),
    );
  }

  // Function to build dropdowns
  Widget buildDropdown(String label, String selectedValue, List<String> options, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(153, 0, 76, 1)),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromRGBO(153, 0, 76, 1)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              onChanged: onChanged,
              icon: Icon(Icons.arrow_drop_down, color: Colors.black),
              items: options.map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  // Function to build range sliders
  Widget buildRangeSlider(String label, RangeValues values, double min, double max, ValueChanged<RangeValues> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(153, 0, 76, 1)),
        ),
        Text("${values.start.round()} - ${values.end.round()}", style: TextStyle(fontSize: 16)),
        RangeSlider(
          values: values,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          labels: RangeLabels(
            '${values.start.round()}',
            '${values.end.round()}',
          ),
          onChanged: onChanged,
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
