import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:therakshalink/services/auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _policeIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                color: Colors.brown[300],
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _policeIdController,
                    decoration: InputDecoration(
                      labelText: 'Police ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Implement Forgot Password functionality
                      },
                      child: Text('Forgot Password?'),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      String policeId = _policeIdController.text.trim();
                      String password = _passwordController.text.trim();
                      User? user = await _authService.signInWithEmailAndPassword(
                          "$policeId@gmail.com", password);
                      if (user != null) {
                        // Navigate to the dashboard
                      } else {
                        // Show error message
                      }
                    },
                    child: Text('Login'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ClipPath(
              clipper: WaveClipper(flip: true),
              child: Container(
                color: Colors.brown[300],
                height: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final bool flip;
  WaveClipper({this.flip = false});

  @override
  Path getClip(Size size) {
    var path = Path();
    if (flip) {
      path.lineTo(0, size.height);
      var firstControlPoint = Offset(size.width * 0.25, size.height - 50);
      var firstEndPoint = Offset(size.width * 0.5, size.height);
      var secondControlPoint = Offset(size.width * 0.75, size.height + 50);
      var secondEndPoint = Offset(size.width, size.height);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);
    } else {
      path.lineTo(0, size.height - 50);
      var firstControlPoint = Offset(size.width * 0.25, size.height);
      var firstEndPoint = Offset(size.width * 0.5, size.height - 50);
      var secondControlPoint = Offset(size.width * 0.75, size.height - 100);
      var secondEndPoint = Offset(size.width, size.height - 50);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);
    }
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
