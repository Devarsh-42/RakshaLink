import 'package:flutter/material.dart';

class SelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF609DEF), // Background color
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo at the top
            Center(
              child: Image.asset(
                'assets/jatayu_logo.png', // Make sure to add your logo image to assets
                width: 150,
                height: 150,
              ),
            ),
            SizedBox(height: 50), // Space between logo and buttons

            // Police Login Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2F80ED), // Button color
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/loginPolice');
              },
              child: Text(
                'Police Login',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20), // Space between buttons

            // Normal User Login Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2F80ED), // Button color
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/loginuser');
              },
              child: Text(
                'Normal User Login',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
