import 'package:artistry/screens/user/Artist_user/approved_orders.dart';
import 'package:artistry/screens/user/Artist_user/cancelled_orders.dart';
import 'package:artistry/screens/user/Artist_user/past_orders.dart';
import 'package:artistry/screens/user/Artist_user/pending_orders.dart';
import 'package:flutter/material.dart';
import 'package:artistry/screens/user/Artist_user/cancelled_booking.dart';
import 'package:artistry/screens/user/Artist_user/past_booking.dart';
import 'package:artistry/screens/user/Artist_user/pending_booking.dart';
import 'package:artistry/screens/user/Artist_user/upcoming_booking.dart';
import 'package:artistry/widgets/apptext.dart';

class ProductOrdersPage extends StatefulWidget {
  const ProductOrdersPage({Key? key});

  @override
  State<ProductOrdersPage> createState() => _ProductOrdersPageState();
}

class _ProductOrdersPageState extends State<ProductOrdersPage> {
  TextEditingController _search = TextEditingController();
  bool hasUnreadNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 300,
          height: 48,
          child: TextField(
            controller: _search,
            cursorColor: Color(0xffD77272),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(13),
              hintText: "Any products/artist",
              hintStyle: TextStyle(color: Colors.black26),
              label: Text(
                "Search",
                style: TextStyle(color: Color(0xffD77272)),
              ),
              filled: true,
              fillColor: Color(0xffFFF5E9),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(130),
                  borderSide: BorderSide(color: Colors.black26)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(130),
                  borderSide: BorderSide(
                    color: Color(0xffD77272),
                    width: 1.2,
                  )),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFB3261E)),
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, 'artistnoticn');
                },
                child: Stack(
                  children: [
                    Icon(
                      hasUnreadNotifications
                          ? Icons.notifications_none
                          : Icons.notifications_none,
                      color: hasUnreadNotifications
                          ? Color(0xFFB3261E)
                          : Color(0xFFB3261E),
                      size: 25,
                    ),
                    if (hasUnreadNotifications) // Display notification indicator if there are unread notifications
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Color(0xFFB3261E),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 8,
                            minHeight: 8,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          )
        ],
        backgroundColor: Color(0xffFFF5E9),
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [

            Container(
              width: 400,
              height: 80,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadiusDirectional.circular(15),color: Color(0xffFFF5E9)
              // ),

              padding: EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: TabBar(
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          // Color when the tab is pressed
                          return Color(0xffF6E4CF);
                        }
                        // Default color
                        return null;
                      },
                    ),
                    isScrollable: true,
                    indicatorColor: Color(0xffD77272),
                    labelStyle: TextStyle(color: Color(0xffD77272)),
                    tabs: [
                      Text("Approved",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600
                      ),),
                      Text("Pending",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600
                      ),),
                      // Text("Past",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600
                      // ),),
                      // Text("Cancelled",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600
                      // ),),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                 ApprovedOrders(),
                  PendingOrders(),
                  // PastOrders(),
                  // CancelledOrders(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
