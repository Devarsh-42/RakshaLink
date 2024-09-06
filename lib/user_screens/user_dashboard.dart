import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class UserDashboardScreen extends StatefulWidget {
  @override
  _UserDashboardScreenState createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  final databaseRef = FirebaseDatabase.instance.ref().child('sos_alert');
  final String userPhoneNumber = "1234567890"; // This should be fetched during login

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Dashboard'),
        backgroundColor: Color(0xFF609DEF),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Notification logic
            },
          ),
        ],
      ),
      drawer: Drawer(
        // Add Drawer here if required
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/profile.jpg'), // Replace with your profile image
            ),
            SizedBox(height: 20),
            Text(
              'Are you in emergency?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Press the button below, help will reach you soon.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _sendSOSAlert,
              child: Text(
                'SOS',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(), backgroundColor: Colors.red,
                padding: EdgeInsets.all(40), // SOS Button color
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Emergency Contact',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Call 181 action
                  },
                  child: Text('Call 181'),
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2F80ED)),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Call 1091 action
                  },
                  child: Text('Call 1091'),
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2F80ED)),
                ),
              ],
            ),
            SizedBox(height: 30),
            Container(
              height: 200,
              child: Column(
                children: [
                  Text('Near by Police Station', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      // View larger map logic
                    },
                    child: Image.asset('assets/images/map_placeholder.png'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendSOSAlert() async {
    // Fetch current location
    Position position = await _determinePosition();

    String incidentId = Uuid().v4();
    String incidentType = "Alone woman detected";
    String latitude = position.latitude.toString();
    String longitude = position.longitude.toString();
    String timestamp = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(DateTime.now());

    // Send data to Firebase Realtime Database
    await databaseRef.push().set({
      'incident_id': incidentId,
      'incident_type': incidentType,
      'latitude': latitude,
      'longitude': longitude,
      'sos_sent': true,
      'timestamp': timestamp,
      'phone_number': userPhoneNumber,
    });

    // Show confirmation to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('SOS alert sent successfully!')),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
