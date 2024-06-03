import 'package:artistry/screens/common/addinfo.dart';
import 'package:artistry/screens/common/validator.dart';
import 'package:artistry/screens/user/end_user/user_forgot_password.dart';
import 'package:artistry/screens/user/end_user/user_front_page.dart';
import 'package:artistry/services/auth_service.dart';
import 'package:artistry/services/user_service.dart';
import 'package:artistry/widgets/appbutton.dart';
import 'package:flutter/material.dart';


import '../user/end_user/user_register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool visible = true;

  final _loginKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully Logged in!'),
        duration: Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Color(0xffFFF5E9),
      ),
      body: Container(
        color: Color(0xffFFF5E9),

        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Form(
          key: _loginKey,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 70.0,bottom: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [

                          Text("A",style: TextStyle(color: Color(0xffD77272),fontSize:20,fontWeight: FontWeight.w400),),SizedBox(width: 15,),
                          Text("R",style: TextStyle(color: Color(0xffD77272),fontSize:20,fontWeight: FontWeight.w400),),SizedBox(width: 15,),
                          Text("T",style: TextStyle(color: Color(0xffD77272),fontSize:20,fontWeight: FontWeight.w400),),SizedBox(width: 15,),
                          Text("I",style: TextStyle(color: Color(0xffD77272),fontSize:20,fontWeight: FontWeight.w400),),SizedBox(width: 15,),
                          Text("S",style: TextStyle(color: Color(0xffD77272),fontSize:20,fontWeight: FontWeight.w400),),SizedBox(width: 15,),
                          Text("T",style: TextStyle(color: Color(0xffD77272),fontSize:20,fontWeight: FontWeight.w400),),SizedBox(width: 15,),
                          Text("R",style: TextStyle(color: Color(0xffD77272),fontSize:20,fontWeight: FontWeight.w400),),SizedBox(width: 15,),
                          Text("Y",style: TextStyle(color: Color(0xffD77272),fontSize:20,fontWeight: FontWeight.w400),),SizedBox(width: 15,),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(


                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        return Validator.validateEmail(value!);
                      },
                      controller: _emailController,
                      cursorColor: Color(0xffD77272),
                      decoration: InputDecoration(


                        contentPadding: EdgeInsets.all(13),
                        hintText: "Enter email",
                        // label: Text("Email"),
                        hintStyle: themeData.textTheme.labelSmall,
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.transparent)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xffD77272),
                              width: 1.2,
                            )),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xFFB3261E)),),
                        prefixIcon: Icon(Icons.email,color: Colors.black54,),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        return Validator.validatePassword(value!);
                      },
                      obscureText: visible,
                      controller: _passwordController,
                      cursorColor: Color(0xffD77272),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(13),
                          hintText: "Password",
                          filled: true,
                          fillColor: Colors.white,

                          hintStyle: themeData.textTheme.labelSmall,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1.2,
                          )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Color(0xffD77272),
                                width: 1.2,
                              )),
                          prefixIcon: Icon(Icons.lock,color: Colors.black54,),
                          suffixIcon: IconButton(
                            color: Colors.black,
                              hoverColor: Color(0xffD77272),
                              onPressed: () {
                                setState(() {
                                  visible = !visible;
                                });
                              },
                              icon: visible == true
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility))),
                    ),
                    SizedBox(
                      height:20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, 'forgot');
                          },
                          child: Text(
                            "Forgot Password?",
                            style: themeData.textTheme.titleSmall,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: AppButton(
                        height: 48,
                          width: 250,
                          color: Color(0xffD77272),


                          onTap: ()async{
                        if(_loginKey.currentState!.validate()){
                          AuthService _authService = AuthService();

                          final userData = await _authService.loginUser(
                              _emailController.text, _passwordController.text);

                          if (userData != null) {
                            if (userData['role'] == 'user') {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                'navbar',
                                    (route) => false,
                              );
                            } else if (userData['role'] == "artist") {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                'artistnavbar',
                                    (route) => false,
                              );
                            }else if (userData['role'] == "admin")  {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                'admindashboard',
                                    (route) => false,
                              );
                            }
                          }else{




    showDialog(context: context, builder: (context){
    return AlertDialog(

    content: Container(
    height: 100,
    child: Column(
    children: [
    Text("Error, please wait or contact admin ")
    ],
    ),),);});

                          }
                        }
                          }, child:Text("Login",style: TextStyle(color: Colors.white),) )
                    ),

                    SizedBox(height: 80,),
                    Center(
                      child: Column(
                        children: [
                          Text("If you don't have an account",style: TextStyle(color: Color(0xffD77272),fontSize: 15,fontWeight: FontWeight.w400),),

                          SizedBox(width: 10,),
                          InkWell(
                           onTap: (){
                            Navigator.pushNamed(context, 'registertab');
                           },
                            child: Text("Create an account",style: themeData.textTheme.titleSmall),

                          ),
                        ],
                      ),
                    ),SizedBox(height: 10,),

                  ],

                ),

              ),
            ],

          ),
        ),
      ),
    );
  }


}
