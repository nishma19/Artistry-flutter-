import 'package:artistry/screens/admin/artist_details_screen.dart';
import 'package:artistry/screens/admin/user_details.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Import intl package

import 'package:artistry/models/artist_model.dart';
import 'package:artistry/models/user_model.dart'; // Import UserModel


class BookingListScreen extends StatefulWidget {
  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  Future<List<Map<String, dynamic>>> _fetchBookings() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('booking_status').get();
      List<Map<String, dynamic>> bookings = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
      return bookings;
    } catch (e) {
      print('Error fetching bookings: $e');
      return [];
    }
  }

  Future<Artist?> _fetchArtistDetails(String serviceId) async {
    try {
      DocumentSnapshot docSnapshot =
      await FirebaseFirestore.instance.collection('artist').doc(serviceId).get();
      if (docSnapshot.exists) {
        return Artist.fromJson(docSnapshot);
      }
    } catch (e) {
      print('Error fetching artist details: $e');
    }
    return null;
  }

  Future<UserModel?> _fetchUserDetails(String userId) async {
    try {
      DocumentSnapshot docSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (docSnapshot.exists) {
        return UserModel.fromJson(docSnapshot);
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Color(0xFFB3261E)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookings found.'));
          } else {
            List<Map<String, dynamic>> bookings = snapshot.data!;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                var booking = bookings[index];
                var bookingId = booking['bookingId'];
                var status = booking['status'];
                var bookingDate = (booking['bookingDate'] as Timestamp).toDate();
                var location = booking['location'];
                var serviceId = booking['serviceId'];
                var userId = booking['userId'];

                // Format the date
                String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(bookingDate);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text('Booking ID: $bookingId'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status: $status'),
                          Text('Date: $formattedDate'),
                          Text('Location: $location'),
                          GestureDetector(
                            onTap: () async {
                              var artist = await _fetchArtistDetails(serviceId);
                              if (artist != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ArtistDetailScreen(artist: artist),
                                  ),
                                );
                              } else {
                                // Handle artist not found
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Artist not found.')),
                                );
                              }
                            },
                            child: Text(
                              'Service ID: $serviceId',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              var user = await _fetchUserDetails(userId);
                              if (user != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserDetailScreen(user: user),
                                  ),
                                );
                              } else {
                                // Handle user not found
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('User not found.')),
                                );
                              }
                            },
                            child: Text(
                              'User ID: $userId',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
