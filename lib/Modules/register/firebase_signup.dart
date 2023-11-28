
import 'package:carpoolcustomersversion/Shared/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../login/Login.dart';




Future<void> signUp(String email,String firstName,String lastName, String password,String phone,context) async {
  try {
    buildProgress(text: "please verify your email, check spam", context: context,error: false);

    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // User signed up successfully
    User? user = userCredential.user;
    print('User signed up: ${user?.uid}');

    // send email verification
    try {
      await user!.sendEmailVerification();
      print("Email verification sent");
      showToast(text: "Email verification sent", error: false);

      // Save additional user information to Firestore
      // if(user.emailVerified) {
      //   print("Email is verified");
      //   showToast(text: "Email is verified", error: false);
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
          navigateAndFinish(context, Login());
        } catch (e) {
          print("cant save to firestore");
          print('Error: $e');
        }
      // }
    } catch (e) {
      print("An error occured while trying to send email verification");
      print('Error: $e');
    }


  } catch (e) {
    switch (e) {
      case '[firebase_auth/email-already-in-use] The email address is already in use by another account.':
        showToast(text: "Email already in use", error: true);
        print("Email is already in use. Please use a different email.");
        break;
      case 'weak-password':
        showToast(text: "Password is too weak", error: true);
        print("Password is too weak. Please use a stronger password.");
        break;
      default:
        showToast(text: "Error: $e", error: true);
        print("Error: $e");
        break;
    }
  }
}

