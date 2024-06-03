import 'package:artistry/widgets/apptext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class PendingBooking extends StatefulWidget {
  final String? artistId;
  const PendingBooking({super.key, this.artistId});

  @override
  State<PendingBooking> createState() => _PendingBookingState();
}

class _PendingBookingState extends State<PendingBooking> {
  Future<void> updateBookingStatus(BuildContext context, String bookingId, String status, String userId) async {
    try {
      // Update the booking status

      await FirebaseFirestore.instance
          .collection('booking_status')
          .doc(bookingId)
          .update({'status': status,



          });

      // Add notification entry
      await FirebaseFirestore.instance
          .collection('user_notifications')
          .add({
        'userId': userId,
        'message': 'Your booking has been $status',
        'timestamp': DateTime.now(),
        'bookingId': bookingId,
        'status': status,
        'type':"booking"
      });

      // Show SnackBar notification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking $status'),
          duration: Duration(seconds: 3),
        ),
      );

      setState(() {}); // Refresh the list after update
    } catch (e) {
      print('Error updating booking status: $e');
      // Show error SnackBar notification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating booking status'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<String?> getUserProfileImageUrl(String userId) async {
    var userData = await FirebaseFirestore.instance.collection('user').doc(userId).get();
    return userData.data()?['imageUrl']; // Assuming 'imageUrl' is the field name in your user collection
  }

  Future<List<Map<String, dynamic>>> fetchPendingBookings() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('booking_status')
        .where('serviceId', isEqualTo: widget.artistId)
        .where('status', isEqualTo: 'pending')
        .get();

    List<Map<String, dynamic>> bookings = [];

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      data['userId'] = doc['userId']; // Include userId
      data['imageUrl'] = await getUserProfileImageUrl(doc['userId']); // Fetch user profile image URL
      bookings.add(data);
    }

    return bookings;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchPendingBookings(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error fetching bookings'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No pending bookings'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final booking = snapshot.data![index];
                      final DateFormat dateFormat = DateFormat.yMMMd(); // Customize the format as per your requirement
                      final DateFormat timeFormat = DateFormat.Hm(); // For formatting the time

                      final formattedDate = dateFormat.format(booking['bookingDate'].toDate());
                      final formattedTime = timeFormat.format(booking['bookingDate'].toDate());

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Card(
                          elevation: 3,
                          shadowColor: Colors.orange[300],
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: booking['imageUrl'] != null
                                  ? NetworkImage(booking['imageUrl'])
                                  : AssetImage("assets/img/billie.jpg") as ImageProvider,
                            ),
                            title: Row(
                              children: [
                                Icon(Icons.access_time),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppText(
                                        data: formattedDate,
                                        color: Color(0xFFB3261E),
                                      ),
                                      AppText(
                                        data: formattedTime,
                                        color: Color(0xFFB3261E),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Icon(Icons.location_on),
                                SizedBox(width: 5),
                                AppText(
                                  data: booking['location'],
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            trailing: Expanded(
                              child: SizedBox(
                                width: 70,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: IconButton(
                                        icon: Icon(Icons.close, color: Colors.red),
                                        onPressed: () {
                                          updateBookingStatus(context, booking['id'], 'rejected', booking['userId']);
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        icon: Icon(Icons.check, color: Colors.green),
                                        onPressed: () {
                                          updateBookingStatus(context, booking['id'], 'approved', booking['userId']);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          color: Color(0xffF6E4CF),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
