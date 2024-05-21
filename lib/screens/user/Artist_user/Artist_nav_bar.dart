
import 'package:artistry/screens/user/Artist_user/onlineClassesPage.dart';
import 'package:artistry/screens/user/Artist_user/add_media.dart';
import 'package:artistry/screens/user/Artist_user/add_product.dart';
import 'package:artistry/screens/user/Artist_user/aritst_homepage.dart';
import 'package:artistry/screens/user/Artist_user/artist_profile.dart';
import 'package:artistry/screens/user/Artist_user/product_order_details.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArtistBottomNavBarPage extends StatefulWidget {
  const ArtistBottomNavBarPage({super.key});

  @override
  State<ArtistBottomNavBarPage> createState() => _ArtistBottomNavBarPageState();
}

class _ArtistBottomNavBarPageState extends State<ArtistBottomNavBarPage> {
  // bool _isCrafter = false;
  @override
  void initState() {
    super.initState();
    getData();

    loadList();

  }

  int _selectedIndex=0;

  var role;
  var name;
  var id;
  var email;
  var phone;
  var cat;
  var address;
  var businessdetails;
  Map<String,dynamic>? data;
  getData() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();

     role = await _pref.getString('role');


      name = await _pref.getString('name');
      id = await _pref.getString('id');
      email = await _pref.getString('email');
      phone = await _pref.getString('phone');
      cat = await _pref.getString('category');
      address = await _pref.getString('address');
      businessdetails=await _pref.getString('businessDetails');

      var userName = name;


     data={
        'id':id


      };


      setState(() {

      });

    }


    List _widgetOptions=[];

  List<Widget>_widgets=[];

    loadList(){

      _widgets=[
        ArtistHomePage(),


        ArtistProfilePage(),
        AddMedia(),
      ];


     _widgetOptions=[

        ArtistHomePage(),
        ProductOrdersPage(),
        AddProduct(),

        ArtistProfilePage(),
        AddMedia(),
        // OnlineClassesPage(),



        //  GridViewDemo()


      ];
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

        bottomNavigationBar: ClipRRect(
          // borderRadius: BorderRadius.circular(12),
          child:businessdetails=="crafter"? BottomNavigationBar(
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
              BottomNavigationBarItem(icon: Icon(Icons.backup_table_outlined),label: "products orders",),

              BottomNavigationBarItem(icon: Icon(Icons.add),label: "Add Product", ),
              BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile", ),
              BottomNavigationBarItem(icon: Icon(Icons.add_a_photo),label: "Add Media", ),
              // BottomNavigationBarItem(icon: Icon(Icons.book_online_rounded),label: "Workshop", ),


            ],
          ):

          BottomNavigationBar(
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

              BottomNavigationBarItem(icon: Icon(Icons.person),label: "Profile", ),
              BottomNavigationBarItem(icon: Icon(Icons.add_a_photo),label: "Add Media", ),
              // BottomNavigationBarItem(icon: Icon(Icons.book_online_rounded),label: "Workshop", ),


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
        body:businessdetails=="crafter"? _widgetOptions.elementAt(_selectedIndex):_widgets[_selectedIndex]
    );
  }
}