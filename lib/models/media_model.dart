import 'package:cloud_firestore/cloud_firestore.dart';

class MediaModel {
  final String id;
  final String imagePath;
  final String status;
  final DateTime createdAt;
  final String userId; // Add this line

  MediaModel({
    required this.id,
    required this.imagePath,
    required this.status,
    required this.createdAt,
    required this.userId, // Add this line
  });

  // Deserialize JSON to Media object
  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['id'],
      imagePath: json['imagePath'],
      status: json['status'],
      createdAt: (json['created_at'] as Timestamp).toDate(), // Convert Firestore timestamp to DateTime
      userId: json['userId'], // Add this line
    );
  }

  // Serialize Media object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'status': status,
      'created_at': createdAt, // Ensure correct formatting for Firestore
      'userId': userId, // Add this line
    };
  }
}
