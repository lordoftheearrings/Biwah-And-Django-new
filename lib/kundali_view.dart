import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'edit_kundali_info.dart';
import 'api_service.dart';

class KundaliViewPage extends StatefulWidget {
  final String username;

  const KundaliViewPage({Key? key, required this.username}) : super(key: key);

  @override
  _KundaliViewPageState createState() => _KundaliViewPageState();
}

class _KundaliViewPageState extends State<KundaliViewPage> with RouteAware {
  final ApiService apiService = ApiService();
  String? kundaliSvgContent;
  bool isLoading = false;

  // Load profile info for the user
  Future<void> loadProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Retrieve the profile data using the username
      final profileData = await apiService.loadProfile(widget.username);

      if (profileData != null) {
        if (profileData['kundali_svg'] == null) {
          setState(() {
            kundaliSvgContent = null;
          });
        } else {
          // Fetch the Kundali SVG content
          final svgContent = await apiService.getKundaliSvg(widget.username);
          setState(() {
            kundaliSvgContent = svgContent;
          });
        }
      } else {
        setState(() {
          kundaliSvgContent = null;
        });
      }
    } catch (e) {
      print("Error loading profile: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadProfile();
  }

  @override
  void didUpdateWidget(covariant KundaliViewPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.username != widget.username) {
      loadProfile();
    }
  }

  @override
  void didPush() {
    super.didPush();
    loadProfile();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    loadProfile();
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
          'Kundali',
          style: TextStyle(
            fontFamily: 'CustomFont3',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(153, 0, 76, 1),
        elevation: 5,
        actions: [
          ElevatedButton(
            onPressed: () async {
              final updatedData = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditKundaliInfoPage(
                    username: widget.username,
                  ),
                ),
              );
              if (updatedData != null) {
                // Refresh the profile to get the updated Kundali SVG
                loadProfile();
              }
            },
            child: Text(
              'Edit Info',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black),
            ),
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
          SizedBox(width: 10),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : kundaliSvgContent == null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NO KUNDALI INFO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: 'CustomFont3',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final updatedData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditKundaliInfoPage(
                      username: widget.username,
                    ),
                  ),
                );
                if (updatedData != null) {
                  // Refresh the profile to get the updated Kundali SVG
                  loadProfile();
                }
              },
              child: Text(
                'Give Details',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(255, 182, 193, 1),
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.username}\'s Lagna Kundali',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontFamily: 'CustomFont2',
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: SingleChildScrollView(
                child: SvgPicture.string(
                  kundaliSvgContent!,
                  placeholderBuilder: (context) => CircularProgressIndicator(),
                ),
              ),
            ),
            _buildPlanetAbbreviations(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanetAbbreviations() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      crossAxisSpacing: 4.0,
      mainAxisSpacing: 4.0,
      childAspectRatio: 3.0,
      children: [
        _buildPlanetItem('Mo', 'Moon'),
        _buildPlanetItem('(Ke)', 'Ketu'),
        _buildPlanetItem('Ma', 'Mars'),
        _buildPlanetItem('Ju', 'Jupiter'),
        _buildPlanetItem('Me', 'Mercury'),
        _buildPlanetItem('Su', 'Sun'),
        _buildPlanetItem('Ve', 'Venus'),
        _buildPlanetItem('Sa', 'Saturn'),
        _buildPlanetItem('(Ra)', 'Rahu'),
      ],
    );
  }

  Widget _buildPlanetItem(String abbreviation, String description) {
    return Center(
      child: Text(
        '$abbreviation: $description',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontFamily: 'CustomFont2',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
