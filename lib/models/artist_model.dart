import 'package:cloud_firestore/cloud_firestore.dart';

class Artist {
  String? id;
  final String email;
  final String password;
  final String? businessDetails;
  final String name;
  final String?links;
  final String phone;
  final String category;
  final String address;
  final String role;
  final String imageUrl;
   var price;
  // int? status;
  // DateTime? createdAt;

  Artist({
    this.id,
    required this.email,
    required this.password,
    required this.businessDetails,
    required this.name,
    required this.imageUrl,
    required this.links,
    required this.phone,
    required this.category,
    required this.address,
    required this.role,
    required this.price,
    // this.createdAt,
    // this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
      'category': category,
      'address': "",
      'businessDetails': businessDetails,
      'links': "",
      'role':role,
      'imageUrl':imageUrl,
      'price': price,
      // 'status': status,
      // 'createdAt': createdAt ?? FieldValue.serverTimestamp(),

    };
  }

  factory Artist.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
    return Artist(
      imageUrl: json['imageUrl'],
      role: json['role'],
      id: json['id'],
      email: json['email'],
      password: json['password'],
      name: json['name'],
      phone: json['phone'],
      category: json['category'],
      address: json['address'],
      businessDetails: json['businessDetails'],
      links: json['links'],
      price: json['price'] ?? 0.0,
      // status: json['status'],
      // createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
}
