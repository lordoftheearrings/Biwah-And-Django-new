import 'package:flutter/material.dart';
import 'api_service.dart';

class EditKundaliInfoPage extends StatefulWidget {
  final String username;
  final Map<String, dynamic>? kundaliInfo;

  const EditKundaliInfoPage({
    Key? key,
    required this.username,
    this.kundaliInfo,
  }) : super(key: key);

  @override
  _EditKundaliInfoPageState createState() => _EditKundaliInfoPageState();
}

class _EditKundaliInfoPageState extends State<EditKundaliInfoPage> {
  final ApiService apiService = ApiService();
  final yearController = TextEditingController();
  final monthController = TextEditingController();
  final dayController = TextEditingController();
  final hourController = TextEditingController();
  final minuteController = TextEditingController();
  final secondController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final birthLocationController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.kundaliInfo != null) {
      yearController.text = widget.kundaliInfo?['year']?.toString() ?? '';
      monthController.text = widget.kundaliInfo?['month']?.toString() ?? '';
      dayController.text = widget.kundaliInfo?['day']?.toString() ?? '';
      hourController.text = widget.kundaliInfo?['hour']?.toString() ?? '';
      minuteController.text = widget.kundaliInfo?['minute']?.toString() ?? '';
      secondController.text = widget.kundaliInfo?['second']?.toString() ?? '';
      latitudeController.text = widget.kundaliInfo?['latitude']?.toString() ?? '';
      longitudeController.text = widget.kundaliInfo?['longitude']?.toString() ?? '';
      birthLocationController.text = widget.kundaliInfo?['birthLocation'] ?? '';
    }
  }

  @override
  void dispose() {
    yearController.dispose();
    monthController.dispose();
    dayController.dispose();
    hourController.dispose();
    minuteController.dispose();
    secondController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    birthLocationController.dispose();
    super.dispose();
  }

  Future<void> saveKundaliInfo() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await apiService.generateKundali(
        username: widget.username,
        year: _parseInt(yearController.text),
        month: _parseInt(monthController.text),
        day: _parseInt(dayController.text),
        hour: _parseInt(hourController.text),
        minute: _parseInt(minuteController.text),
        second: _parseInt(secondController.text),
        latitude: _parseDouble(latitudeController.text),
        longitude: _parseDouble(longitudeController.text),
        birthLocation: birthLocationController.text,
      );

      if (response != null) {
        // Pop the current screen and return
        Navigator.pop(context);
      } else {
        _showErrorDialog("Failed to generate Kundali.");
      }
    } catch (e) {
      _showErrorDialog("Error saving Kundali info: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  int _parseInt(String text) {
    return text.isEmpty ? 0 : int.tryParse(text) ?? 0;
  }

  double _parseDouble(String text) {
    return text.isEmpty ? 0.0 : double.tryParse(text) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(68, 29, 47, 1.0),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Edit Kundali Info',
          style: TextStyle(
            fontFamily: 'CustomFont3',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
        elevation: 5,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 5),
            buildTextField('Year of Birth', yearController),
            SizedBox(height: 16),
            buildTextField('Month of Birth', monthController),
            SizedBox(height: 16),
            buildTextField('Day of Birth', dayController),
            SizedBox(height: 16),
            buildTextField('Hour of Birth', hourController),
            SizedBox(height: 16),
            buildTextField('Minute of Birth', minuteController),
            SizedBox(height: 16),
            buildTextField('Second of Birth', secondController),
            SizedBox(height: 16),
            buildTextField('Latitude', latitudeController),
            SizedBox(height: 16),
            buildTextField('Longitude', longitudeController),
            SizedBox(height: 16),
            buildTextField('Birth Location', birthLocationController, keyboardType: TextInputType.text),
            SizedBox(height: 32),
            Center(
              child: SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: saveKundaliInfo,
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(255, 182, 193, 1),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.number}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
    );
  }
}
