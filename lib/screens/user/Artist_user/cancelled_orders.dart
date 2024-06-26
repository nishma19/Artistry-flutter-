import 'package:artistry/widgets/apptext.dart';
import 'package:flutter/material.dart';

class CancelledOrders extends StatefulWidget {
  const CancelledOrders({super.key});

  @override
  State<CancelledOrders> createState() => _CancelledOrdersState();
}

class _CancelledOrdersState extends State<CancelledOrders> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
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
                    title:
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time),
                            SizedBox(width: 5),
                            Column(
                              children: [

                                AppText(data: "Date&Time", color: Colors.grey),
                              ],
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Icon(Icons.location_on),
                            SizedBox(width: 5),
                            Column(
                              children: [

                                AppText(data: "Location", color: Colors.grey),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),



                    subtitle:



                    GestureDetector(onTap: (){

                      _showProductDetailsDialog(context);
                    },
                      child: Container(height: 30,
                        width: 50,
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



  void _showProductDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Product Details",style: TextStyle(color: Color(0xFFB3261E)),),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.asset(
                  "assets/img/artrim3.jpg", // Provide your image path here
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: 10),
              Text("Product Name: Your Product Name"),
              Text("Price: \$X.XX"),
              // Add more details here as needed
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close",style: TextStyle(color: Color(0xFFB3261E)),),
            ),
          ],
        );
      },
    );
  }







}
