import 'package:artistry/models/artist_model.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    print(name);
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
      // servicePrice: int.parse(widget.artist.price.toString())
    );
    Future.delayed(Duration(seconds: 5), () {
      firestore = FirebaseFirestore.instance;
    });
    super.initState();
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

      // Additional data for 'booking_status' collection
      final Map<String, dynamic> bookingStatusData = {
        'bookingId': bookingId,
        'status': 'pending', // You can set initial status here
        'bookingDate': DateTime.now(),
        'userId': id,
        'location': "Perinthalma" ,'serviceId':widget.artist.id

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Calendar',style: TextStyle(color: Colors.black),),
      ),
      body: Column(
        children: [
          // ListTile(
          //   leading: Icon(
          //     Icons.location_on,
          //     color: Colors.red,
          //     size: 30,
          //   ),
          //   title: Text(
          //     locationCity,
          //     style: TextStyle(
          //         color: Colors.black,
          //         fontSize: 20,
          //         fontWeight: FontWeight.w500),
          //   ),
          //   subtitle: Text(
          //     subLocality,
          //     style: TextStyle(
          //         color: Colors.grey,
          //         fontSize: 15,
          //         fontWeight: FontWeight.w500),
          //   ),
          //   trailing: CircleAvatar(
          //     radius: 25,
          //     backgroundColor: Colors.black12,
          //   ),
          // ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
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
                child: Row(crossAxisAlignment: CrossAxisAlignment.center,
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
                convertStreamResultToDateTimeRanges: convertStreamResultMock,
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
    );
  }
}