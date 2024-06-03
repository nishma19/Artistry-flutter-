import 'package:artistry/models/artist_model.dart';
import 'package:artistry/widgets/apptext.dart';
import 'package:artistry/widgets/customtextformfield.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class BookingCalendarDemoApp extends StatefulWidget {
  final Artist artist;
  final Map<String, dynamic> userData;
  const BookingCalendarDemoApp(
      {Key? key, required this.artist, required this.userData})
      : super(key: key);

  @override
  State<BookingCalendarDemoApp> createState() => _BookingCalendarDemoAppState();
}

class _BookingCalendarDemoAppState extends State<BookingCalendarDemoApp> {
  final now = DateTime.now();
  late BookingService mockBookingService;
  FirebaseFirestore? firestore;

  var role;
  var name;
  var id;
  var email;
  var phone;
  var cat;
  var address;

  @override
  void initState() {
    print(widget.artist.price.runtimeType);
    id = widget.userData['uid'];
    // final bookingId = Uuid().v1();

    mockBookingService = BookingService(

    serviceName: widget.artist.name,
        serviceDuration: 30,
        bookingEnd: DateTime(now.year, now.month, now.day, 18, 0),
        bookingStart: now,
        serviceId: widget.artist.id,
        userId: widget.userData['uid'],
        userName: widget.userData['name'],
        userEmail: widget.userData['email'],
        userPhoneNumber: widget.userData['phone'],
        servicePrice: (int.parse(
            (double.parse(widget.artist.price.toString()) ~/ 100)
                .toString())) *
            100);
    Future.delayed(Duration(seconds: 5), () {
      firestore = FirebaseFirestore.instance;
    });
    super.initState();
  }

  Future<List<Map<String, dynamic>>> fetchPendingBookings() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('booking_status')
        .where('serviceId', isEqualTo: widget.artist.id)
        .where('status', isEqualTo: 'pending')
        .get();

    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      data['userId'] = doc['userId']; // Include userId
      return data;
    }).toList();
  }

  Future<void> updateBookingStatus(BuildContext context, String bookingId, String status, String userId, int servicePrice, String serviceName) async {
    try {
      // Update the booking status
      await FirebaseFirestore.instance
          .collection('booking_status')
          .doc(bookingId)
          .update({
        'status': status,
        'servicePrice': servicePrice,
        'serviceName': serviceName,
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

  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    return Stream.value([]);
  }

  Future<void> uploadBookingMock({required BookingService newBooking}) async {
    try {
      final bookingsCollection = firestore!.collection('bookings');
      final bookingStatusCollection = firestore!.collection('booking_status');

      // Add booking data to 'bookings' collection
      final bookingDocRef = await bookingsCollection.add(newBooking.toJson());
      final bookingId = bookingDocRef.id;

      // Get the venue from the TextEditingController
      final venue = _venue.text;

      // Additional data for 'booking_status' collection
      final Map<String, dynamic> bookingStatusData = {
        'bookingId': bookingId,
        'status': 'pending', // You can set initial status here
        'bookingDate': DateTime.now(),
        'userId': id,
        'location': venue,
        'serviceId': widget.artist.id,
        'servicePrice': widget.artist.price,
        'serviceDuration': widget.artist.name,
      };

      // Add booking status data to 'booking_status' collection
      await bookingStatusCollection.add(bookingStatusData);

      print('${newBooking.toJson()} has been uploaded');
    } catch (e) {
      print('Error uploading booking: $e');
    }
  }

  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    // Your conversion logic here
    // This function is not used in uploading bookings
    return [];
  }

  List<DateTimeRange> generatePauseSlots() {
    return [
      DateTimeRange(
        start: DateTime(now.year, now.month, now.day, 12, 0),
        end: DateTime(now.year, now.month, now.day, 13, 0),
      )
    ];
  }

  TextEditingController _venue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Do Booking',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: CustomScrollView(slivers: [
        SliverFillRemaining(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "please enter the venue";
                    }
                  },
                  controller: _venue,
                  maxLines: 3,
                  cursorColor: Color(0xffD77272),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(13),
                    hintText: "Please enter the venue",
                    label: Text(
                      "Venue:",
                      style: TextStyle(color: Color(0xFFB3261E)),
                    ),
                    hintStyle: TextStyle(
                        color: Colors.black12,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xffD77272),
                          width: 1.2,
                        )),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFFB3261E)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: Colors.black54,
                              width: 1.0,
                              style: BorderStyle.solid),
                          bottom: BorderSide(
                              color: Colors.black54,
                              width: 1.0,
                              style: BorderStyle.solid),
                          right: BorderSide(
                              color: Colors.black54,
                              width: 1.0,
                              style: BorderStyle.solid),
                          left: BorderSide(
                              color: Colors.black54,
                              width: 1.0,
                              style: BorderStyle.solid))),
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ArtistPrice:",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          widget.artist.price,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: BookingCalendar(
                    bookingService: mockBookingService!,
                    convertStreamResultToDateTimeRanges:
                    convertStreamResultMock,
                    getBookingStream: getBookingStreamMock,
                    uploadBooking: uploadBookingMock,
                    pauseSlots: generatePauseSlots(),
                    pauseSlotText: 'LUNCH',
                    hideBreakTime: false,
                    loadingWidget: const Text('Fetching data...'),
                    uploadingWidget: const CircularProgressIndicator(),
                    locale: 'en-Us',
                    startingDayOfWeek: StartingDayOfWeek.tuesday,
                    wholeDayIsBookedWidget: const Text(
                      'Sorry, for this day everything is booked',
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ]),
    );
  }
}
