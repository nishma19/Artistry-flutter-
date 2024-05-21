import 'package:artistry/models/artist_model.dart';
import 'package:artistry/screens/common/login_page.dart';
import 'package:artistry/services/artist_service.dart';
import 'package:artistry/widgets/appbutton.dart';
import 'package:artistry/widgets/customtextformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ArtistRegisterPage extends StatefulWidget {
  const ArtistRegisterPage({super.key});

  @override
  State<ArtistRegisterPage> createState() => _ArtistRegisterPageState();
}

class _ArtistRegisterPageState extends State<ArtistRegisterPage> {

  TextEditingController _fullname=TextEditingController();

  TextEditingController _email=TextEditingController();
  TextEditingController _mobileno=TextEditingController();
  TextEditingController _category=TextEditingController();
  TextEditingController _businessDetails=TextEditingController();
  TextEditingController _priceController=TextEditingController();
  TextEditingController _password=TextEditingController();

  bool visible=true;
  bool _checked=false;
  final _registerkey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeData=Theme.of(context);


    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: EdgeInsets.all(20),
      color: Color(0xffFFF5E9),
      child: Form(
        key: _registerkey,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [

                  SizedBox(height: 20,),
                  CustomTextFormField(
                    controller: _fullname,
                    hintText: "Enter Fullname",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Name is mandatory";
                      }
                    },
                  ),SizedBox(height: 10,),

                  CustomTextFormField(
                    // Type: TextInputType.emailAddress,

                    validator: (value) {
                      if (value!.isEmpty) {
                        return "email is mandatory";
                      }
                    },
                    controller: _email,
                    hintText: "Enter a Email",
                  ),SizedBox(height: 10,),
                  CustomTextFormField(
                    // keyboardType: TextInputType.phone,
                    controller: _mobileno,
                    hintText: " Mobile number",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "mobile Number is mandatory";
                      }
                    },

                  ),SizedBox(height: 10,),


                  CustomTextFormField(
                    // keyboardType: TextInputType.phone,
                    controller: _category,
                    hintText: " Category",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Category is mandatory";
                      }
                    },

                  ),SizedBox(height: 10,),



                  CustomTextFormField(
                    controller: _businessDetails,
                    hintText: "Business Details",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "this field must be a performer or crafter";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10,),
                  CustomTextFormField(
                    controller: _priceController,
                    hintText: "Price",
                    // keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Price is mandatory";
                      }
                      // Additional validation can be added for price format
                    },
                  ),



                  SizedBox(height: 10,),

                  CustomTextFormField(
                    controller: _password,
                    hintText: "Password",
                    obscureText: visible,

                    validator: (value){
                      if(value!.isEmpty){
                        return"Password is mandatory";
                      }
                      if(value!.length<6){
                        return"Password should be atleast min 6 characters";
                      }
                      return null;
                    },

                  ),SizedBox(height: 10,),



                  SizedBox(height: 10,),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Have an account ?",style:  TextStyle(color: Color(0xffD77272),fontSize: 15,fontWeight: FontWeight.w400,)
                      ),SizedBox(width: 5,),
                      InkWell( onTap: (){
                        setState(() {
                          Navigator.pushNamed(context, 'login');
                        });
                      },
                          child: Text("Login",style: themeData.textTheme.titleSmall,))
                    ],
                  ),SizedBox(height: 20,),
                  Row(
                    children: [
                      Checkbox(
                          activeColor: Color(0xffD77272),
                          checkColor: Colors.white,
                          value: _checked, onChanged: (value){
                        setState(() {
                          _checked=!_checked;

                        });
                      }),
                      Text("I agree the terms and condition",style: TextStyle(color: Color(0xffD77272),fontWeight: FontWeight.w600,),)
                    ],
                  ),
                  _checked?AppButton(
                      height: 48,
                      width: 250,
                      color: const Color(0xffD77272),
                      onTap: () async {
                        try {
                          if (_registerkey.currentState!.validate()) {
                            Artist user = Artist(
                              price: double.parse(_priceController.text),
                              imageUrl: "",
                              name: _fullname.text,
                              email: _email.text,
                              phone: _mobileno.text,
                              address: "",
                              businessDetails: _businessDetails.text,
                              links: "",
                              password: _password.text,
                              category: _category.text,
                              role: "artist",
                              // createdAt: DateTime.now(),
                              // status: 1,
                            );
                            ArtistService userService = ArtistService();
                            final res = await userService.registerUser(user);
                            if (res == "") {
                              Navigator.pushReplacementNamed(context, 'login');
                            }
                          }
                        } on FirebaseAuthException catch (e) {
                          print('Firebase Auth Exception: ${e.message}');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Firebase Auth Error: ${e.message}"),
                            ),
                          );
                        } catch (e) {
                          print('Error: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              content: Text("Error: $e"),
                            ),
                          );
                        }
                      }, child: Text("Register",style: TextStyle(color: Colors.white),))
                      :AppButton(
                      height: 48,
                      width: 250,
                      color: Colors.grey,
                      onTap: (){
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              elevation: 5.0,
                              duration: Duration(seconds: 5),
                              backgroundColor: Color(0xFFB3261E),
                              content: Text("Accept the terms and condition"),),
                          );
                        });
                      },
                      child: Text("Register")),

                ],
              ),
            ),
          ],
        ),
      ),


    );
  }
}