import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import 'package:artistry/services/product_service.dart';
import 'package:artistry/widgets/appbutton.dart';
import 'package:artistry/widgets/apptext.dart';
import 'package:artistry/widgets/customtextformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/product_model.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  File? _image;
  TextEditingController _productName = TextEditingController();
  TextEditingController _productPrice = TextEditingController();
  TextEditingController _productDesc = TextEditingController();
  final _productkey = GlobalKey<FormState>();
  ProductService _productService = ProductService();

  Future<void> _selectImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  var userId;
  var userName;

   getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    userName = _pref.getString('name');

    setState(() {
      // userName = _pref.getString('name');
    });
  }

  getId() async {
    userId = await FirebaseAuth.instance.currentUser!.uid;
    setState(() {});
  }

  Future<void> _saveProduct() async {
    var productid = Uuid().v1();
    // Validate form fields
    if (_productkey.currentState!.validate()) {
      // Upload image if selected
      if (_image != null) {
        final imageUrl = await _productService.uploadImageProduct(_image!);
        // If image upload is successful, proceed to save product with image URL
        if (imageUrl.isNotEmpty) {
          // Create a Product object with form data and image URL
          Product product = Product(
            id: productid,
            name: _productName.text,
            price: double.parse(_productPrice.text),
            description: _productDesc.text,
            imageUrl: imageUrl,
            serviceId: userId,
            serviceName: userName ?? '',
          );

          _productService.saveProduct(product);


          // _productName.clear();
          // _productPrice.clear();
          // _productDesc.clear();

          // Show snackbar for successfully adding the product
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Product added successfully!'),
            ),
          );
        }
      } else {
        // If no image is selected, save product without image URL
        // Create a Product object with only form data
        Product product = Product(
          id: productid,
          imageUrl: "",
          name: _productName.text,
          price: double.parse(_productPrice.text),
          description: _productDesc.text,
          serviceId: userId,
          serviceName: userName ?? '',
        );

        // Call your service to save the product to Firestore
        _productService.saveProduct(product);



        // _productName.clear();
        // _productPrice.clear();
        // _productDesc.clear();

        // Show snackbar for successfully adding the product
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Product added successfully!'),
          ),
        );
      }
      _productName.clear();
      _productPrice.clear();
      _productDesc.clear();

    }
  }



  @override
  void initState() {
    getId();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(userId);
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          data: "Add Product",
          color: Color(0xFFB3261E),
          size: 20,
        ),
        backgroundColor: Color(0xffFFF5E9),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Form(
          key: _productkey,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      CustomTextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter product name";
                            }
                          },
                          controller: _productName,
                          hintText: "Product Name"),
                      SizedBox(height: 10),
                      CustomTextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "enter product price";
                            }
                          },
                          controller: _productPrice,
                          hintText: "Product Price"),
                      SizedBox(height: 10),
                      CustomTextFormField(
                          maxlines: 4,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return " enter product Description";
                            }
                          },
                          controller: _productDesc,
                          hintText: "Description"),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: _selectImage,
                        child: Center(
                          child: _image == null
                              ? CircleAvatar(
                            radius: 35,
                            backgroundColor: Color(0xffFFF5E9),
                            child: Icon(
                              Icons.camera_alt_sharp,
                              color: Color(0xffD77272),
                            ),
                          )
                              : CircleAvatar(
                            radius: 35,
                            backgroundImage: FileImage(_image!),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      AppButton(
                          height: 48,
                          width: 250,
                          color: Color(0xffD77272),
                          onTap: _saveProduct,
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
