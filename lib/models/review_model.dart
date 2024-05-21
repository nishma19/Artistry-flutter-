import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final double rating;
  final String reviewText;
  final Timestamp timestamp;

  Review({
    required this.rating,
    required this.reviewText,
    required this.timestamp,
  });

  // Convert Review object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'rating': rating,
      'reviewText': reviewText,
      'timestamp': timestamp,
    };
  }

  // Create a Review object from a Firestore document snapshot
  factory Review.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Review(
      rating: snapshot.data()!['rating'],
      reviewText: snapshot.data()!['reviewText'],
      timestamp: snapshot.data()!['timestamp'],
    );
  }
}
