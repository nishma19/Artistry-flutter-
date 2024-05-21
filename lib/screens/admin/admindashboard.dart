import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildMenuItem(context, 'Login', Icons.login),
            buildMenuItem(context, 'User Management', Icons.people),
            buildMenuItem(
                context, 'Service Provider Management', Icons.business),
            buildMenuItem(
                context, 'Booking and Appointment Management', Icons.event),
            buildMenuItem(context, 'Subscription Management', Icons.subscriptions),
            buildMenuItem(
                context, 'Teaching Management', Icons.school),
            buildMenuItem(
                context, 'Payment and Billing Management', Icons.payment),
            buildMenuItem(
                context, 'Review and Rating Management', Icons.star),
            buildMenuItem(context, 'FAQ, Terms of Service', Icons.question_answer),
            buildMenuItem(context, 'User Support', Icons.support),
            buildMenuItem(context, 'Privacy and Compliance', Icons.security),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, String title, IconData icon) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        onTap: () {
          // Navigate to corresponding module
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Navigating to $title')),
          );
        },
      ),
    );
  }
}