import 'package:artistry/screens/user/Artist_user/artist_regi.dart';
import 'package:artistry/screens/user/end_user/user_register_page.dart';
import 'package:flutter/material.dart';

class RegisterTab extends StatefulWidget {
  const RegisterTab({super.key});

  @override
  State<RegisterTab> createState() => _RegisterTabState();
}

class _RegisterTabState extends State<RegisterTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xffFFF5E9),
            // title:Text("Sign Up",style: TextStyle(color: Color(0xffD77272),fontSize: 30,fontWeight: FontWeight.w800),),
            bottom: TabBar(
              isScrollable: true,
              padding: EdgeInsets.all(20),
              labelPadding: EdgeInsets.all(10),
              indicatorColor: Color(0xffD77272),
              labelStyle: TextStyle(color: Color(0xffD77272)),
              tabs: [
                Text("User Registration"),
                Text("Artist Registration"),
              ],
            ),

          ),
          body: const TabBarView(
            children: [
              UserRegisterPage(),
              ArtistRegisterPage(),
            ],
          ),
        ),
      ),
    );
  }
}
