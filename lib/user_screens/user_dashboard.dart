import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Add Google Maps package

class UserDashboardScreen extends StatefulWidget {
  @override
  _UserDashboardScreenState createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  final databaseRef = FirebaseDatabase.instance.ref().child('sos_alerts');
  final String userPhoneNumber = "+916351914313"; // This should be fetched during login

  late GoogleMapController mapController;

  final LatLng _initialPosition = const LatLng(37.7749, -122.4194); // Example position

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF609DEF),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Drawer logic
          },
        ),
        title: Text('Emergency Dashboard'),
        actions: [
          const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/images/author_logo.png'), // Replace with your profile image
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Notification logic
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(), backgroundColor: Colors.red,
                padding: EdgeInsets.all(screenSize.width * 0.12), // SOS Button size adjusts to screen
              ),
            ),
            SizedBox(height: 30),
            const Text(
              'Emergency Contact',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _makePhoneCall('tel:181'),
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2F80ED)),
                  child: const Text('Call 181', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () => _makePhoneCall('tel:1091'),
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2F80ED)),
                  child: const Text('Call 1091', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 20),
            Card(
              elevation: 3,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Nearby Police Stations'),
                    trailing: GestureDetector(
                      onTap: () async {
                        Position position = await _determinePosition(); // Get the user's current location
                        String googleUrl = 'https://www.google.com/maps/search/?api=1&query=police+station&query_place_id=${position.latitude},${position.longitude}';
                        if (await canLaunch(googleUrl)) {
                          await launch(googleUrl);
                        } else {
                          throw 'Could not open Google Maps';
                        }
                      },
                      child: Text(
                        'View Larger Map',
                        style: TextStyle(color: Color(0xFF2F80ED)),
                      ),
                    ),
                  ),
                  Container(
                    height: screenSize.height * 0.3, // Make map responsive
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _initialPosition,
                        zoom: 12,
                      ),
                      onMapCreated: (controller) {
                        mapController = controller;
                      },
                    ),
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
      const SnackBar(content: Text('SOS alert sent successfully!')),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
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
