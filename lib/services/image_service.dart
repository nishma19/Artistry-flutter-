import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/image_model.dart';

class ImageService {
  static Future<String?> uploadImage(File imageFile) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('images/${DateTime.now().toString()}');
      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask;
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }


  static Future<void> saveImageUrl(String uid, String imageUrl) async {
  try {
  // Update the 'imageUrl' field in the user's document in Firestore
  await FirebaseFirestore.instance
      .collection('artist')
      .doc(uid)
      .update({'imageUrl': imageUrl});
  print('Image URL saved to Firestore: $imageUrl');
  } catch (e) {
  // Handle any errors that occur during the saving process
  print('Error saving image URL to Firestore: $e');
  throw e; // Re-throw the error to handle it in the calling code if needed
  }
  }


 static Future<void> saveImageUrlUser(String uid, String imageUrl) async {
    try {
      // Update the 'imageUrl' field in the user's document in Firestore
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .update({'imageUrl': imageUrl});
      print('Image URL saved to Firestore: $imageUrl');
    } catch (e) {
      // Handle any errors that occur during the saving process
      print('Error saving image URL to Firestore: $e');
      throw e; // Re-throw the error to handle it in the calling code if needed
    }
  }

   static Future<String> uploadImageProduct(File imageFile) async {
    try {
      // Create a unique filename for the image
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // Get a reference to the Firebase Storage location
      Reference storageReference = FirebaseStorage.instance.ref().child('images/$fileName');

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


  }

