import 'dart:ui';

import 'package:artistry/models/artist_model.dart';
import 'package:artistry/screens/user/end_user/order_page.dart';
import 'package:artistry/widgets/apptext.dart';
import 'package:artistry/widgets/image_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Artistdetails extends StatefulWidget {
  const Artistdetails({super.key});

  @override
  State<Artistdetails> createState() => _ArtistdetailsState();
}

class _ArtistdetailsState extends State<Artistdetails> {


  var role;
  var name;
  var id;
  var email;
  var phone;
  var cat;
  var address;

  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    role = await _pref.getString('role');


    name = await _pref.getString('name');
    id = await _pref.getString('id');
    email = await _pref.getString('email');
    phone = await _pref.getString('phone');
    address = await _pref.getString('address');
    setState(() {});
  }
  @override
  void initState() {
    getData();
    super.initState();
  }

    @override
  Widget build(BuildContext context) {

    final Artist artist=ModalRoute.of(context)!.settings.arguments as Artist ;
    print(artist);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFFF5E9),
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Icon(Icons.bookmark),
          )
        ],

        
      ),
      body:
         Container(height: double.infinity,width: double.infinity,
          // color: Color(0xffFFF5E9),

          child: Stack(
              children: [
                SizedBox(height: 30,),
          Container(
            // color: Colors.orange[100],

            height:400,
            width: double.infinity,


            child: Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                     artist.imageUrl.toString(),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )),
                AppText(data: "${artist.name}",color: Color(0xFFB3261E),fw: FontWeight.w600,size: 15,),
           Padding(
             padding: const EdgeInsets.all(8.0),
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

                    child: Center(child: AppText(data: "http/www/dfffdfdff:wdeeddf",color: Colors.blue,size: 15,)),
                  ),
           ),
                SizedBox(height: 5,),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(onTap: (){
                        Navigator.pushNamed(context,'subscriptionplan',arguments: {
                          "artistId":artist.id,
                          'artistName':artist.name,
                          'artisPhone':artist.phone
                        });
                      },
                        child: Container(
                          
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                        
                                  offset: Offset(4.0, 4.0),
                                  color: Colors.grey,
                                  blurRadius: 15,
                                  spreadRadius: 1.0,
                                ),
                                BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-4.0, -4.0),
                                  blurRadius: 15,
                                  spreadRadius: 1.0,
                                )
                              ]
                          ),
                          child: Center(child: AppText(data: "WorkShop",color:  Color(0xFFB3261E),size: 15,fw: FontWeight.w800,)),
                        ),
                      ),
                    ),

                Expanded(
                  child: InkWell(onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>BookingCalendarDemoApp(artist: artist,

                    userData: {

                      'name':name,
                      'uid':id,
                      'phone':phone,
                      'email':email
                    },

                    )));
                  },
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow:  [
                            BoxShadow(

                              offset: Offset(4.0, 4.0),
                              color: Colors.grey,
                              blurRadius: 15,
                              spreadRadius: 1.0,
                            ),
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(-4.0, -4.0),
                              blurRadius: 15,
                              spreadRadius: 1.5,
                            )
                          ]
                      ),
                      child: Center(child: AppText(data: "Order",color: Color(0xFFB3261E),size: 15,fw: FontWeight.w700,)),
                    ),
                  ),
                ),
                  ],
                ),

              ],
            ),
          ),
            





          Positioned(
            bottom: 0,left: 0,right: 0,
            child: Container(
              width: double.infinity,
              height: 400
              ,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
                // color: Color(0xffFFF5E9),
              ),
              child:Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  shrinkWrap: true,
                  children: List.generate(
                    12, // Adjust the number of children as needed
                        (index) {
                      return Stack(
                          children: [ ClipRRect(

                              child: Image.asset(
                                'assets/img/billie2.jpg',
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              )),



                          ]
                      );
                    },
                  ),
                ),
              ),

            ),
          ),










              ]
      ),
    ),
    );
  }
}
