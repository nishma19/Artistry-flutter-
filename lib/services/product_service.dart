import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/product_model.dart';

class ProductService {


 Future<String> uploadImageProduct(File imageFile) async {
    try {
      // Create a unique filename for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Get a reference to the Firebase Storage location
      Reference storageReference = FirebaseStorage.instance.ref().child('products/$fileName');

      // Upload the image to Firebase Storage
      UploadTask uploadTask = storageReference.putFile(imageFile);

      // Get the download URL of the uploaded image
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return ''; // Return empty string in case of error
    }
  }

 Future<void> saveProduct(Product product) async {
    try {
      // Add the product data to Firestore
      await FirebaseFirestore.instance.collection('products').add(product.toJson());
      print('Product saved to Firestore');
    } catch (e) {
      print('Error saving product to Firestore: $e');
      throw e;
    }
  }


 Future<List<String>> getProductIds() async {
   try {
     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('products').get();
     List<String> productIds = [];
     querySnapshot.docs.forEach((doc) {
       // Extract the id field from each document and add it to the list
       productIds.add(doc.id);
     });
     return productIds;
   } catch (e) {
     print('Error fetching product ids: $e');
     throw e;
   }
 }



 Future<List<Product>> getProducts() async {
   try {
     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('products').get();
     return querySnapshot.docs.map((doc) => Product.fromJson(doc)).toList();
   } catch (e) {
     print('Error fetching products: $e');
     throw e;
   }
 }


 Future<Map<String, dynamic>?> getProductById(String productId) async {
   try {
     // Query Firestore to get the product details by productId
     DocumentSnapshot productSnapshot = await FirebaseFirestore.instance.collection('products').doc(productId).get();
     if (productSnapshot.exists) {
       // Convert the product snapshot data to a Map
       Map<String, dynamic> productData = productSnapshot.data() as Map<String, dynamic>;
       return productData;
     } else {
       print('Product not found with id: $productId');
       return null;
     }
   } catch (e) {
     print('Error fetching product details: $e');
     return null;
   }
 }


}