import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future<User?> studentSignUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
        
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }
  Future<User?> employerSignUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  Future<User?> studentSignInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }
  // Check if the user is logged in
  bool isLoggedIn() {
    return _auth.currentUser != null;
  }
  // Get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<User?> employerSignInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }
  // Check if the user is logged in
  // bool isLoggedIn() {
  //   return _auth.currentUser != null;
  // }
  // // Get the current user
  // User? getCurrentUser() {
  //   return _auth.currentUser;
  // }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}