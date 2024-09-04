import 'package:flutter/material.dart';
import 'package:therakshalink/pages/dashboard_screen.dart';
import 'package:therakshalink/pages/login_screen.dart';
import 'package:therakshalink/pages/splash_screen.dart'; // Import the login screen
import 'package:therakshalink/pages/splash_screen.dart'; // Import the login screen
 // Import the splash screen
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jatayu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/splash': (context) => SplashScreen(), // Splash screen route
        '/login': (context) => LoginPage(), // Login screen route
        '/dashboard': (context) => DashboardScreen(), // Replace with your dashboard screen
      },
    );
  }
}
