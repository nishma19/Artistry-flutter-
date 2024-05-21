import 'package:artistry/widgets/apptext.dart';
import 'package:flutter/material.dart';

class CancelledBooking extends StatefulWidget {
  const CancelledBooking({super.key});

  @override
  State<CancelledBooking> createState() => _CancelledBookingState();
}

class _CancelledBookingState extends State<CancelledBooking> {
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
                        child: Container(
                          height: 40,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.circular(15),
                            color: Colors.red[200],
                          ),
                          child:

                          Center(child: AppText(data: "Cancelled",color:Color(0xFFB3261E) ,fw: FontWeight.w600,)),

                        )
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
