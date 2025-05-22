// import 'package:flutter/material.dart';
//
// class WeightPreferencePage extends StatefulWidget {
//   final String username;
//
//   WeightPreferencePage({required this.username});
//
//   @override
//   _WeightPreferencePageState createState() => _WeightPreferencePageState();
// }
//
// class _WeightPreferencePageState extends State<WeightPreferencePage> {
//   double ageWeight = 5;
//   double religionWeight = 5;
//   double casteWeight = 5;
//   double gotraWeight = 5;
//   double heightWeight = 5;
//   double weightWeight = 5;
//
//
//   final List<String> attributes = [
//     'Age', 'Religion', 'Caste', 'Gotra', 'Height', 'Weight', 'Zodiac',
//     'Drinking Habit', 'Eating Habit', 'Smoking Habit'
//   ];
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
//           'Set Weights',
//           style: TextStyle(
//             fontFamily: 'CustomFont3',
//             fontSize: 32,
//             fontWeight: FontWeight.w700,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Color.fromRGBO(153, 0, 76, 1), // Dark Pink Color for AppBar
//         elevation: 6.0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)), // Rectangular corners for AppBar
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             ...attributes.map((attribute) {
//               double currentWeight = 5; // Default value
//               String label = attribute;
//
//               switch (attribute) {
//                 case 'Age': currentWeight = ageWeight; break;
//                 case 'Religion': currentWeight = religionWeight; break;
//                 case 'Caste': currentWeight = casteWeight; break;
//                 case 'Gotra': currentWeight = gotraWeight; break;
//                 case 'Height': currentWeight = heightWeight; break;
//                 case 'Weight': currentWeight = weightWeight; break;
//               }
//
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "$label Weight",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(153, 0, 76, 1)),
//                   ),
//                   Text("Weight: ${currentWeight.round()}", style: TextStyle(fontSize: 16)),
//                   Slider(
//                     value: currentWeight,
//                     min: 0,
//                     max: 10,
//                     divisions: 10,
//                     label: currentWeight.round().toString(),
//                     onChanged: (newValue) {
//                       setState(() {
//                         switch (label) {
//                           case 'Age': ageWeight = newValue; break;
//                           case 'Religion': religionWeight = newValue; break;
//                           case 'Caste': casteWeight = newValue; break;
//                           case 'Gotra': gotraWeight = newValue; break;
//                           case 'Height': heightWeight = newValue; break;
//                           case 'Weight': weightWeight = newValue; break;
//                         }
//                       });
//                     },
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               );
//             }).toList(),
//             SizedBox(height: 40),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Save preferences logic here (e.g., save to database or send to API)
//         },
//         child: Icon(Icons.save),
//         backgroundColor: Color.fromRGBO(153, 0, 76, 1), // Dark Pink color for button
//       ),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'api_service.dart';
import 'custom_snackbar.dart';

class WeightPreferencePage extends StatefulWidget {
  final String username;

  WeightPreferencePage({required this.username});

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


  final List<String> attributes = [
    'Age', 'Religion', 'Caste', 'Gotra', 'Height', 'Weight'
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
              String label = "$attribute Weight";

              switch (attribute) {
                case 'Age':
                  currentWeight = ageWeight;
                  break;
                case 'Religion':
                  currentWeight = religionWeight;
                  break;
                case 'Caste':
                  currentWeight = casteWeight;
                  break;
                case 'Gotra':
                  currentWeight = gotraWeight;
                  break;
                case 'Height':
                  currentWeight = heightWeight;
                  break;
                case 'Weight':
                  currentWeight = weightWeight;
                  break;
              }

              return Column(
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(153, 0, 76, 1)),
                  ),
                  Slider(
                    value: currentWeight,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    label: currentWeight.round().toString(),
                    onChanged: (double newValue) {
                      setState(() {
                        switch (attribute) {
                          case 'Age':
                            ageWeight = newValue;
                            break;
                          case 'Religion':
                            religionWeight = newValue;
                            break;
                          case 'Caste':
                            casteWeight = newValue;
                            break;
                          case 'Gotra':
                            gotraWeight = newValue;
                            break;
                          case 'Height':
                            heightWeight = newValue;
                            break;
                          case 'Weight':
                            weightWeight = newValue;
                            break;
                        }
                      });
                    },
                  ),
                  SizedBox(height: 15),
                ],
              );
            }).toList(),
            SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Prepare weights data to be sent
          Map<String, dynamic> weightsData = {
            'age_weight': ageWeight,
            'religion_weight': religionWeight,
            'caste_weight': casteWeight,
            'gotra_weight': gotraWeight,
            'height_weight': heightWeight,
            'weight_weight': weightWeight,
          };

          // Call saveWeights function from ApiService
          bool success = await ApiService().saveWeights(widget.username, weightsData);

          // Show feedback

          if (success) {
            CustomSnackbar.showSuccess(context, "Weights saved successfully!");
          } else {

            CustomSnackbar.showError(context,"Failed to save weights. Please try again.");
          }
        },
        child: Icon(Icons.save,color: Colors.white), // Icon for the FloatingActionButton
        backgroundColor: Color.fromRGBO(153, 0, 76, 1), // Color for the button
      ),
    );
  }
}
