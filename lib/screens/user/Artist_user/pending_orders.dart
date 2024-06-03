import 'package:artistry/widgets/apptext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PendingOrders extends StatefulWidget {
  final String? artistId;
  const PendingOrders({super.key,  this.artistId});

  @override
  State<PendingOrders> createState() => _PendingOrdersState();
}

class _PendingOrdersState extends State<PendingOrders> {
  Future<void> updateBookingStatus(BuildContext context, String bookingId, String status, String userId) async {
    try {
      // Update the booking status
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(bookingId)
          .update({'status': status});

      // Add notification entry
      await FirebaseFirestore.instance
          .collection('user_notifications')
          .add({
        'userId': userId,
        'message': 'Your order has been $status',
        'timestamp': DateTime.now(),
        'bookingId': bookingId,
        'status': status,
        'type':"order"
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
          content: Text('Error updating order status'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchPendingBookings() async {
    final String artistId=await FirebaseAuth.instance.currentUser!.uid;
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('artistId', isEqualTo: artistId)
        .where('status', isEqualTo: 'Pending')
        .get();

    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['id'] = doc['orderId'];
      data['userId'] = doc['userId']; // Include userId
      return data;
    }).toList();
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
                  return Center(child: Text('Error fetching order'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No pending orders'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final booking = snapshot.data![index];
                      final DateFormat dateFormat = DateFormat.yMMMd(); // Customize the format as per your requirement
                      final DateFormat timeFormat = DateFormat.Hm(); // For formatting the time

                      final formattedDate = dateFormat.format(DateTime.parse(booking['deadline']));
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Card(
                          elevation: 3,
                          shadowColor: Colors.orange[300],
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage("assets/img/billie.jpg"),
                            ),
                            title: Row(
                              children: [
                                Icon(Icons.access_time),
                                SizedBox(width: 5),
                                AppText(
                                  data: formattedDate.toString(), // Format this as needed
                                  color: Color(0xFFB3261E),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Icon(Icons.location_on),
                                SizedBox(width: 5),
                                AppText(
                                  data: booking['userAddress'],
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.close, color: Colors.red),
                                    onPressed: () {
                                      updateBookingStatus(context, booking['id'], 'rejected', booking['userId']);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.check, color: Colors.green),
                                    onPressed: () {
                                      updateBookingStatus(context, booking['id'], 'approved', booking['userId']);
                                    },
                                  ),
                                ],
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
