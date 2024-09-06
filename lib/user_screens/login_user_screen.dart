import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class LoginUserPage extends StatefulWidget {
  const LoginUserPage({super.key});

  @override
  State<LoginUserPage> createState() => _LoginUserPageState();
}

class _LoginUserPageState extends State<LoginUserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  String _verificationId = '';

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
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
                padding: const EdgeInsets.fromLTRB(40, 35, 40, 5),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(58, 152, 246, 1.0),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
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
                          color: Colors.white,
                          fontFamily: 'PoppinsRegular',
                        ),
                      ),
                    ),
                    const SizedBox(height: 45),
                    const Center(
                        child: Text(
                          "User Login",
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
                  controller: _phoneController,
                  decoration: InputDecoration(
                      labelText: 'Enter your phone number',
                      labelStyle:
                      const TextStyle(color: Color.fromRGBO(170, 170, 170, 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black))),
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _verifyPhoneNumber(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(58, 152, 246, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    fixedSize: const Size(375, 50),
                    elevation: 6
                ),
                child: const Text(
                  "Send OTP",
                  style: TextStyle(
                      fontSize: 16, color: Colors.white, fontFamily: 'LatoBold'),
                ),
              ),
              const SizedBox(height: 22),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  controller: _otpController,
                  decoration: InputDecoration(
                      labelText: 'Enter OTP',
                      labelStyle:
                      const TextStyle(color: Color.fromRGBO(170, 170, 170, 1)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.black))),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _signInWithPhoneNumber,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(58, 152, 246, 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    fixedSize: const Size(375, 50),
                    elevation: 6
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 16, color: Colors.white, fontFamily: 'LatoBold'),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text(
                  "Create a new account",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueAccent,
                      fontFamily: 'LatoBold'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  Future<void> _signInWithPhoneNumber() async {
    String smsCode = _otpController.text.trim();

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );

    try {
      await _auth.signInWithCredential(credential);
      Navigator.pushReplacementNamed(context, "/dashboard");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    }
  }
}
