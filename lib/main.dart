import 'package:carpoolcustomersversion/Modules/welcome/welcome_screen.dart';
import 'package:carpoolcustomersversion/home/bottom_navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Shared/components/components.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Pool Customers',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: FutureBuilder(
          future: initPref().then((value) => preferences?.getString('token')),
          builder: (context,snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting)
            {
              return const Center(child: CircularProgressIndicator());
            }
            else if(snapshot.hasData && snapshot.data != null)
            {
              print("------------------------------------");
              print(snapshot.data);
              return bottom_navigation();
            }
            else
            {
              print("************************************");
              print(snapshot.data);
              return WelcomeScreen();
            }
          },
    ));
  }
}
