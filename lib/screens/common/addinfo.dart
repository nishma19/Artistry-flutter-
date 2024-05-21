import 'dart:io';
import 'package:artistry/models/image_model.dart';
import 'package:artistry/screens/user/end_user/bottom_navigation.dart';
import 'package:artistry/screens/user/Artist_user/artist_profile.dart';
import 'package:artistry/screens/user/end_user/user_homepage.dart';
import 'package:artistry/services/artist_service.dart';
import 'package:artistry/services/image_service.dart';
import 'package:artistry/services/user_service.dart';
import 'package:artistry/widgets/appbutton.dart';
import 'package:artistry/widgets/apptext.dart';
import 'package:artistry/widgets/customtextformfield.dart';
import 'package:artistry/widgets/mydivider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class AddInfoPage extends StatefulWidget {
  final String? userType;
  final String? uid;
  final String? name;
  final String? address;
  final String? email;
  final String? phone;
  var price;
  final String? links;

AddInfoPage({
    Key? key,
    this.phone,
    this.email,
    this.userType,
    this.uid,
    this.name,
    this.address,
    this.price,
    this.links,
  }) : super(key: key);

  @override
  State<AddInfoPage> createState() => _AddInfoPageState();
}

class _AddInfoPageState extends State<AddInfoPage> {
  File? _image;
  TextEditingController _firstname = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _links = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phoneno = TextEditingController();
  TextEditingController _price = TextEditingController();
  String? selectedItem;
  String? selectedVal;
  List<String> ArtistCategory = [
    "Dancer",
    "Singer",
    "Musician",
    "Comedian",
    "Magician",
    "Drawing",
    "hamper",
  ];
  List<String> UserType = [
    "Customer",
    "Artist",
  ];
  final _addinfokey = GlobalKey<FormState>();

  @override
  void initState() {
    setData();
    super.initState();
  }

  setData() {
    selectedItem = widget.userType;

    if (selectedItem == "user") {
      _firstname.text = widget.name!;
      _address.text = widget.address!;
      _email.text = widget.email!;
      _phoneno.text = widget.phone!;
    } else {
      _firstname.text = widget.name!;
      _address.text = widget.address!;
      _email.text = widget.email!;
      _phoneno.text = widget.phone!;
      if (widget.price != null) {
        _price.text = widget.price!.toString();
      }
      _links.text = widget.links ?? '';
    }
  }

  Future<void> _saveButtonTap() async {
    if (_addinfokey.currentState!.validate()) {
      if (_image != null) {
        final imageUrl = await ImageService.uploadImage(_image!);
        if (imageUrl != null) {
          if (widget.uid != null) {
            print(widget.uid);
            print(selectedItem);
           if(selectedItem=='user'){
             await ImageService.saveImageUrlUser(widget.uid!, imageUrl);
           }else{
             await ImageService.saveImageUrl(widget.uid!, imageUrl);
           }// Safe to use ! here
            print('Image uploaded to Firebase Storage: $imageUrl');
          } else {
            print('Error: User ID (uid) is null');
          }
        }
      }
     Navigator.pop(context);
    }
  }


  Future<void> _selectImage() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        _image = File(imageFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.uid);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Your Info",
          style: TextStyle(
            color: Colors.red[900],
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xffFFF5E9),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Form(
          key: _addinfokey,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    MyDivider(),
                    Center(
                      child: GestureDetector(
                        onTap: _selectImage,
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Color(0xffFFF5E9),
                          child: _image != null
                              ? ClipOval(
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              width: 70,
                              height: 70,
                            ),
                          )
                              : Icon(
                            Icons.camera_alt_sharp,
                            color: Color(0xffD77272),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    InkWell(onTap: _saveButtonTap,
                        child: AppText(data: "save",color: Colors.blue,)),

                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                      child: CustomTextFormField(
                        controller: _firstname,
                        hintText: "Name",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                      child: CustomTextFormField(
                        maxlines: 3,
                        controller: _address,
                        hintText: "Enter the address",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      child: CustomTextFormField(
                        controller: _phoneno,
                        hintText: "Phone number",
                      ),
                    ),



                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 20, right: 20, bottom: 5),
                      child: CustomTextFormField(
                        readOnly: true,
                        controller: _email,
                        hintText: "Email",
                      ),
                    ),
                    Visibility(
                      visible: selectedItem == 'artist',
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 5),
                        child: Column(
                          children: [

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3.0),
                              child: CustomTextFormField(
                                controller: _price,
                                hintText: "price",
                              ),
                            ),

                            Padding(

                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3.0),
                              child: CustomTextFormField(
                                controller: _links,
                                hintText: "Add Links",
                              ),
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                    AppButton(
                        height: 48,
                        width: 250,
                        color: Color(0xffD77272),
                        onTap: () async {
                          if (_addinfokey.currentState!.validate()) {

                            if (selectedItem == 'user') {
                              UserService().updateUser(
                                  widget.uid,
                                  _firstname.text,
                                  _address.text,
                                  _phoneno.text);

                            }
                            // If Artist is selected, navigate to ArtistHomePage
                            else if (selectedItem == 'artist') {
                              ArtistService().updateArtist(
                                widget.uid,
                                _firstname.text,
                                _address.text,
                                _phoneno.text,
                                // _businessdetails.text,
                                _links.text,
                               double.parse( _price.text)

                              );

                            }
                          }
                          Navigator.pop(context);
                        },
                        child: Text(
                          "continue",
                          style: TextStyle(color: Colors.white),
                        ))
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