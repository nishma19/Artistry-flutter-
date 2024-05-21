import 'package:artistry/models/review_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Function to save review data to Firestore
Future<void> saveReviewToFirestore(Review review) async {
  try {
    // Get a reference to the reviews collection
    CollectionReference reviews = FirebaseFirestore.instance.collection('reviews');

    // Convert Review object to a Map
    Map<String, dynamic> reviewData = review.toMap();

    // Add a new document with the review data
    await reviews.add(reviewData);
  } catch (e) {
    print('Error saving review: $e');
    throw e; // Throw the error so it can be handled elsewhere
  }
}
