import 'package:artistry/widgets/apptext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpComingBooking extends StatefulWidget {
  const UpComingBooking({Key? key});

  @override
  State<UpComingBooking> createState() => _UpComingBookingState();
}

class _UpComingBookingState extends State<UpComingBooking> {
  String? userIdd;

  Future<void> getId() async {
    userIdd = FirebaseAuth.instance.currentUser?.uid;
    setState(() {});
  }

  @override
  void initState() {
    getId();
    super.initState();
  }

  Future<String?> getUserProfileImageUrl(String userId) async {
    var userData = await FirebaseFirestore.instance.collection('user').doc(userId).get();
    return userData.data()?['imageUrl']; // Assuming 'imageUrl' is the field name in your user collection
  }

  Future<String?> getLocationFromBookingStatus(String bookingId) async {
    var bookingStatusData = await FirebaseFirestore.instance
        .collection('booking_status')
        .where('bookingId', isEqualTo: bookingId)
        .get();
    if (bookingStatusData.docs.isNotEmpty) {
      return bookingStatusData.docs.first.data()['location'];
    }
    return null;
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('booking_status')
          .doc(bookingId)
          .update({'status': 'cancelled'});
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking cancelled successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error cancelling booking: $e')));
    }
  }

  var imgurl;

  @override
  Widget build(BuildContext context) {
    print(userIdd);
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('booking_status')
                  .where('serviceId', isEqualTo: userIdd)
                  .where('status', isEqualTo: 'approved') // Changed to 'approved'
                  .snapshots(),
              builder: (context, bookingStatusSnapshot) {
                if (bookingStatusSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (bookingStatusSnapshot.hasData) {
                  final bookingStatusDocs = bookingStatusSnapshot.data!.docs;
                  return ListView.builder(
                    itemCount: bookingStatusDocs.length,
                    itemBuilder: (context, index) {
                      final bookingStatusData = bookingStatusDocs[index].data() as Map<String, dynamic>;
                      final bookingId = bookingStatusData['bookingId'];

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('bookings')
                            .doc(bookingId)
                            .get(),
                        builder: (context, bookingSnapshot) {
                          if (bookingSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (bookingSnapshot.hasData && bookingSnapshot.data!.exists) {
                            final bookingData = bookingSnapshot.data!.data() as Map<String, dynamic>;
                            final userId = bookingData['userId'];
                            imgurl = getUserProfileImageUrl(userId);
                            final DateFormat dateFormat = DateFormat.yMMMd(); // Customize the format as per your requirement
                            final DateFormat timeFormat = DateFormat.Hm(); // For formatting the time

                            final formattedDate = dateFormat.format(DateTime.parse(bookingData['bookingStart']));
                            final formattedTime = timeFormat.format(DateTime.parse(bookingData['bookingStart']));

                            final formattedBookingStart = dateFormat.format(DateTime.parse(bookingData['bookingStart']));

                            return FutureBuilder<String?>(
                              future: getUserProfileImageUrl(userId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator(color: Color(0xFFB3261E),));
                                }
                                final imageUrl = snapshot.data;

                                return FutureBuilder<String?>(
                                  future: getLocationFromBookingStatus(bookingId),
                                  builder: (context, locationSnapshot) {
                                    if (locationSnapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: CircularProgressIndicator(color: Color(0xFFB3261E),));
                                    }
                                    final location = locationSnapshot.data ?? 'Location not available';

                                    // Method to truncate location if it exceeds a certain length
                                    String truncateLocation(String location, int maxLength) {
                                      return (location.length > maxLength)
                                          ? '${location.substring(0, maxLength)}...'
                                          : location;
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Card(
                                        elevation: 3,
                                        shadowColor: Colors.orange[300],
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            radius: 30,
                                            backgroundImage: imageUrl != null
                                                ? NetworkImage(imageUrl)
                                                : AssetImage("assets/img/billie.jpg") as ImageProvider,
                                          ),
                                          title: Row(
                                            children: [
                                              Icon(Icons.access_time),
                                              SizedBox(width: 5),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  AppText(data: "${formattedBookingStart}", color: Colors.grey),
                                                  AppText(data: "${formattedTime}", color: Colors.grey),
                                                ],
                                              ),
                                            ],
                                          ),
                                          subtitle: GestureDetector(
                                            onTap: () {
                                              // Show a dialog with the full location when tapped
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Full Location', style: TextStyle(color: Color(0xFFB3261E))),
                                                    content: Text(location),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text('Close', style: TextStyle(color: Color(0xffD77272))),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.location_on),
                                                SizedBox(width: 5),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    AppText(
                                                      data: truncateLocation(location, 20), // Truncate location to 20 characters
                                                      color: Colors.grey,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          trailing: GestureDetector(
                                            onTap: () {
                                              // Show the pop-up dialog when the "Edit" text is tapped
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor: Colors.white,
                                                    shadowColor: Colors.grey,
                                                    elevation: 10,
                                                    title: Text('Edit Booking', style: TextStyle(color: Color(0xFFB3261E))),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text('You tapped the Edit button!'),
                                                        SizedBox(height: 20),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Colors.white,
                                                              ),
                                                              onPressed: () {
                                                                // Handle rescheduling event
                                                                Navigator.of(context).pop();
                                                                // Implement rescheduling logic here
                                                              },
                                                              child: Text('Reschedule', style: TextStyle(color: Color(0xffD77272))),
                                                            ),
                                                            SizedBox(width: 5,),
                                                            ElevatedButton(
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Colors.white,
                                                              ),
                                                              onPressed: () async {
                                                                // Handle canceling event
                                                                await cancelBooking(bookingId);
                                                                Navigator.of(context).pop();
                                                              },
                                                              child: Text('Cancel', style: TextStyle(color: Color(0xffD77272))),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text('Close', style: TextStyle(color: Color(0xffD77272))),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadiusDirectional.circular(10),
                                                color: Colors.white70,
                                              ),
                                              child: Center(
                                                child: AppText(
                                                  data: "Edit",
                                                  color: Color(0xFFB3261E),
                                                  fw: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        color: Color(0xffF6E4CF),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          } else {
                            // Handle if the booking data does not exist
                            return Text('Booking not found');
                          }
                        },
                      );
                    },
                  );
                }
                return Center(child: Text('No approved bookings found'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
