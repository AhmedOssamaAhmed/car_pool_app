

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
      print('User signed in: ${user.uid}');
      String? userID = user.uid;
      showToast(text: userID, error: false);
      try{ // FIXME: this is not working
        // initPref();
        SharedPreferences mypref = await SharedPreferences.getInstance();
        mypref.setString('token', userID);
        // saveToken("user logged in");
      }catch(e)
      {
        print("*********************************");
        print(e);
      }
    }

    hidebuildProgress(context);
    navigateAndFinish(context, bottom_navigation());

  } catch (e) {
    print("*********************************");
    print('osossssssssss$e');
    String error = e.toString();
    print(error);
      if (error == '[firebase_auth/invalid-email] The email address is badly formatted.') {
        print('Wrong email.');
        showToast(text: 'Wrong email.', error: true);
      } else if (error == '[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.') {
        print('Wrong password');
        showToast(text: 'Wrong password', error: true);
      }
      hidebuildProgress(context);
  }
}