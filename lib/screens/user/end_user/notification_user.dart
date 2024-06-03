import 'package:artistry/screens/user/end_user/booking_checkout.dart';
import 'package:artistry/screens/user/end_user/order_checkout.dart';
import 'package:artistry/widgets/apptext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserNotificationsPage extends StatefulWidget {
  final String? userId;

  const UserNotificationsPage({Key? key, this.userId}) : super(key: key);

  @override
  State<UserNotificationsPage> createState() => _UserNotificationsPageState();
}

class _UserNotificationsPageState extends State<UserNotificationsPage> {


  Future<List<Map<String, dynamic>>> fetchUserNotifications() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('user_notifications')
        .where('userId', isEqualTo: widget.userId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  String formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }

  void handleContinueTap(Map<String, dynamic> notification) {
    // Mark as read in Firestore
    FirebaseFirestore.instance
        .collection('user_notifications')
        .doc(notification['id'])
        .update({'read': true});

    // Navigate based on the notification type
    if (notification['type'] == 'order') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderCheckoutPage(orderId: notification['bookingId']),
        ),
      );
    } else if (notification['type'] == 'booking') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingCheckoutPage(
              bookingId: notification['bookingId']
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchUserNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching notifications'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notifications'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final notification = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    elevation: 3,
                    shadowColor: Colors.orange[300],
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage("assets/img/billie.jpg"),
                      ),
                      title: Text(notification['message']),
                      subtitle: Text(formatTimestamp(notification['timestamp'])),
                      trailing: GestureDetector(
                        onTap: () {
                          handleContinueTap(notification);
                        },
                        child: Container(
                          height: 40,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.circular(10),
                            color: Colors.white70,
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppText(
                                data: "Continue",
                                color: Color(0xFFB3261E),
                                fw: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
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
