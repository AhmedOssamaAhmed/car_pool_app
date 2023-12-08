

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../Shared/components/components.dart';

class firebase_profile{
  String? first_name ;
  String? last_name ;
  String? phone_number ;
  String? age ;
  String? grade ;
  String image_url = "https://media.istockphoto.com/id/587805156/vector/profile-picture-vector-illustration.jpg?s=1024x1024&w=is&k=20&c=N14PaYcMX9dfjIQx-gOrJcAUGyYRZ0Ohkbj5lH-GkQs=" ;

  Future<void> getProfileData() async {
    try {
      String? uID = getToken();
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(uID).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

        first_name = userData['firstName'];
        last_name = userData['lastName'];
        phone_number = userData['phone'];
        age = userData['age'];
        grade = userData['grade'];
        image_url = userData['image_url'];
        print(first_name);
        print(last_name);
        print(phone_number);
        print(age);
        print(grade);
        print(image_url);
        print("Done");
      } else {
        // The document with the given user ID does not exist
        print('User with ID $uID does not exist');
      }
    } catch (e) {
      print('Error retrieving user data: $e');
      showToast(text: "Error retrieving user data", error: true);
    }
  }

  Future<void> updateUserField(String fieldName, dynamic newValue,context) async {
    try {
      buildProgress(context: context, text: 'Updating user field...');
      String? uID = getToken();
      CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

      DocumentSnapshot userDoc = await usersCollection.doc(uID).get();
      if (!userDoc.exists) {
        showToast(text: "user not found !", error: true);
      }
      await usersCollection.doc(uID).update({
        fieldName: newValue,
      });

      print('User $uID $fieldName updated to $newValue');
      hidebuildProgress(context);
    } catch (e) {
      showToast(text: "Error updating user field: $e", error: true);
      print('Error updating user field: $e');
      hidebuildProgress(context);
    }
  }

}