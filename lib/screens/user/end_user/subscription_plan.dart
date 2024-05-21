import 'package:artistry/screens/user/end_user/checkout_page.dart';
import 'package:artistry/services/workshop_service.dart';
import 'package:artistry/widgets/apptext.dart';
import 'package:flutter/material.dart';

import '../../../models/workshop_model.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {

  WorkshopService _workshopService=WorkshopService();

  @override
  Widget build(BuildContext context) {

    final Map<String,dynamic> data=ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;

    print(data['artistId']);
    print(data['artistName']);
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xffFFF5E9),
        title: AppText(data: "Subscription Plans",size: 20,fw: FontWeight.w500,color: Color(0xFFB3261E),),
      ),
      body: StreamBuilder<List<Workshop>>(
        stream: _workshopService.getWorkshopsbyId(data['artistId'].toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }



          else {
            final workshops = snapshot.data!;

            if(workshops.isEmpty){

              return Center(
                child: Text(
                    "No Data"
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: workshops.length,
                itemBuilder: (context, index) {
                  final workshop = workshops[index];
                  return SubscriptionPlanCard(

                      title: workshop.title,

                      price: workshop.price.toString() ,

                      features: workshop.description,
                      wrkshop: workshop,
                      artistName: data['artistName'],
                      artistId: data['artistId'],

                      onPressed: (){}

                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class SubscriptionPlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String features;
  final VoidCallback onPressed;
  final Workshop? wrkshop;

  final String? artistId;
  final String ?artistName;

  SubscriptionPlanCard({
    required this.title,
    required this.price,
    required this.features,
    required this.onPressed,
    this.wrkshop,
    this.artistName,this.artistId
  });

  @override
  Widget build(BuildContext context) {



    return Card(
      elevation: 0.4,
      shadowColor: Colors.black,surfaceTintColor: Colors.red,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Color(0xFFB3261E),
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              price,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              features,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CheckoutPage(workshop: wrkshop,artistId: artistId,artistName: artistName,)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffFFF5E9),
              ),
              child: AppText(data: "Subscribe",size: 15,fw: FontWeight.w500,color: Color(0xffD77272),),
            ),

          ],
        ),
      ),
    );
  }
}
