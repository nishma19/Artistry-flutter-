import 'package:artistry/widgets/apptext.dart';
import 'package:flutter/material.dart';

class PastBooking extends StatefulWidget {
  const PastBooking({super.key});

  @override
  State<PastBooking> createState() => _PastBookingState();
}

class _PastBookingState extends State<PastBooking> {
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
