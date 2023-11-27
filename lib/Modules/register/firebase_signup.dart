
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';




Future<void> signUp(String email,String firstName,String lastName, String password) async {
  try {

    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // User signed up successfully
    User? user = userCredential.user;
    print('User signed up: ${user?.uid}');
    // Save additional user information to Firestore
    try {
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
    });
    } catch (e) {
      print("cant save to firestore");
      print('Error: $e');
    }
  } catch (e) {
    switch (e) {
      case 'email-already-in-use':
        print("Email is already in use. Please use a different email.");
        break;
      case 'weak-password':
        print("Password is too weak. Please use a stronger password.");
        break;
    }
  }
}

