import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:artistry/models/user_model.dart';

class UserDetailScreen extends StatelessWidget {
  final UserModel user;

  UserDetailScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    // Format the createdAt timestamp
    String formattedDate = '';
    if (user.createdAt != null) {
      formattedDate = DateFormat('dd MMMM yyyy, HH:mm:ss').format(user.createdAt!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(user.name ?? 'User Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the image
            Center(
              child: user.imageUrl != null
                  ? Image.network(
                user.imageUrl!,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              )
                  : Placeholder(
                fallbackHeight: 200,
                fallbackWidth: 200,
              ),
            ),
            SizedBox(height: 20),
            // Display user details
            Text('Name: ${user.name}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Email: ${user.email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Phone: ${user.phone}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Address: ${user.address}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Created At: $formattedDate', style: TextStyle(fontSize: 18)),
            // Add more user details here as needed
          ],
        ),
      ),
    );
  }
}
