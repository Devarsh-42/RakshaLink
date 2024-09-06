import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geocoding/geocoding.dart';
import 'incident_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  List<Map<dynamic, dynamic>> _incidents = [];

  @override
  void initState() {
    super.initState();
    _fetchIncidents();
  }

  void _fetchIncidents() async {
    _dbRef.child('sos_alerts').onValue.listen((event) async {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return;

      List<Map<dynamic, dynamic>> tempIncidents = [];

      for (var incident in data.values) {
        Map<dynamic, dynamic> incidentMap = incident as Map<dynamic, dynamic>;
        double latitude = _parseDouble(incidentMap['latitude']) ?? 0.0;
        double longitude = _parseDouble(incidentMap['longitude']) ?? 0.0;

        incidentMap['latitude'] = latitude;
        incidentMap['longitude'] = longitude;

        String address = await _getAddressFromLatLng(latitude, longitude);
        incidentMap['address'] = address;

        tempIncidents.add(incidentMap);
      }

      setState(() {
        _incidents = tempIncidents;
      });
    });
  }

  double? _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is String) return double.tryParse(value);
    return null;
  }

  Future<String> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
    } catch (e) {
      print(e);
    }
    return 'No address available';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1A237E),
        title: Text('Incident Dashboard', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Handle notification click
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/author_logo.png'),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF1A237E),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Account Details'),
              onTap: () {
                // Navigate to account details
              },
            ),
            ListTile(
              leading: Icon(Icons.build_circle),
              title: Text('Ongoing Operations'),
              onTap: () {
                // Navigate to ongoing operations
              },
            ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text('Incident Report'),
              onTap: () {
                // Navigate to incident report
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8.0),
        itemCount: _incidents.length,
        itemBuilder: (context, index) {
          final incident = _incidents[index];
          return _buildIncidentCard(incident);
        },
      ),
    );
  }

  Widget _buildIncidentCard(Map<dynamic, dynamic> incident) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Colors.red.shade400,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ALERT: ${incident['incident_type']?.toUpperCase() ?? 'INCIDENT'} DETECTED',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              incident['description'] ?? "Details not available",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey),
                SizedBox(width: 4.0),
                Expanded(
                  child: Text(
                    incident['address'] ?? 'No address available',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: incident['image_url'] != null && incident['image_url'] is String
                  ? Image.network(
                incident['image_url'],
                height: 150.0,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                'assets/temp_image.png',
                height: 150.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8.0),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IncidentDetailsScreen(incident: incident),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text('Victim Details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
