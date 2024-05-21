import 'package:artistry/screens/user/end_user/art_detail.dart';
import 'package:artistry/services/wishlist_service.dart';
import 'package:flutter/material.dart';

class ArtBottomNav extends StatefulWidget {


  final Map<String, dynamic>? productData;
  final String? docId;
  final Map<String, bool>? wishlistStatus;
  final WishlistService? wishlistService;
  const ArtBottomNav({ Key? key,
    this.productData,
    this.docId,
    this.wishlistStatus,
    this.wishlistService,
  }) : super(key: key);

  @override
  State<ArtBottomNav> createState() => _ArtBottomNavState();
}

class _ArtBottomNavState extends State<ArtBottomNav> {


  late Map<String, bool> wishlistStatus;
  late WishlistService _wishlistService;
  late String docId;


  @override
  void initState() {
    super.initState();
    wishlistStatus = widget.wishlistStatus!;
    _wishlistService = widget.wishlistService!;
    docId = widget.docId!;
  }

  int _selectedIndex=0;

  List<Widget> _widgetOptions=[

    ArtDetails(),


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

              BottomNavigationBarItem(icon:InkWell
                (onTap: (){
                  Navigator.pushNamed(context, 'orderpage');
              },

                  child: Icon(Icons.shopping_cart_checkout_outlined)) ,label: " Order Now",

              ),

              BottomNavigationBarItem(
                icon: InkWell(
                    onTap: () {

                      Navigator.pushNamed(context, 'cartpage',
                      //     arguments: {
                      //   'image': _widgetOptions[_selectedIndex].image,
                      // }
                      );
                    },
                    child: Icon(Icons.shopping_cart)
                ),
                label: "Add To Cart",

              ),

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