
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../colors/common_colors.dart';
SharedPreferences? preferences;

// Button
Widget defaultButton({
  double fontSize = 14,
  Color textcolor = Colors.white,
  Color background = defaultColor,
  double radius = 5.0,
  required var function,
  required String text,
  bool toUpper = true,})=> Container(
  width: double.infinity,
  height: 40.0,
  decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: defaultColor, )
  ),
  child: ElevatedButton(style: ElevatedButton.styleFrom(
    backgroundColor: background,
  ),
    onPressed: function! ,
    child: Text(
      toUpper ? text.toUpperCase() : text,
      style: TextStyle(
          fontSize: fontSize,
          color: textcolor
      ),),
  ),
);


// Input field
Widget defaultTextInputField({
  bool safe = false,
  String? title,
  String hint = '',
  required TextEditingController controller,
  required TextInputType type,
})=>Container(width: 334,
  padding: EdgeInsetsDirectional.only(
    start: 10,
    end: 10,
    top: 10,
  ),
  decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            offset: Offset(1,3))
      ],
      color: Colors.white,
      borderRadius: BorderRadius.circular(16)
  ),
  child: Column( crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      detailsText(title!),
      TextFormField(
        controller: controller,
        obscureText: safe,
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: 16, color: Colors.grey[300]),
          border: InputBorder.none,
          hintText: hint,
        ),
        keyboardType: type,
      ),

    ],
  ),
);



// head text
Widget headText(String text)=>Text(text,
  style: TextStyle(fontSize: 32,),
  maxLines: 2,
  textAlign: TextAlign.center, );

// caption text
Widget captionText(String text)=>Text(text, style: TextStyle(fontSize: 16),);

// details text
Widget detailsText(String text)=> Text(text, style: TextStyle(fontSize: 12),);

Widget appbarText(String text)=>Text(text,
  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20,color: mainAppColor),);

AppBar defaultappbar(String text) => AppBar(title: appbarText(text),centerTitle: true,
  iconTheme: IconThemeData(
    color: mainAppColor, // Change this to the desired color
  ),
  backgroundColor: defaultColor,
);


AppBar customAppBar(String text,int cartItemCount) => AppBar(
  title: appbarText(text),
  centerTitle: true,
  iconTheme: IconThemeData(
    color: mainAppColor, // Change this to the desired color
  ),
  backgroundColor: defaultColor,
  actions: <Widget>[
    Stack(
      children: [
        IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {// Handle cart button click
          },
        ),
        cartItemCount > 0
            ? Positioned(
          right: 5,
          top: 5,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            constraints: BoxConstraints(
              minWidth: 15,
              minHeight: 15,
            ),
            child: Center(
              child: Text(
                cartItemCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        )
            : SizedBox.shrink(),
      ],
    ),
  ],
);

// logo
Widget Logo()=>Container(
    width: 100,
    height: 100,
    child: Image(image: AssetImage('assets/logo.png')));


// navigate to certain page
void navigateTo(context, widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    )
);

//navigate to certain page then exit
void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
        (Route<dynamic> route) => false);


// showing buildprogress
void buildProgress({
  context,
  text,
  bool error = false,
}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (!error) CircularProgressIndicator(),
                if (!error)
                  SizedBox(
                    width: 20.0,
                  ),
                Expanded(
                  child: Text(
                    text,
                  ),
                ),
              ],
            ),
            if (error)
              SizedBox(
                height: 20.0,
              ),
            if (error)
              defaultButton(
                function: ()
                {
                  Navigator.pop(context);
                },
                text: 'cancel',
              )
          ],
        ),
      ),
    );
void hidebuildProgress(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
void showToast({@required text, @required error,}) => Fluttertoast.showToast(
  msg: text.toString(),
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  timeInSecForIosWeb: 1,
  backgroundColor: error ? Colors.red : Colors.green,
  textColor: Colors.white,
  fontSize: 16.0,
);

Future<void> initPref() async
{
  preferences = await SharedPreferences.getInstance();
}

Future<bool> saveToken(String token) => preferences!.setString('token', token);

Future<bool> removeToken() => preferences!.remove('token');

String? getToken() => preferences!.getString('token');

String formatTimeOfDay(TimeOfDay timeOfDay) {
  final now = DateTime.now();
  final dateTime = DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  final formatter = DateFormat.Hm(); // Use Hm for 24-hour format, or 'jm' for 12-hour format with AM/PM
  return formatter.format(dateTime);
}
String formatDate(DateTime dateTime) {
  String day = dateTime.day.toString().padLeft(2, '0');
  String month = dateTime.month.toString().padLeft(2, '0');
  String year = dateTime.year.toString();

  return '$day/$month/$year';
}
DateTime current_time = DateTime.now();

Future<void> selectDateTime(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: current_time,
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );

  if (picked != null) {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current_time),
    );

    if (pickedTime != null) {
      current_time = DateTime(
        picked.year,
        picked.month,
        picked.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    }
  }
}

Future<String?> getUserName(String userId) async {
  try {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;

      // Assuming 'name' is a field in the user document
      String firstName = userData['firstName'];
      String lastName = userData['lastName'];
      String userName = firstName + " " + lastName;
      return userName;
    } else {
      // The document with the given user ID does not exist
      print('User with ID $userId does not exist');
      return null;
    }
  } catch (e) {
    print('Error retrieving user name: $e');
    return null;
  }
}