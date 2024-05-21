import 'package:artistry/screens/common/addinfo.dart';
import 'package:artistry/screens/user/Artist_user/list_workshops.dart';
import 'package:artistry/screens/user/Artist_user/onlineClassesPage.dart';
import 'package:artistry/services/auth_service.dart';
import 'package:artistry/widgets/apptext.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';






class ArtistProfilePage extends StatefulWidget {
  const ArtistProfilePage({super.key});

  @override
  State<ArtistProfilePage> createState() => _ArtistProfilePageState();
}

class _ArtistProfilePageState extends State<ArtistProfilePage> {
  var role;
  var name;
  var id;
  var email;
  var phone;
  var cat;
  var address;
  var businessDetails;
  var price;



  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

    role = await _pref.getString('role');


    name = await _pref.getString('name');
    id = await _pref.getString('id');
    email = await _pref.getString('email');
    phone = await _pref.getString('phone');
    address = await _pref.getString('address');
    businessDetails = await _pref.getString('businessDetails');


    cat = await _pref.getString('cate');
    price = await _pref.getString('price');



    print(id);
    setState(() {});

  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(appBar: AppBar(
      backgroundColor: Color(0xffFFF5E9),
      title: AppText(data: "Profile",color: Color(0xFFB3261E),size: 20,fw: FontWeight.w600,),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddInfoPage(
                        userType: role,
                        uid: id,
                        name: name,
                        address: address,
                        phone: phone,
                        email: email,
                        price: price,
                      )));
            },
            icon: Icon(Icons.edit,color: Color(0xFFB3261E),))
      ],),
      body: Container(
        // color: Color(0xffFFF5E9),
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                  children: [
                    StreamBuilder(

                     stream: FirebaseFirestore.instance.collection('artist').doc(id).snapshots(),

                      builder: (context,snapshot){
                       if(snapshot.connectionState==ConnectionState.waiting){

                         return CircleAvatar(
                           child: Center(child: CircularProgressIndicator(),),
                         );
                       }

                       if(snapshot.hasError){
                         return CircleAvatar(
                           child: Center(child: CircularProgressIndicator(),),
                         );

                       }

                       if(snapshot.hasData){

                         return CircleAvatar(
                             radius: 45,
                             backgroundColor: Colors.grey,
                             backgroundImage: NetworkImage(snapshot.data!['imageUrl'])
                         );
                       }

                       else{

                         return CircleAvatar(
                           child: Center(child: CircularProgressIndicator(),),
                         );
                       }

                      }
                      ,
                    ),



                    AppText(
                      data: '${name ?? ""}',
                      color: Color(0xFFB3261E),fw: FontWeight.w600,size: 20,
                    ),
                  ]),

            ),
            SizedBox(height: 30,),


            AppText(data: cat,color: Colors.black,size: 15,),
            Divider(),
            SizedBox(height: 20,),


            AppText( data: businessDetails,color: Colors.black,size: 15,),
            Divider(),
            SizedBox(height: 20,),






            // Container(
            //   width: double.infinity,
            //   height: 200,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(15),
            //       boxShadow: const [
            //         BoxShadow(
            //
            //           offset: Offset(2.0, 2.0),
            //           color: Colors.black12,
            //           blurRadius: 15,
            //           spreadRadius: 1.0,
            //         ),
            //         BoxShadow(
            //           color:Colors.white,
            //           // Color(0xffFFF5E9),
            //           offset: Offset(-2.0, -2.0),
            //           blurRadius: 15,
            //           spreadRadius: 0.5,
            //         )
            //       ]
            //   ),
            //
            //
            //   child:
              AppText(
                data: '${address ?? ""}',
                color: Colors.black,size: 15,
              ),
            Divider(),
            SizedBox(height: 20,),

            // ),
            // SizedBox(height: 20,),
            AppText(
              data: '${phone ?? ""}',
              color: Colors.black,size: 15,
            ),
            Divider(),
            SizedBox(height: 20,),


            AppText(
              data: '${price ?? ""}',
              color: Colors.black,size: 15,
            ),
            Divider(),
            SizedBox(height: 20,),

            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>WorkshopListScreen(artistId: id,)));
                },
                child: AppText(data: "WorkShop",color: Color(0xFFB3261E),size: 15,)),
            Divider(),
            SizedBox(height: 20,),



            InkWell(
                onTap: ()async{
                  await AuthService().logout().then((value) => Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false));
                },
                child: AppText(data: "LogOut",color: Color(0xFFB3261E),size: 15,)),
            Divider()


          ],
        ),
      ),);
  }
}