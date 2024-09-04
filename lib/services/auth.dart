import 'package:firebase_auth/firebase_auth.dart';
import 'package:therakshalink/services/auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String regID, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: "$regID@gmail.com", password: password);
      return credential.user;
    } catch (e) {
      print("Couldn't add user to Firebase: $e");
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      String regID = email.split('@')[0];
      // Map<String, dynamic>? regIDData = await dbService.verifyAndRetrieveRegIDData(regID);


        UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
        return credential.user;
      // } else {
      //   print("Invalid Registration ID");
      // }
    } catch (e) {
      print("Couldn't sign in user to Firebase: $e");
    }
    return null;
  }

  Future signInAnon() async {
    try {
      UserCredential credential = await _auth.signInAnonymously();
      return credential.user;
    } catch (e) {
      print("Couldn't sign in user to Firebase: $e");
    }
    return null;
  }
}
