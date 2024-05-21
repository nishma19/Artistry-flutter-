
import 'package:artistry/screens/user/end_user/cart_page.dart';
import 'package:artistry/screens/user/end_user/profile_page.dart';
import 'package:artistry/screens/user/end_user/saved_page.dart';
import 'package:artistry/screens/user/end_user/user_homepage.dart';
import 'package:artistry/services/auth_service.dart';
import 'package:flutter/material.dart';



class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {

  int _selectedIndex=0;

  List<Widget> _widgetOptions=[

    UserHomePage(),
    SavedItems(),
   ProfilePage(),
   CartPage()


    //  GridViewDemo()


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        bottomNavigationBar: ClipRRect(
          // borderRadius: BorderRadius.circular(12),
          child: BottomNavigationBar(
            selectedItemColor: Color(0xFFB3261E),
            unselectedItemColor: Colors.grey,
            showSelectedLabels:true,

            onTap: (value){
              setState(() {
                _selectedIndex=value;
              });
            },
            currentIndex:_selectedIndex,
            backgroundColor: Color(0xffF6E4CF),

            items: [

              BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home",),
              BottomNavigationBarItem(icon: Icon(Icons.bookmark),label: "Saved", ),
              BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile", ),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label: "Cart", ),


            ],
          ),
        ),


        drawer: Drawer(),
        // appBar: AppBar(
        //
        //   actions: [
        //
        //
        //     IconButton(onPressed: () async{
        //
        //       await AuthService().logout().then((value) => Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false));
        //
        //     }, icon: Icon(Icons.logout))
        //   ],
        // ),
        body: _widgetOptions.elementAt(_selectedIndex)
    );
  }
}