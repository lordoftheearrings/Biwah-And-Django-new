import 'package:flutter/material.dart';

class WeightPreferencePage extends StatefulWidget {
  @override
  _WeightPreferencePageState createState() => _WeightPreferencePageState();
}

class _WeightPreferencePageState extends State<WeightPreferencePage> {
  double ageWeight = 5;
  double religionWeight = 5;
  double casteWeight = 5;
  double gotraWeight = 5;
  double heightWeight = 5;
  double weightWeight = 5;
  double zodiacWeight = 5;
  double drinkingHabitWeight = 5;
  double eatingHabitWeight = 5;
  double smokingHabitWeight = 5;

  final List<String> attributes = [
    'Age', 'Religion', 'Caste', 'Gotra', 'Height', 'Weight', 'Zodiac',
    'Drinking Habit', 'Eating Habit', 'Smoking Habit'
  ];

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
          'Set Weights',
          style: TextStyle(
            fontFamily: 'CustomFont3',
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1), // Dark Pink Color for AppBar
        elevation: 6.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)), // Rectangular corners for AppBar
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ...attributes.map((attribute) {
              double currentWeight = 5; // Default value
              String label = attribute;

              switch (attribute) {
                case 'Age': currentWeight = ageWeight; break;
                case 'Religion': currentWeight = religionWeight; break;
                case 'Caste': currentWeight = casteWeight; break;
                case 'Gotra': currentWeight = gotraWeight; break;
                case 'Height': currentWeight = heightWeight; break;
                case 'Weight': currentWeight = weightWeight; break;
                case 'Zodiac': currentWeight = zodiacWeight; break;
                case 'Drinking Habit': currentWeight = drinkingHabitWeight; break;
                case 'Eating Habit': currentWeight = eatingHabitWeight; break;
                case 'Smoking Habit': currentWeight = smokingHabitWeight; break;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$label Weight",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(153, 0, 76, 1)),
                  ),
                  Text("Weight: ${currentWeight.round()}", style: TextStyle(fontSize: 16)),
                  Slider(
                    value: currentWeight,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: currentWeight.round().toString(),
                    onChanged: (newValue) {
                      setState(() {
                        switch (label) {
                          case 'Age': ageWeight = newValue; break;
                          case 'Religion': religionWeight = newValue; break;
                          case 'Caste': casteWeight = newValue; break;
                          case 'Gotra': gotraWeight = newValue; break;
                          case 'Height': heightWeight = newValue; break;
                          case 'Weight': weightWeight = newValue; break;
                          case 'Zodiac': zodiacWeight = newValue; break;
                          case 'Drinking Habit': drinkingHabitWeight = newValue; break;
                          case 'Eating Habit': eatingHabitWeight = newValue; break;
                          case 'Smoking Habit': smokingHabitWeight = newValue; break;
                        }
                      });
                    },
                  ),
                  SizedBox(height: 20),
                ],
              );
            }).toList(),
            SizedBox(height: 40),
            // Save Weights Button
            ElevatedButton(
              onPressed: () {
                // Save preferences logic here (e.g., save to database or send to API)
              },
              child: Text(
                "Save Preferences",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(153, 0, 76, 1), // Dark Pink color for button
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}