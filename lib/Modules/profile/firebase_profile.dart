import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import '../../Shared/components/components.dart';
import '../../Shared/database.dart';

class firebase_profile{
  String? first_name ;
  String? last_name ;
  String? phone_number ;
  String? age ;
  String? grade ;
  String image_url = "https://media.istockphoto.com/id/587805156/vector/profile-picture-vector-illustration.jpg?s=1024x1024&w=is&k=20&c=N14PaYcMX9dfjIQx-gOrJcAUGyYRZ0Ohkbj5lH-GkQs=" ;

  Future<void> getProfileData() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if(connectivityResult == ConnectivityResult.none){
        showToast(text: "No internet connection", error: true);
        List<Map<String, dynamic>> users = await DatabaseHelper.getUsers();
        print("hehe");
        print(users[users.length-1]);
        first_name = users[users.length-1]['first_name'];
        last_name = users[users.length-1]['last_name'];
        phone_number = users[users.length-1]['phone_number'];
        age = users[users.length-1]['age'];
        grade = users[users.length-1]['grade'];
        image_url = users[users.length-1]['image_url'];
      }
      else{
        String? uID = getToken();
        DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uID).get();
        if (userSnapshot.exists) {
          Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

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

          try {
            await DatabaseHelper.saveUserData(
                firstName: first_name,
                lastName: last_name,
                phoneNumber: phone_number,
                age: age,
                grade: grade,
                imageUrl: image_url);
          } catch (e) {
            print(e);
          }

          print("Done");
        } else {
          // The document with the given user ID does not exist
          print('User with ID $uID does not exist');
        }
      }
    } catch (e) {
      print('Error retrieving user data: $e');
      showToast(text: "Please add new photo", error: true);
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