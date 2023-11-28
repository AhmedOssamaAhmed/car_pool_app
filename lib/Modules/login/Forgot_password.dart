import 'package:carpoolcustomersversion/Shared/colors/common_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Shared/components/components.dart';
import 'Login.dart';
import 'firebase_forget_password.dart';

class RestPassword extends StatelessWidget {
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultappbar("Reset Password"),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(width: double.infinity,
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 241,),
                defaultTextInputField(controller: emailController,
                    type: TextInputType.emailAddress,
                    hint: 'Sarahsmith@gmail.com',
                    title: 'Email'),
                SizedBox(height: 230,),
                defaultButton(
                  function: ()
                  {
                    String email = emailController.text.trim();
                    if(email.isNotEmpty)
                    {
                      resetPassword(email,context);
                    }
                    else
                    {
                      showToast(text: "Please enter your email", error: true);
                    }
                    print("out");
                  },
                  text: 'Send reset code',
                  fontSize: 12,
                  radius: 24,
                ),
                SizedBox(height: 10,),
                InkWell(child:
                captionText('Login',),
                  onTap: (){navigateTo(context, Login());},)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
