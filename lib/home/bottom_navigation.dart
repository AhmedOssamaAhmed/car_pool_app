import 'package:carpoolcustomersversion/home/routes.dart';
import 'package:carpoolcustomersversion/home/history.dart';
import 'package:flutter/material.dart';


class bottom_navigation extends StatefulWidget {
  @override
  _bottom_navigationState createState() => _bottom_navigationState();
}

class _bottom_navigationState extends State<bottom_navigation>
{
  int SelectedIndex = 0;
List<Widget> myWidgets=[
  routes(),
  history(),
];
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: myWidgets[SelectedIndex],
    bottomNavigationBar: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: BottomNavigationBar(
        onTap: (index)
        {
          setState(() {
            SelectedIndex = index;
          });
        },
        currentIndex:SelectedIndex ,
        items: const [
          BottomNavigationBarItem(
            label: "Routes",
            icon: Icon(Icons.route),
          ),

          BottomNavigationBarItem(
              label: "History",
              icon: Icon(Icons.history)
          ),

        ],
      ),
    ),

  );
  }
}
