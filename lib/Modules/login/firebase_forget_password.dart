
import 'package:carpoolcustomersversion/Shared/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Login.dart';

Future<void> resetPassword(String email,context) async {
  try {
    buildProgress(context: context, text: "Sending reset code");
    await FirebaseAuth.instance.sendPasswordResetEmail(
      email: email,
    );
    print('Password reset email sent to $email');
    hidebuildProgress(context);
    showToast(text: "Password reset email sent to $email", error: false);
    navigateAndFinish(context, Login());
    // Add any additional UI feedback or navigation if needed
  } catch (e) {
    print('Error sending password reset email: $e');
    showToast(text: "Email doesn't exist", error: true);
    // Handle the error and provide user feedback if necessary
  }
}

