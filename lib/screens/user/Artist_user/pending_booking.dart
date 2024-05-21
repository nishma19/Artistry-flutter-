import 'package:artistry/widgets/apptext.dart';
import 'package:flutter/material.dart';

class PendingBooking extends StatefulWidget {
  const PendingBooking({super.key});

  @override
  State<PendingBooking> createState() => _PendingBookingState();
}

class _PendingBookingState extends State<PendingBooking> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,height: double.infinity,
      child: Column(
        children: [
          // SizedBox(height: 10,),
          ListView.builder(
            itemCount: 2,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                        SizedBox(width: 5,),
                        AppText(data: "Date&Time",color:Color(0xFFB3261E) ,),
                      ],
                    ),

                    subtitle: Row(
                      children: [
                        Icon(Icons.location_on),
                        SizedBox(width: 5,),
                        AppText(data: "Location",color:Colors.grey ,),
                      ],
                    ) ,
                    trailing: SizedBox(
                      width: 70, // Specify a fixed width for the trailing widget
                      child: Row(
                        children: [
                          CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.red[200],
                              backgroundImage:AssetImage("assets/img/cross.png")),
                          SizedBox(width: 10), // Add some spacing between the avatars
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.green[200],
                            backgroundImage: AssetImage("assets/img/tick.png"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  color: Color(0xffF6E4CF),
                ),
              );
            },
          ),
        ],
      ),


    );
  }
}
