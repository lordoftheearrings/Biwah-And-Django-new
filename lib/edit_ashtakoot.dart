// import 'package:flutter/material.dart';
// import 'ashtakoot_points.dart';
// import 'api_service.dart';
//
// class EditAshtakoot extends StatefulWidget {
//   @override
//   _EditAshtakootState createState() => _EditAshtakootState();
// }
//
// class _EditAshtakootState extends State<EditAshtakoot> {
//   final _formKey = GlobalKey<FormState>();
//   final boyDetails = <String, dynamic>{}; // Boy's details map
//   final girlDetails = <String, dynamic>{}; // Girl's details map
//
//   // API call to fetch points and navigate to AshtakootPointsPage
//   Future<void> _seePoints() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//
//       try {
//         // Use ApiService to calculate Ashtakoot points
//         final apiService = ApiService();
//         final data = await apiService.calculateAshtakootPoints(boyDetails, girlDetails);
//
//         if (data != null) {
//           // Navigate to Ashtakoot points page with the fetched data
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => AshtakootPoints(data: data),
//             ),
//           );
//         } else {
//           // Show error message if points couldn't be fetched
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('Error fetching points!')),
//           );
//         }
//       } catch (e) {
//         print('Error: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to fetch Ashtakoot points!')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () {
//             Navigator.pop(context); // Go back to the previous page
//           },
//         ),
//         title: Text(
//           'Ashtakoot Milan',
//           style: TextStyle(
//             fontFamily: 'CustomFont3',
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: Color.fromRGBO(153, 0, 76, 1), // Same as the card color
//         elevation: 5,
//         actions: [
//           ElevatedButton(
//             onPressed: _seePoints,
//             child: Text('See Points',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.black,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Color.fromRGBO(255, 182, 193, 1), // Button color
//
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Color.fromRGBO(68, 29, 47, 1.0),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 Text("Enter Boy's Details", style: TextStyle(fontFamily: 'CustomFont2',fontSize: 25, color: Colors.white)),
//                 ..._buildInputFields(boyDetails),
//                 SizedBox(height: 25),
//                 Text("Enter Girl's Details", style: TextStyle(fontFamily: 'CustomFont2',fontSize: 25, color: Colors.white)),
//                 ..._buildInputFields(girlDetails),
//                 SizedBox(height: 25),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Function to build input fields for both boy and girl
//   List<Widget> _buildInputFields(Map<String, dynamic> target) {
//     return [
//       TextFormField(
//         decoration: InputDecoration(
//           labelText: 'Name',
//           labelStyle: TextStyle(color: Colors.white),
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//         ),
//
//         style: TextStyle(color: Colors.white),
//
//         validator: (value) => value!.isEmpty ? 'Please enter Name' : null,
//       ),
//       TextFormField(
//         decoration: InputDecoration(
//           labelText: 'Year',
//           labelStyle: TextStyle(color: Colors.white),
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//         ),
//         keyboardType: TextInputType.number,
//         style: TextStyle(color: Colors.white),
//         onSaved: (value) => target['year'] = int.parse(value!),
//         validator: (value) => value!.isEmpty ? 'Please enter year' : null,
//       ),
//       TextFormField(
//         decoration: InputDecoration(
//           labelText: 'Month',
//           labelStyle: TextStyle(color: Colors.white),
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//         ),
//         keyboardType: TextInputType.number,
//         style: TextStyle(color: Colors.white),
//         onSaved: (value) => target['month'] = int.parse(value!),
//         validator: (value) => value!.isEmpty ? 'Please enter month' : null,
//       ),
//       TextFormField(
//         decoration: InputDecoration(
//           labelText: 'Day',
//           labelStyle: TextStyle(color: Colors.white),
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//         ),
//         keyboardType: TextInputType.number,
//         style: TextStyle(color: Colors.white),
//         onSaved: (value) => target['day'] = int.parse(value!),
//         validator: (value) => value!.isEmpty ? 'Please enter day' : null,
//       ),
//       TextFormField(
//         decoration: InputDecoration(
//           labelText: 'Hour (24-hour format)',
//           labelStyle: TextStyle(color: Colors.white),
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//         ),
//         keyboardType: TextInputType.number,
//         style: TextStyle(color: Colors.white),
//         onSaved: (value) => target['hour'] = int.parse(value!),
//         validator: (value) => value!.isEmpty ? 'Please enter hour' : null,
//       ),
//       TextFormField(
//         decoration: InputDecoration(
//           labelText: 'Minute',
//           labelStyle: TextStyle(color: Colors.white),
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//         ),
//         keyboardType: TextInputType.number,
//         style: TextStyle(color: Colors.white),
//         onSaved: (value) => target['minute'] = int.parse(value!),
//         validator: (value) => value!.isEmpty ? 'Please enter minute' : null,
//       ),
//       TextFormField(
//         decoration: InputDecoration(
//           labelText: 'Second',
//           labelStyle: TextStyle(color: Colors.white),
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//         ),
//         keyboardType: TextInputType.number,
//         style: TextStyle(color: Colors.white),
//         onSaved: (value) => target['second'] = int.parse(value!),
//         validator: (value) => value!.isEmpty ? 'Please enter second' : null,
//       ),
//       TextFormField(
//         decoration: InputDecoration(
//           labelText: 'Latitude',
//           labelStyle: TextStyle(color: Colors.white),
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//         ),
//         keyboardType: TextInputType.numberWithOptions(decimal: true),
//         style: TextStyle(color: Colors.white),
//         onSaved: (value) => target['latitude'] = double.parse(value!),
//         validator: (value) => value!.isEmpty ? 'Please enter latitude' : null,
//       ),
//       TextFormField(
//         decoration: InputDecoration(
//           labelText: 'Longitude',
//           labelStyle: TextStyle(color: Colors.white),
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//         ),
//         keyboardType: TextInputType.numberWithOptions(decimal: true),
//         style: TextStyle(color: Colors.white),
//         onSaved: (value) => target['longitude'] = double.parse(value!),
//         validator: (value) => value!.isEmpty ? 'Please enter longitude' : null,
//       ),
//       TextFormField(
//         decoration: InputDecoration(
//           labelText: 'Birth Location',
//           labelStyle: TextStyle(color: Colors.white),
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//         ),
//         style: TextStyle(color: Colors.white),
//         onSaved: (value) => target['birth_location'] = value!,
//         validator: (value) => value!.isEmpty ? 'Please enter location' : null,
//       ),
//     ];
//   }
// }
import 'package:flutter/material.dart';
import 'ashtakoot_points.dart'; // Assuming you want to navigate to this page to display the result
import 'api_service.dart'; // ApiService for calling the backend API

