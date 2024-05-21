import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? id;
  final String name;
  final double price;
  final String description;
  final String serviceId;
  final String serviceName;

  final String imageUrl;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.serviceId,
    required this.serviceName,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'artistId': serviceId,
      'artistName': serviceName,
      'imageUrl': imageUrl,
    };
  }

  factory Product.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      description: json['description'],
      serviceId: json['artistId'],
      serviceName: json['artistName'],
      imageUrl: json['imageUrl'],
    );
  }
}
