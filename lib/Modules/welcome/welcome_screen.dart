import 'package:flutter/material.dart';
import '../../Shared/colors/common_colors.dart';
import '../../Shared/components/components.dart';
import '../login/Login.dart';
import '../register/signup.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 194,
                  child: headText('Share Your Ride 🚗'),),
              const SizedBox(height:20),
              Logo(),
              const SizedBox(
                height: 50,
              ),
              defaultButton(radius:24 ,
                  fontSize: 12,
                  background: defaultColor!,
                  textcolor: Colors.white,
                  function: (){
                print("login");
                    navigateTo(context, Login());
                  },
                  text: 'login',
                  toUpper: true,),
              const SizedBox(
                height: 20,
              ),
              defaultButton(radius: 24,
                background: mainAppColor!,
                textcolor: defaultColor,
                function: (){
                print("sign up");
                  navigateTo(context, SignUp());
                },
                text: 'Sign UP',
              toUpper: false),
              // const SizedBox(height: 20,),
              // captionText('Or login with'),
              // const SizedBox(height: 20,),
              // const Row(mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     CircleAvatar(
              //       radius: 24,
              //       backgroundColor: defaultColor,
              //       child: Image(
              //         image: AssetImage('assets/apple.png'),
              //         height: 16,
              //         width: 13.5,
              //         color: Colors.white,
              //       ),
              //     ),
              //     SizedBox(width: 25,),
              //     CircleAvatar(
              //       radius: 24,
              //       backgroundColor: defaultColor,
              //       child: Image(
              //         image: AssetImage('assets/google.png'),
              //         height: 16,
              //         width: 13.5,
              //         color: Colors.white,
              //       ),
              //     ),
              //
              //   ],)

            ],
          ),
        ),
      )

    );
  }
}