class EditAshtakoot extends StatefulWidget {
  @override
  _EditAshtakootState createState() => _EditAshtakootState();
}

class _EditAshtakootState extends State<EditAshtakoot> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> boyDetails = {};
  final Map<String, dynamic> girlDetails = {};

  @override
  void initState() {
    super.initState();
    // Set default values for both boy and girl
    boyDetails.addAll({
      'name': 'Default Boy',
      'year': 2000,
      'month': 1,
      'day': 1,
      'hour': 12,
      'minute': 0,
      'second': 0,
      'latitude': 28.6139,
      'longitude': 77.2090,
      'birth_location': 'Delhi'
    });

    girlDetails.addAll({
      'name': 'Default Girl',
      'year': 2000,
      'month': 1,
      'day': 1,
      'hour': 12,
      'minute': 0,
      'second': 0,
      'latitude': 19.0760,
      'longitude': 72.8777,
      'birth_location': 'Mumbai'
    });
  }

  Future<void> _seePoints() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final apiService = ApiService();
        final data = await apiService.calculateAshtakootPoints(boyDetails, girlDetails);

        if (data != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AshtakootPoints(data: data),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error fetching points!')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch Ashtakoot points!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Ashtakoot Milan',
          style: TextStyle(
            fontFamily: 'CustomFont3',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
        elevation: 5,
        actions: [
          ElevatedButton(
            onPressed: _seePoints,
            child: Text(
              'See Points',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(255, 182, 193, 1),
            ),
          ),
        ],
      ),
      backgroundColor: Color.fromRGBO(68, 29, 47, 1.0),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text("Enter Boy's Details", style: TextStyle(fontFamily: 'CustomFont2', fontSize: 25, color: Colors.white)),
                ..._buildInputFields(boyDetails),
                SizedBox(height: 25),
                Text("Enter Girl's Details", style: TextStyle(fontFamily: 'CustomFont2', fontSize: 25, color: Colors.white)),
                ..._buildInputFields(girlDetails),
                SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildInputFields(Map<String, dynamic> target) {
    return [
      TextFormField(
        initialValue: target['name'],
        decoration: _inputDecoration('Name'),
        style: TextStyle(color: Colors.white),
        validator: (value) => value!.isEmpty ? 'Please enter Name' : null,
      ),
      TextFormField(
        initialValue: target['year'].toString(),
        decoration: _inputDecoration('Year'),
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.white),
        onSaved: (value) => target['year'] = int.parse(value!),
        validator: (value) => value!.isEmpty ? 'Please enter year' : null,
      ),
      TextFormField(
        initialValue: target['month'].toString(),
        decoration: _inputDecoration('Month'),
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.white),
        onSaved: (value) => target['month'] = int.parse(value!),
        validator: (value) => value!.isEmpty ? 'Please enter month' : null,
      ),
      TextFormField(
        initialValue: target['day'].toString(),
        decoration: _inputDecoration('Day'),
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.white),
        onSaved: (value) => target['day'] = int.parse(value!),
        validator: (value) => value!.isEmpty ? 'Please enter day' : null,
      ),
      TextFormField(
        initialValue: target['hour'].toString(),
        decoration: _inputDecoration('Hour (24-hour format)'),
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.white),
        onSaved: (value) => target['hour'] = int.parse(value!),
        validator: (value) => value!.isEmpty ? 'Please enter hour' : null,
      ),
      TextFormField(
        initialValue: target['minute'].toString(),
        decoration: _inputDecoration('Minute'),
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.white),
        onSaved: (value) => target['minute'] = int.parse(value!),
        validator: (value) => value!.isEmpty ? 'Please enter minute' : null,
      ),
      TextFormField(
        initialValue: target['second'].toString(),
        decoration: _inputDecoration('Second'),
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.white),
        onSaved: (value) => target['second'] = int.parse(value!),
        validator: (value) => value!.isEmpty ? 'Please enter second' : null,
      ),
      TextFormField(
        initialValue: target['latitude'].toString(),
        decoration: _inputDecoration('Latitude'),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(color: Colors.white),
        onSaved: (value) => target['latitude'] = double.parse(value!),
        validator: (value) => value!.isEmpty ? 'Please enter latitude' : null,
      ),
      TextFormField(
        initialValue: target['longitude'].toString(),
        decoration: _inputDecoration('Longitude'),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(color: Colors.white),
        onSaved: (value) => target['longitude'] = double.parse(value!),
        validator: (value) => value!.isEmpty ? 'Please enter longitude' : null,
      ),
      TextFormField(
        initialValue: target['birth_location'],
        decoration: _inputDecoration('Birth Location'),
        style: TextStyle(color: Colors.white),
        onSaved: (value) => target['birth_location'] = value!,
        validator: (value) => value!.isEmpty ? 'Please enter location' : null,
      ),
    ];
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
    );
  }
}
