import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class IncidentDetailsScreen extends StatelessWidget {
  final Map<dynamic, dynamic> incident;

  IncidentDetailsScreen({required this.incident});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text('Victim Details', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              // Navigate to home screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.info, color: Colors.white),
            onPressed: () {
              // Show info dialog
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(),
              const SizedBox(height: 16),
              _buildMapView(),
              const SizedBox(height: 16),
              _buildEmergencyContacts(),
              const SizedBox(height: 24),
              _buildRespondButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Incident Information',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text('Time of Incident: ${incident['timestamp'] ?? 'Not available'}'),
            Text('Location: ${incident['address'] ?? 'Address not available'}'),
            Text('Distance: ${incident['distance'] ?? 'Distance not available'}'),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: (incident['image_url'] != null && incident['image_url'] is String)
                  ? Image.network(
                incident['image_url'],
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : Image.asset(
                'assets/temp_image.png',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView() {
    double latitude = _parseDouble(incident['latitude']) ?? 23.2156;
    double longitude = _parseDouble(incident['longitude']) ?? 72.6369;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Map View',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          SizedBox(
            height: 200,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(latitude, longitude),
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('incident_location'),
                  position: LatLng(latitude, longitude),
                ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: const Text('View Larger Map'),
                onPressed: () {
                  // Open larger map view
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContacts() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Emergency Contacts',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text('Victim\'s Family: ${incident['victim_family_contact'] ?? 'Not available'}'),
            Text('Local Hospital: ${incident['local_hospital_contact'] ?? 'Not available'}'),
          ],
        ),
      ),
    );
  }

  Widget _buildRespondButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'Respond',
          style: TextStyle(fontSize: 18),
        ),
        onPressed: () {
          // Handle response action
        },
      ),
    );
  }

  double? _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is String) return double.tryParse(value);
    return null;
  }
}
