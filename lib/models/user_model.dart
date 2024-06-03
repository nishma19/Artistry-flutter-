

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  // String?id;
  // String?title;
  // String?body;
  //
  //
  // DateTime?updatedAt;
  String? uid;
  String? name;
  String?address;
  String?imageUrl;
  String? email;
  String? password;
  // String? conformpassword;

  String?phone;
  String? role;
  int? status;
  DateTime? createdAt;

  UserModel({
    // this.id,
    // this.title,
    // this.body,
    // this.updatedAt,
    this.uid,
    this.address,
    this.name,
    this.imageUrl,
    this.email,
    this.password,
    // this.conformpassword,
    this.phone,
    this.createdAt,
    this.status,
    this.role});


  // fromJson
// Convert DocumentSnapshot to UserModel object
  factory UserModel.fromJson(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: data['id'],

      // title: data['title'],
      // body: data['body'],
      // updatedAt: (data['updatedAt']as Timestamp).toDate(),
      name: data['name'],
      // userName: data['userName'],
      email: data['email'],
      password: data['password'],
      imageUrl: data['imageUrl'],

      role: data['role'],
      phone: data['phone'],
      address: data['address'],
      status: data['status'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert UserModel object to Map
  Map<String, dynamic> toMap() {
    return {
      // 'title':title,
      // 'body':body,
      // 'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'name': name,
      'address':"",
      'imageUrl':imageUrl,
      'email': email,
      'password': password,
      'role': role,
      'phone': phone,
      'id':uid,
      'status': status,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }


}
