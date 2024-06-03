import 'package:artistry/widgets/apptext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ApprovedOrders extends StatefulWidget {
  const ApprovedOrders({super.key});

  @override
  State<ApprovedOrders> createState() => _ApprovedOrdersState();
}

class _ApprovedOrdersState extends State<ApprovedOrders> {
  Future<List<Map<String, dynamic>>> fetchApprovedOrders() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('status', isEqualTo: 'approved')
        .get();

    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<String?> getUserProfileImageUrl(String userId) async {
    var userData = await FirebaseFirestore.instance.collection('user').doc(userId).get();
    return userData.data()?['imageUrl'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchApprovedOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No approved orders found'));
          } else {
            final approvedOrders = snapshot.data!;
            return ListView.builder(
              itemCount: approvedOrders.length,
              itemBuilder: (context, index) {
                final order = approvedOrders[index];
                final date = DateTime.parse(order['createdAt']);
                final formattedDate = DateFormat.yMMMd().format(date);
                final time = DateFormat.Hm().format(date);

                return FutureBuilder<String?>(
                  future: getUserProfileImageUrl(order['userId']),
                  builder: (context, userImageSnapshot) {
                    if (userImageSnapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final userImageUrl = userImageSnapshot.data;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Card(
                        elevation: 3,
                        shadowColor: Colors.orange[300],
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: userImageUrl != null
                                ? NetworkImage(userImageUrl)
                                : AssetImage("assets/img/default_avatar.jpg") as ImageProvider,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.access_time),
                                  SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppText(data: formattedDate, color: Colors.grey),
                                      AppText(data: time, color: Colors.grey),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.location_on),
                                  SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AppText(data: order['userAddress'], color: Colors.grey),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          subtitle: GestureDetector(
                            onTap: () {
                              _showProductDetailsDialog(context, order);
                            },
                            child: Container(
                              height: 30,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.circular(10),
                                color: Colors.white70,
                              ),
                              child: Center(
                                child: AppText(
                                  data: "Product Details",
                                  color: Color(0xFFB3261E),
                                  fw: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () {
                              _showEditDialog(context);
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
          }
        },
      ),
    );
  }

  void _showProductDetailsDialog(BuildContext context, Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Product Details", style: TextStyle(color: Color(0xFFB3261E))),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.network(
                  order['productImageUrl'],
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Text("Product Name: ${order['productName']}"),
              Text("Price: \$${order['servicePrice']}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close", style: TextStyle(color: Color(0xFFB3261E))),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context) {
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
                      Navigator.of(context).pop();
                      // Implement rescheduling logic here
                    },
                    child: Text('Reschedule', style: TextStyle(color: Color(0xffD77272))),
                  ),
                  SizedBox(width: 5),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Implement canceling logic here
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
  }
}
