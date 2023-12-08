import 'dart:io';

import 'package:carpoolcustomersversion/Modules/login/Login.dart';
import 'package:carpoolcustomersversion/Modules/profile/firebase_profile.dart';
import 'package:carpoolcustomersversion/Shared/colors/common_colors.dart';
import 'package:carpoolcustomersversion/Shared/components/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // String first_name = "Ahmed Ossama";
  // String last_name = "Ahmed Ossama";
  // String phone_number = "+201147730338";
  // int age = 22;
  // String grade = "Senior";
  // String image_url = "https://www.wilsoncenter.org/sites/default/files/styles/large/public/media/images/person/james-person-1.webp"; // Replace with your image URL
  File? _image;
  final picker = ImagePicker();
  firebase_profile _firebase_profile = firebase_profile();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            navigateAndFinish(context, Login());
          },
        ),
        title: appbarText("Profile"),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: mainAppColor, // Change this to the desired color
        ),
        backgroundColor: defaultColor,
      ),
      body: FutureBuilder<void>(
        future: _firebase_profile.getProfileData(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
          {
            return const Center(child: CircularProgressIndicator());
          }
          else if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()));
          }
          else if(snapshot.connectionState == ConnectionState.done){
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: NetworkImage(_firebase_profile.image_url),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: _pickImage,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildInfoRow("firstName", _firebase_profile.first_name),
                      _buildInfoRow("lastName", _firebase_profile.last_name),
                      _buildInfoRow("phone", _firebase_profile.phone_number),
                      _buildInfoRow("age", _firebase_profile.age),
                      _buildInfoRow("grade", _firebase_profile.grade),
                    ],
                  ),
                ),
              );
          }
          else{
            return const Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Row(
            children: [
              Text(
                value!,
                style: TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _showEditDialog(context, label);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  Future<void> _pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _uploadImageAndUpdateProfile();
    }
    });
  }

  Future<void> _showEditDialog(BuildContext context, [String? field]) async {
    String? updated_value;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $field"),
        content: TextField(
          keyboardType:field=="age"||field=="phone"?TextInputType.number: TextInputType.text,
          onChanged: (value) {
            switch (field) {
              case "firstName":
                // _firebase_profile.first_name = value;
                updated_value = value;
                break;
              case "lastName":
                // _firebase_profile.last_name = value;
                updated_value = value;
                break;
              case "phone":
                // _firebase_profile.phone_number = value;
                updated_value = value;
                break;
              case "age":
                // _firebase_profile.age = value;
                updated_value = value;
                break;
              case "grade":
                // _firebase_profile.grade = value;
                updated_value = value;
                break;
            }
          },
          decoration: InputDecoration(
            labelText: "New $field",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async{
              await _firebase_profile.updateUserField(field!, updated_value!,context);
              Navigator.pop(context);
              setState(() {});
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadImageAndUpdateProfile() async {
    if (_image != null) {
      try {
        buildProgress(context: context, text: 'Uploading image...');
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        Reference storageReference =
        FirebaseStorage.instance.ref().child('profile_images/$fileName');

        await storageReference.putFile(_image!);

        String downloadUrl = await storageReference.getDownloadURL();

        await _firebase_profile.updateUserField('image_url', downloadUrl, context);

        setState(() {
          _firebase_profile.image_url = downloadUrl;
        });

        print('Image uploaded successfully. URL: $downloadUrl');
        hidebuildProgress(context);
        showToast(text: "Image Uploaded", error: false);
      } catch (e) {
        hidebuildProgress(context);
        print('Error uploading image: $e');
        showToast(text: "Failed to upload Image", error: true);
      }
    }
  }
}


