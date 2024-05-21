import 'package:artistry/services/auth_service.dart';
import 'package:artistry/widgets/apptext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  TextEditingController _search = TextEditingController();
  bool hasUnreadNotifications = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: 350,
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
                  Navigator.pushNamed(context, 'usernotifcn');
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: CustomScrollView(
         slivers: [ SliverFillRemaining(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AppText(
                    data: "Pending Approvals",
                    size: 20,
                    fw: FontWeight.w700,
                    color: Color(0xFFB3261E),
                  ),
                ),
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
                            radius: 25,
                            backgroundImage: AssetImage("assets/img/billie.jpg"),
                          ),
                          title: AppText(data: "Billie Eilish",color:Color(0xFFB3261E) ,),
                          subtitle: AppText(data: "Artist",color:Colors.grey ,) ,
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

                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AppText(
                    data: "All Users",
                    size: 20,
                    fw: FontWeight.w700,
                    color: Color(0xFFB3261E),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(
                         color:  Color(0xffFFF5E9),
                            border: Border( bottom: BorderSide(
                              color: Color(0xFFB3261E),
                              width: 4.0,
                              style: BorderStyle.solid),),
                        ),
                        child:Center(
                          child: AppText(
                            data: "Artists",
                            size: 15,
                            fw: FontWeight.w700,
                            color: Color(0xFFB3261E),
                          ),
                        ),
                      ),
                    ),

                    Expanded(

                      child: Container(
                        height: 40,
                        width: 200,
                        decoration: BoxDecoration(

                          border: Border( bottom: BorderSide(
                              color: Color(0xffffcdd2),
                              width: 4.0,
                              style: BorderStyle.solid),),
                        ),
                        child:Center(
                          child: AppText(
                            data: "Users",
                            size: 15,
                            fw: FontWeight.w700,
                            color: Colors.red[100],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 10,),


                ListView.builder(
                  itemCount: 2,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Card(
                            elevation: 3,
                            shadowColor: Colors.orange[300],
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage("assets/img/billie.jpg"),
                              ),
                              title: AppText(data: "Billie Eilish",color:Color(0xFFB3261E) ,),
                              subtitle: AppText(data: "Artist",color:Colors.grey ,) ,
                              trailing: SizedBox(
                                width: 100, // Specify a fixed width for the trailing widget
                                child:
                                   Container(
                                     height: 40,
                                     width: 50,
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadiusDirectional.circular(15),
                                       color: Colors.red[200],
                                     ),
                                     child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                        Image.asset("assets/img/cross.png") ,
                                         AppText(data: "Ban User",color:Color(0xFFB3261E) ,fw: FontWeight.w600,),
                                       ],
                                     ),
                                   )



                              ),
                            ),
                            color: Color(0xffF6E4CF),
                          ),


                          Card(
                            elevation: 3,
                            shadowColor: Colors.orange[300],
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage("assets/img/billie.jpg"),
                              ),
                              title: AppText(data: "Billie Eilish",color:Color(0xFFB3261E) ,),
                              subtitle: AppText(data: "Artist",color:Colors.grey ,) ,
                              trailing: SizedBox(
                                  width: 100, // Specify a fixed width for the trailing widget
                                  child:
                                  Container(
                                    height: 40,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadiusDirectional.circular(15),
                                      color: Colors.green[200],
                                    ),
                                    child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset("assets/img/tick.png") ,
                                        AppText(data: "UnBan User",color:Colors.green[900] ,fw: FontWeight.w600,),
                                      ],
                                    ),
                                  )



                              ),
                            ),
                            color: Color(0xffF6E4CF),
                          ),


                        ],
                      ),
                    );
                  },
                ),

              ],
            ),

          ),
      ]
        ),


      ),
    );
  }
}
