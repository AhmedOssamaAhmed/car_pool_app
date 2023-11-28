import 'dart:io';

import 'package:carpoolcustomersversion/Modules/login/Login.dart';
import 'package:carpoolcustomersversion/Shared/colors/common_colors.dart';
import 'package:carpoolcustomersversion/Shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String fullName = "Ahmed Ossama";
  String phoneNumber = "+201147730338";
  int age = 22;
  String grade = "Senior";
  String imageUrl = "https://www.wilsoncenter.org/sites/default/files/styles/large/public/media/images/person/james-person-1.webp"; // Replace with your image URL
  File? _image;
  final picker = ImagePicker();

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
      body: Padding(
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
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: _pickImage,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoRow("Full Name", fullName),
            _buildInfoRow("Phone Number", phoneNumber),
            _buildInfoRow("Age", age.toString()),
            _buildInfoRow("Grade", grade),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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
                value,
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
      }
    });
  }

  Future<void> _showEditDialog(BuildContext context, [String? field]) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $field"),
        content: TextField(
          onChanged: (value) {
            switch (field) {
              case "Full Name":
                fullName = value;
                break;
              case "Phone Number":
                phoneNumber = value;
                break;
              case "Age":
                age = int.tryParse(value) ?? age;
                break;
              case "Grade":
                grade = value;
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
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
 }


