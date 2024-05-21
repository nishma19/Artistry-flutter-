import 'package:artistry/screens/admin/admin_home.dart';
import 'package:artistry/screens/admin/admin_profilee.dart';
import 'package:flutter/material.dart';

class AdminBottomNavBarPage extends StatefulWidget {
  const AdminBottomNavBarPage({super.key});

  @override
  State<AdminBottomNavBarPage> createState() => _AdminBottomNavBarPageState();
}

class _AdminBottomNavBarPageState extends State<AdminBottomNavBarPage> {

  int _selectedIndex=0;

  List<Widget> _widgetOptions=[

    AdminHomePage(),

    AdminProfilePage(),



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
              // BottomNavigationBarItem(icon: Icon(Icons.save),label: "Saved", ),
              BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile", ),
              // BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label: "Cart", ),


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