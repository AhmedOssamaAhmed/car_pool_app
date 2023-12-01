

import 'package:carpoolcustomersversion/Shared/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/bottom_navigation.dart';

Future<void> signIn(String email,String password,context) async {

  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // User signed in successfully
    User? user = userCredential.user;
    if(user != null)
    {
      String? userID = user.uid;
      showToast(text: userID, error: false);
      try{
        SharedPreferences mypref = await SharedPreferences.getInstance();
        print(userID);
        mypref.setString('token', userID);
      }catch(e)
      {
        print(e);
        showToast(text: e, error: true);
      }
    }

    hidebuildProgress(context);
    navigateAndFinish(context, bottom_navigation());

  } catch (e) {
    String error = e.toString();
    print(error);
      if (error == '[firebase_auth/invalid-email] The email address is badly formatted.') {
        print('Wrong email.');
        showToast(text: 'Wrong email.', error: true);
      } else if (error == '[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.') {
        print('Wrong Credentials.');
        showToast(text: 'Wrong Credentials', error: true);
      }
      hidebuildProgress(context);
  }
}