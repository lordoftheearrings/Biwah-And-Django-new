import 'package:flutter/material.dart';

class AshtakootPoints extends StatelessWidget {
  final Map<String, dynamic> data;

  AshtakootPoints({required this.data});

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
          'Milan Points',
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
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ashtakoot Guna Milan Points:',
                  style: TextStyle(fontFamily: 'CustomFont2',fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 10),
                Card(
                  color: Color.fromRGBO(153, 0, 76, 1),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _buildGunaMilanTable(data),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Importance of Guna Milan:',
                  style: TextStyle(fontFamily: 'CustomFont2',fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 10),
                Card(
                  color: Color.fromRGBO(153, 0, 76, 1),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildImportanceTable(),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Descriptions of Gunas:',
                  style: TextStyle(fontFamily: 'CustomFont2',fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 10),
                _buildGunaDescriptions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGunaMilanTable(Map<String, dynamic> data) {
    return Table(
      border: TableBorder.all(color: Colors.white),
      defaultColumnWidth: FixedColumnWidth(112.0),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.9)),
          children: [
            _buildTableCell('Guna', isHeader: true, textColor: Colors.black),
            _buildTableCell('Max Points', isHeader: true, textColor: Colors.black),
            _buildTableCell('Obtained', isHeader: true, textColor: Colors.black),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell('Varna'),
            _buildTableCell('1'),
            _buildTableCell(data['varna'].toString()),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell('Vasya'),
            _buildTableCell('2'),
            _buildTableCell(data['vasya'].toString()),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell('Tara'),
            _buildTableCell('3'),
            _buildTableCell(data['tara'].toString()),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell('Yoni'),
            _buildTableCell('4'),
            _buildTableCell(data['yoni'].toString()),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell('Graha Maitri'),
            _buildTableCell('5'),
            _buildTableCell(data['grah'].toString()),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell('Gana'),
            _buildTableCell('6'),
            _buildTableCell(data['gana'].toString()),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell('Bhakoot'),
            _buildTableCell('7'),
            _buildTableCell(data['bhakoot'].toString()),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell('Nadi'),
            _buildTableCell('8'),
            _buildTableCell(data['nadi'].toString()),
          ],
        ),
        TableRow(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.9)),
          children: [
            _buildTableCell('Total', isHeader: true, textColor: Colors.black),
            _buildTableCell('36', isHeader: true, textColor: Colors.black),
            _buildTableCell(data['total'].toString(), isHeader: true, textColor: Colors.black),
          ],
        ),
      ],
    );
  }

  Widget _buildImportanceTable() {
    return Table(
      border: TableBorder.all(color: Colors.white),
      defaultColumnWidth: FixedColumnWidth(169),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.9)),
          children: [
            _buildTableCell('Obtained Guna Points', isHeader: true, textColor: Colors.black),
            _buildTableCell('Prediction', isHeader: true, textColor: Colors.black),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell('Less than 18'),
            _buildTableCell('Not recommended for marriage'),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell('18 to 24'),
            _buildTableCell('Average, Acceptable match and recommended for marriage'),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell('24 to 32'),
            _buildTableCell('Very Good, successful marriage'),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell('32 to 36'),
            _buildTableCell('Excellent Match'),
          ],
        ),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false, Color textColor = Colors.white}) {
    return Container(
      padding: EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildGunaDescriptions() {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildDescriptionItem('Varna/Varan/Jaati', '   Spiritual compatibility and ego levels.'),
        _buildDescriptionItem('Vasya/Vashya', '   Mutual attraction & power equation in marriage.'),
        _buildDescriptionItem('Tara/Dina', '   Birth star compatibility and destiny.'),
        _buildDescriptionItem('Yoni', '   Intimacy level & sexual compatibility'),
        _buildDescriptionItem('Graha Maitri/Rasyadipati', '   Mental compatibility and natural friendship.'),
        _buildDescriptionItem('Gana', '   Behavior and temperament.'),
        _buildDescriptionItem('Rashi or Bhakoot', '   Emotional compatibility and love.'),
        _buildDescriptionItem('Nadi', '   Health and genes.'),
      ],
    );
  }

  Widget _buildDescriptionItem(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• $title:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 9),
        Text(
          description,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
