import 'package:carpoolcustomersversion/home/bottom_navigation.dart';
import 'package:carpoolcustomersversion/home/routes.dart';
import 'package:flutter/material.dart';
import '../../Shared/colors/common_colors.dart';
import '../../Shared/components/components.dart';
import '../register/signup.dart';
import 'Forgot_password.dart';

class Login extends StatelessWidget {
  String? email;
  String? password;
  Login({this.email, this.password});

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if(email != null && password !=null)
    {
      emailController.text=email!;
      passwordController.text=password!;
    }
        return Scaffold(
            appBar: defaultappbar("Login"),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 50,),
                      Logo(),
                      const SizedBox(height: 20,),
                      defaultTextInputField(controller: emailController,
                          type: TextInputType.emailAddress,
                          hint: 'Sarahsmith@gmail.com',
                          title: 'Email'),
                      const SizedBox(height: 30,),
                      defaultTextInputField(controller: passwordController,
                        type: TextInputType.visiblePassword,
                        safe: true,
                        title: 'Password',
                        hint: '***************',),
                      const SizedBox(height: 20,),
                      defaultButton(radius:24 ,
                          fontSize: 12,
                          function: ()
                          {
                            String email = emailController.text;
                            String password = passwordController.text;
                            if(email.isEmpty || password.isEmpty){
                              print('please enter a valid data');
                              // showToast(text: 'please enter a valid data', error: true);
                              return;
                            }
                            else{
                              navigateAndFinish(context, bottom_navigation());
                            }

                          },
                          text: 'login',
                          toUpper: true),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultButton(radius: 24,
                          background: mainAppColor!,
                          textcolor: defaultColor,
                          function: (){
                            navigateTo(context, SignUp());
                          },
                          text: 'Sign UP',
                          toUpper: false),
                      const SizedBox(height: 10,),
                      InkWell(child:
                      captionText('Forgot your password ?',),
                        onTap: (){navigateTo(context, RestPassword());},)

                    ],
                  ),
                ),
              ),
            )
        );

}
}
