import 'package:artistry/widgets/apptext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpComingBooking extends StatefulWidget {
  const UpComingBooking({Key? key});

  @override
  State<UpComingBooking> createState() => _UpComingBookingState();
}

class _UpComingBookingState extends State<UpComingBooking> {
  var userIdd;


  getId() async {

    userIdd = await FirebaseAuth.instance.currentUser!.uid;
    setState(() {});
  }

  @override
  void initState() {
    getId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          // ListView.builder(
          //   itemCount: 2,
          //   shrinkWrap: true,
          //   itemBuilder: (context, index) {
          //     return Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 10),
          //       child: Card(
          //         elevation: 3,
          //         shadowColor: Colors.orange[300],
          //         child: ListTile(
          //
          //           leading: CircleAvatar(
          //             radius: 30,
          //             backgroundImage: AssetImage("assets/img/billie.jpg"),
          //           ),
          //           title: Row(
          //             children: [
          //               Icon(Icons.access_time),
          //               SizedBox(width: 5),
          //               AppText(data: "Date&Time", color: Color(0xFFB3261E)),
          //             ],
          //           ),
          //           subtitle: Row(
          //             children: [
          //               Icon(Icons.location_on),
          //               SizedBox(width: 5),
          //               AppText(data: "Location", color: Colors.grey),
          //             ],
          //           ),
          //           trailing: GestureDetector(
          //             onTap: () {
          //               // Show the pop-up dialog when the "Edit" text is tapped
          //               showDialog(
          //                 context: context,
          //                 builder: (BuildContext context) {
          //                   return AlertDialog(
          //                     backgroundColor: Colors.white,
          //                     shadowColor: Colors.grey,elevation: 10,
          //                     title: Text('Edit Booking',style: TextStyle(color: Color(0xFFB3261E)),),
          //                     content: Column(
          //                       mainAxisSize: MainAxisSize.min,
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text('You tapped the Edit button!'),
          //                         SizedBox(height: 20),
          //                         Row(
          //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                           children: [
          //                             ElevatedButton(
          //                               style: ElevatedButton.styleFrom(
          //                                 backgroundColor: Colors.white,
          //                               ),
          //                               onPressed: () {
          //                                 // Handle rescheduling event
          //                                 Navigator.of(context).pop();
          //                                 // Implement rescheduling logic here
          //                               },
          //                               child: Text('Reschedule',style: TextStyle(color: Color(0xffD77272)),),
          //                             ),
          //                             SizedBox(width: 5,),
          //                             ElevatedButton(
          //                               style: ElevatedButton.styleFrom(
          //                                 backgroundColor: Colors.white,
          //                               ),
          //                               onPressed: () {
          //                                 // Handle canceling event
          //                                 Navigator.of(context).pop();
          //                                 // Implement canceling logic here
          //                               },
          //                               child: Text('Cancel',style: TextStyle(color: Color(0xffD77272)),),
          //                             ),
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //                     actions: [
          //                       TextButton(
          //                         onPressed: () {
          //                           Navigator.of(context).pop();
          //                         },
          //                         child: Text('Close',style: TextStyle(color: Color(0xffD77272)),),
          //                       ),
          //                     ],
          //                   );
          //                 },
          //               );
          //             },
          //             child: Container(height: 40,
          //               width: 50,
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadiusDirectional.circular(10),
          //                 color: Colors.white70,
          //               ),
          //               child: Center(
          //                 child: AppText(
          //                   data: "Edit",
          //                   color: Color(0xFFB3261E),
          //                   fw: FontWeight.w600,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //         color: Color(0xffF6E4CF),
          //       ),
          //     );
          //   },
          // ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .where('serviceId', isEqualTo: userIdd)
                  .snapshots(),
              builder: (context, bookingsSnapshot) {
                if (bookingsSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (bookingsSnapshot.hasData) {
                  final bookingDocs = bookingsSnapshot.data!.docs;
                  return ListView.builder(
                    itemCount: bookingDocs.length,
                    itemBuilder: (context, index) {
                      final bookingData =
                          bookingDocs[index].data() as Map<String, dynamic>;
                      final id = bookingData['serviceId'];
                      final serviceName = bookingData['serviceName'];





                      print("hello Jobin");

                      print(id);
                      return Card(
                        elevation: 3,
                        shadowColor: Colors.orange[300],
                        child: ListTile(

                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(
                                "assets/img/billie.jpg"),
                          ),
                          title: Row(
                            children: [
                              Icon(Icons.access_time),
                              SizedBox(width: 5),
                              AppText(
                                  data: "${bookingData['serviceName']}",
                                  color: Color(0xFFB3261E)),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Icon(Icons.location_on),
                              SizedBox(width: 5),
                              AppText(data: "Location",
                                  color: Colors.grey),
                            ],
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
                                    title: Text('Edit Booking',
                                      style: TextStyle(
                                          color: Color(0xFFB3261E)),),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                            'You tapped the Edit button!'),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton
                                                  .styleFrom(
                                                backgroundColor: Colors
                                                    .white,
                                              ),
                                              onPressed: () {
// Handle rescheduling event
                                                Navigator.of(context)
                                                    .pop();
// Implement rescheduling logic here
                                              },
                                              child: Text(
                                                'Reschedule',
                                                style: TextStyle(
                                                    color: Color(
                                                        0xffD77272)),),
                                            ),
                                            SizedBox(width: 5,),
                                            ElevatedButton(
                                              style: ElevatedButton
                                                  .styleFrom(
                                                backgroundColor: Colors
                                                    .white,
                                              ),
                                              onPressed: () {
// Handle canceling event
                                                Navigator.of(context)
                                                    .pop();
// Implement canceling logic here
                                              },
                                              child: Text('Cancel',
                                                style: TextStyle(
                                                    color: Color(
                                                        0xffD77272)),),
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
                                        child: Text('Close',
                                          style: TextStyle(
                                              color: Color(
                                                  0xffD77272)),),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(height: 40,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional
                                    .circular(10),
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
                      );



                    },
                  );
                }

                return CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}



// return Card(
// elevation: 3,
// shadowColor: Colors.orange[300],
// child: ListTile(
//
// leading: CircleAvatar(
// radius: 30,
// backgroundImage: AssetImage("assets/img/billie.jpg"),
// ),
// title: Row(
// children: [
// Icon(Icons.access_time),
// SizedBox(width: 5),
// AppText(data: "${bookingData['serviceName']}", color: Color(0xFFB3261E)),
// ],
// ),
// subtitle: Row(
// children: [
// Icon(Icons.location_on),
// SizedBox(width: 5),
// AppText(data: "Location", color: Colors.grey),
// ],
// ),
// trailing: GestureDetector(
// onTap: () {
// // Show the pop-up dialog when the "Edit" text is tapped
// showDialog(
// context: context,
// builder: (BuildContext context) {
// return AlertDialog(
// backgroundColor: Colors.white,
// shadowColor: Colors.grey,elevation: 10,
// title: Text('Edit Booking',style: TextStyle(color: Color(0xFFB3261E)),),
// content: Column(
// mainAxisSize: MainAxisSize.min,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Text('You tapped the Edit button!'),
// SizedBox(height: 20),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// ElevatedButton(
// style: ElevatedButton.styleFrom(
// backgroundColor: Colors.white,
// ),
// onPressed: () {
// // Handle rescheduling event
// Navigator.of(context).pop();
// // Implement rescheduling logic here
// },
// child: Text('Reschedule',style: TextStyle(color: Color(0xffD77272)),),
// ),
// SizedBox(width: 5,),
// ElevatedButton(
// style: ElevatedButton.styleFrom(
// backgroundColor: Colors.white,
// ),
// onPressed: () {
// // Handle canceling event
// Navigator.of(context).pop();
// // Implement canceling logic here
// },
// child: Text('Cancel',style: TextStyle(color: Color(0xffD77272)),),
// ),
// ],
// ),
// ],
// ),
// actions: [
// TextButton(
// onPressed: () {
// Navigator.of(context).pop();
// },
// child: Text('Close',style: TextStyle(color: Color(0xffD77272)),),
// ),
// ],
// );
// },
// );
// },
// child: Container(height: 40,
// width: 50,
// decoration: BoxDecoration(
// borderRadius: BorderRadiusDirectional.circular(10),
// color: Colors.white70,
// ),
// child: Center(
// child: AppText(
// data: "Edit",
// color: Color(0xFFB3261E),
// fw: FontWeight.w600,
// ),
// ),
// ),
// ),
// ),
// color: Color(0xffF6E4CF),
// );