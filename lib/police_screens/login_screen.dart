import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:therakshalink/services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController _regIDController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  void dispose() {
    _regIDController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(58, 97, 246, 1.0),
    ));
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(40, 35, 40, 5),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(58, 152, 246, 1.0),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4), // Shadow color with opacity
                      spreadRadius: 0, // Spread radius
                      blurRadius: 10, // Blur radius
                      offset: const Offset(0, 5), // Offset in the x and y directions
                    ),
                  ],
                ),
                height: 273.0,
                width: 420.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Jatayu",
                      style: TextStyle(
                          fontSize: 40,
                          color: Color.fromRGBO(221, 221, 221, 1),
                          fontFamily: 'PoppinsMedium'),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color.fromRGBO(217, 217, 217, 1),
                          Color.fromRGBO(175, 175, 175, 80)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Text(
                        "Joint Action and Tracking for Alerting Urban Safety System",
                        style: TextStyle(
                          fontSize: 36,
                          color: Colors.white, // This color is a placeholder
                          fontFamily: 'PoppinsRegular',
                        ),
                      ),
                    ),
                    const SizedBox(height: 45),
                    const Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: 'LatoBold'),
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 75),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  controller: _regIDController,
                  decoration: InputDecoration(
                      labelText: 'Enter your Police ID',
                      labelStyle:
                      const TextStyle(color: Color.fromRGBO(170, 170, 170, 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black))),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: TextField(
                  controller: _passController,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle:
                      const TextStyle(color: Color.fromRGBO(170, 170, 170, 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black))),
                ),
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: () async {
                  bool success = await _signIn();
                  if (success) {
                    Navigator.pushReplacementNamed(context, "/dashboard");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login Failed!!")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(58, 152, 246, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    fixedSize: const Size(375, 50),
                    elevation: 6
                ),
                child: const Text(
                  "Login Account",
                  style: TextStyle(
                      fontSize: 16, color: Colors.white, fontFamily: 'LatoBold'),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.fromLTRB(20,0,20,0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: const Color.fromRGBO(221, 221, 221, 1),
                        height: 1,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _signIn() async {
    String policeId = _regIDController.text.toString();
    String password = _passController.text;

    String regIdEmail = "$policeId@gmail.com";

    User? user = await _auth.signInWithEmailAndPassword(regIdEmail, password);

    if (user != null) {
      print("User Logged In Successfully!!");
      return true;
    } else {
      print("Error Occurred");
      return false;
    }
  }

  Future<void> _signInAnon() async {
    User? user = await _auth.signInAnon();

    if (user != null) {
      print("User Logged In Successfully!!");
    } else {
      print("Error Occurred");
    }
  }
}