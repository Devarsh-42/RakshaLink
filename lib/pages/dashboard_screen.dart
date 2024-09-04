import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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
    _dbRef.child('incidents').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _incidents = data.values.map((incident) => incident as Map<dynamic, dynamic>).toList();
        });
      } else {
        setState(() {
          _incidents = []; // Handle empty or null data
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incident Dashboard'),
        backgroundColor: Colors.brown[300],
        actions: [
          IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Handle notification click
              }
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/author_logo.png'), // Replace with profile picture asset
            ),
          ),
        ],
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ALERT: ${incident['incident_type']?.toUpperCase() ?? 'UNKNOWN INCIDENT'}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              incident['description'] ?? 'No description provided.',
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
            Image.network(
              incident['image'] ?? '',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle location tracking
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('TRACK LOCATION'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle victim details
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: Text('VICTIM DETAILS'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
