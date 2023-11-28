
import 'package:carpoolcustomersversion/Shared/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../login/Login.dart';





Future<void> signUp(String email,String firstName,String lastName, String password,String phone,context) async {
  try {
    buildProgress(text: "Loading ...", context: context,error: false);

    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // User signed up successfully
    User? user = userCredential.user;
    print('User signed up: ${user?.uid}');


        try {
          await FirebaseFirestore.instance.collection('users')
              .doc(user?.uid)
              .set({
            'email': email,
            'password': password,
            'firstName': firstName,
            'lastName': lastName,
            'phone': phone,
            'age': "null",
            'grade': "null",
          });
          hidebuildProgress(context);
          showToast(text: "signed up", error: false);
          navigateAndFinish(context, Login());
        } catch (e) {
          print("cant save to firestore");
          print('Error: $e');
        }

  } catch (e) {
    switch (e) {
      case '[firebase_auth/email-already-in-use] The email address is already in use by another account.':
        showToast(text: "Email already in use", error: true);
        print("Email is already in use. Please use a different email.");
        hidebuildProgress(context);
        break;
      case 'weak-password':
        showToast(text: "Password is too weak", error: true);
        print("Password is too weak. Please use a stronger password.");
        hidebuildProgress(context);
        break;
      default:
        showToast(text: "Error: $e", error: true);
        hidebuildProgress(context);
        print("Error: $e");
        break;
    }
  }
}

