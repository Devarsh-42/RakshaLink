import 'package:flutter/material.dart';
// Import the login screen
 // Import the splash screen
import 'package:firebase_core/firebase_core.dart';
import 'package:therakshalink/police_screens/dashboard_screen.dart';
import 'package:therakshalink/police_screens/login_screen.dart';
import 'package:therakshalink/police_screens/splash_screen.dart';
import 'package:therakshalink/selection_screen.dart';
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
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(), // Splash screen route
        '/selection': (context) => SelectionScreen(), // Splash screen route
        '/loginPolice': (context) => LoginPage(), // Login screen route
        '/dashboard': (context) => DashboardScreen(), // Replace with your dashboard screen
        '/userdashboard': (context) => DashboardScreen(), // Replace with your dashboard screen
      },
    );
  }
}
