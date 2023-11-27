import 'package:carpoolcustomersversion/Modules/register/firebase_signup.dart';
import 'package:flutter/material.dart';
import '../../Shared/colors/common_colors.dart';
import '../../Shared/components/components.dart';
import '../login/Forgot_password.dart';
import '../login/Login.dart';

class SignUp extends StatelessWidget {
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: defaultappbar("Sign Up"),
          body: SafeArea(child:Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  defaultTextInputField(
                    controller: firstNameController,
                    type: TextInputType.name,
                    hint: 'Sarah',
                    title: 'First name',
                  ),
                  SizedBox(height: 40,),
                  defaultTextInputField(
                    controller: lastNameController,
                    type: TextInputType.name,
                    hint: 'Smith',
                    title: 'Last name',
                  ),
                  SizedBox(height: 40,),
                  defaultTextInputField(
                    controller: emailController,
                    type: TextInputType.emailAddress,
                    hint: 'Sarahsmith@gmail.com',
                    title: 'Email',
                  ),
                  SizedBox(height: 40,),
                  defaultTextInputField(
                    controller: passwordController,
                    type: TextInputType.visiblePassword,
                    hint: '*************',
                    title: 'Password',
                    safe: true,
                  ),
                  SizedBox(height: 40,),
                  defaultButton(radius:24 ,
                      fontSize: 12,
                      function: () async {
                        {
                          String firstName = firstNameController.text.trim();
                          String lastName = lastNameController.text.trim();
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();

                          if (firstName.isEmpty ||
                              lastName.isEmpty ||
                              email.isEmpty ||
                              password.isEmpty )
                          {
                            print("enter valid data");
                            showToast(
                              text: 'please enter a valid data',
                              error: true,
                            );

                            return;
                          }else if (!email.endsWith('@eng.asu.edu.eg')) {
                            print("Please use an email with the domain '@eng.asu.edu.eg'");
                            showToast(text: "Please use an email with the domain '@eng.asu.edu.eg'",
                                error: true
                            );
                          }else if (password.length < 8 || !RegExp(r'^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9]).*$').hasMatch(password)) {
                            print("Password must be at least 8 characters long and contain uppercase, lowercase, and numeric characters.");
                            showToast(text: "Password must be at least 8 characters long and contain uppercase, lowercase, and numeric characters.",
                                error: true
                            );
                          }
                          else{
                            await signUp(email, firstName, lastName, password);
                            navigateAndFinish(context, Login());

                          }
                        };
                      },
                      text: 'Sign Up',
                      toUpper: false),
                  SizedBox(
                    height: 20,
                  ),
                  defaultButton(radius: 24,
                      background: mainAppColor!,
                      textcolor: defaultColor,
                      function: (){
                        navigateTo(context, Login());
                      },
                      text: ' Login',
                      toUpper: false),
                  SizedBox(height: 10,),
                  InkWell(child:
                  captionText('Forgot your password ?',),
                    onTap: (){navigateTo(context, RestPassword());},)


                ],
              ),
            ),
          ))
      );
  }
}
