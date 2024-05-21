import 'package:artistry/widgets/appbutton.dart';
import 'package:artistry/widgets/customtextformfield.dart';
import 'package:flutter/material.dart';
class UserForgotPassword extends StatefulWidget {
  const UserForgotPassword({super.key});

  @override
  State<UserForgotPassword> createState() => _UserForgotPasswordState();
}

class _UserForgotPasswordState extends State<UserForgotPassword> {
  TextEditingController _email=TextEditingController();
  @override
  Widget build(BuildContext context) {
    final themeData=Theme.of(context);
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Color(0xffFFF5E9),
    ),
    body: Container(
    color: Color(0xffFFF5E9),

    height: double.infinity,
    width: double.infinity,
    padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 60,),
          Text("Forgot Password ?",style: themeData.textTheme.displayLarge,),
          SizedBox(height: 100,),
          CustomTextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return "email is mandatory";
                }
              },
              controller: _email, hintText: "Enter a Email"),
          SizedBox(height: 30,),
          AppButton(
              height:48,
              width: 250,
              color: Color(0xffD77272),
              onTap: (){}, child: Text("Reset",style: TextStyle(color: Colors.white),)),
        ],
      ),
    ),

    );
  }
}
