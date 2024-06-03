import 'dart:io';

import 'package:artistry/models/media_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MediaService {
  final CollectionReference _mediaCollection =
  FirebaseFirestore.instance.collection('media');

  // Add a new media item
  Future<void> addMedia(File imageFile, String userId) async {
    // Generate unique ID for the media
    final String id = DateTime.now().millisecondsSinceEpoch.toString();

    // Upload image to Firebase Storage
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('media')
        .child('$id.jpg');
    final uploadTask = storageRef.putFile(imageFile);
    final TaskSnapshot storageSnapshot = await uploadTask;
    final String downloadUrl = await storageSnapshot.ref.getDownloadURL();

    // Add media document to Firestore
    await _mediaCollection.add({
      'id': id,
      'imagePath': downloadUrl,
      'status': 'active', // Example status, you can change as needed
      'created_at': FieldValue.serverTimestamp(), // Use Firestore server timestamp
      'userId': userId, // Add this line
    });
  }

  // Retrieve a media item by its ID
  Future<List<String>> fetchMediaUrls(String userId) async {
    final QuerySnapshot snapshot = await _mediaCollection
        .where('userId', isEqualTo: userId)
        // .orderBy('created_at', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc['imagePath'] as String).toList();
  }


  Future<List<MediaModel>> fetchMediaModels(String userId) async {
    final QuerySnapshot snapshot = await _mediaCollection
        .where('userId', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .get();

    return snapshot.docs.map((doc) => MediaModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }
}




// Update a media item (not implemented in this example)
// Delete a media item (not implemented in this example)

