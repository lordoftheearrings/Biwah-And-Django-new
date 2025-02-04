import 'package:flutter/material.dart';
import 'weight_preference.dart'; // Importing weight preference page

class SetPreferencePage extends StatefulWidget {
  @override
  _SetPreferencePageState createState() => _SetPreferencePageState();
}

class _SetPreferencePageState extends State<SetPreferencePage> {
  // Selected values for dropdowns
  String selectedReligion = 'Any';
  String selectedCaste = 'Any';
  String selectedGotra = 'Any';
  String selectedZodiac = 'Any';
  String drinkingHabit = 'Any';
  String smokingHabit = 'Any';
  String eatingHabit = 'Any';

  // Range sliders
  RangeValues ageRange = RangeValues(18, 60);
  RangeValues heightRange = RangeValues(140, 200);
  RangeValues weightRange = RangeValues(30, 150);

  // Dropdown lists
  final List<String> religions = ['Any', 'Hindu', 'Buddhist', 'Christian', 'Muslim'];
  final List<String> castes = [
    'Any', 'Bahun', 'Chhetri', 'Thakuri', 'Magar', 'Tharu', 'Tamang', 'Newar',
    'Rai', 'Gurung', 'Limbu', 'Sherpa', 'Yadav', 'Kami', 'Damai', 'Sarki'
  ];
  final List<String> gotras = [
    'Any', 'Bharadwaj', 'Kashyap', 'Vashishtha', 'Vishwamitra', 'Gautam', 'Jamadagni',
    'Atri', 'Agastya', 'Bhrigu', 'Angirasa', 'Parashar', 'Mudgala'
  ];
  final List<String> zodiacs = [
    'Any', 'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo', 'Libra', 'Scorpio',
    'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
  ];
  final List<String> habits = ['Any', 'Yes', 'No'];

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
                MaterialPageRoute(builder: (context) => WeightPreferencePage()),
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

                  buildDropdown("Drinking Habit", drinkingHabit, habits, (newValue) {
                    setState(() {
                      drinkingHabit = newValue!;
                    });
                  }),

                  buildDropdown("Smoking Habit", smokingHabit, habits, (newValue) {
                    setState(() {
                      smokingHabit = newValue!;
                    });
                  }),

                  buildDropdown("Eating Habit", eatingHabit, habits, (newValue) {
                    setState(() {
                      eatingHabit = newValue!;
                    });
                  }),
                ],
              ),
            ),

            // Save Preferences Button (Fixed at bottom)
            ElevatedButton(
              onPressed: () {
                // Handle save logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Preferences saved successfully!")),
                );
              },
              child: Text(
                "Save Preferences",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(153, 0, 76, 1),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
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
              icon: Icon(Icons.arrow_drop_down, color: Colors.black), // Arrow aligned right
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
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