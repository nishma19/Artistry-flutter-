import 'package:flutter/material.dart';
import 'package:artistry/screens/admin/products_list.dart';
import 'package:artistry/screens/admin/artist_management.dart';
import 'package:artistry/screens/admin/booking_list_screen.dart';
import 'package:artistry/services/artist_service.dart';
import 'package:artistry/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparkline/sparkline.dart';

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final ArtistService _artistService = ArtistService();
  bool hasPendingRegistrations = false;
  List<double> data = [0.0]; // Initialize with an empty list

  @override
  void initState() {
    super.initState();
    fetchBookingData();
  }

  Future<void> fetchBookingData() async {
    try {
      QuerySnapshot bookingsSnapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .get();

      List<double> bookingAmounts = bookingsSnapshot.docs.map((doc) {
        var booking = doc.data() as Map<String, dynamic>;
        return (booking['servicePrice'] as num).toDouble();
      }).toList();

      setState(() {
        data = bookingAmounts;
      });
    } catch (e) {
      print('Error fetching booking data: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF5E9),
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: TextStyle(color: Color(0xffD77272)),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              AuthService().logout().then((value) => Navigator.pushNamedAndRemoveUntil(
                  context, 'login', (route) => false));
            },
            icon: Icon(Icons.logout_outlined),
          )
        ],
      ),
      drawer: Drawer(
        elevation: 0.0,
        child: ListView(
          padding: EdgeInsets.all(5.0),
          children: <Widget>[
            DrawerHeader(
              child: Image.asset(
                'assets/img/logoartnew.png',
                width: 50,
              ),
            ),
            ListTile(
              selectedTileColor: Colors.orange,
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () {
                Navigator.pushNamed(context, 'admin');
              },
            ),
            ListTile(
              selectedTileColor: Colors.orange,
              leading: Icon(Icons.people),
              title: Text('Users'),
              onTap: () {
                Navigator.pushNamed(context, 'usermanagement');
              },
            ),
            ListTile(
              selectedTileColor: Colors.orange,
              leading: Icon(Icons.people_alt_outlined),
              title: Text('Artists'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArtistListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              selectedTileColor: Colors.orange,
              leading: Icon(Icons.book),
              title: Text('Bookings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              selectedTileColor: Colors.orange,
              leading: Icon(Icons.payment),
              title: Text('Payments'),
              onTap: () {},
            ),
            ListTile(
              selectedTileColor: Colors.orange,
              leading: Icon(Icons.hiking_outlined),
              title: Text('Products'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.notifications_outlined,
                color: hasPendingRegistrations ? Colors.red : Colors.black87,
              ),
              title: Text('Notification'),
              selectedTileColor: Colors.orange,
              onTap: () {
                Navigator.pushNamed(context, 'notify');
              },
            ),
            ListTile(
              selectedTileColor: Colors.orange,
              leading: Icon(Icons.bar_chart),
              title: Text('Reports'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Booking Trend',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffD77272)),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  width: 300.0,
                  height: 200.0,
                  child: Sparkline(
                    lineColor: Color(0xFFB3261E),
                    data: data,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
