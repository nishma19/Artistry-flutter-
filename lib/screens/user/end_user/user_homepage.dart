import 'package:artistry/screens/user/end_user/art_detail.dart';
import 'package:artistry/screens/user/end_user/bottom_navigation.dart';
import 'package:artistry/services/artist_service.dart';
import 'package:artistry/services/wishlist_service.dart';

import 'package:artistry/widgets/customtextformfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../../models/artist_model.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage>
    with TickerProviderStateMixin {
  late Stream<QuerySnapshot> _productsStream;

  String _selectedProductName = '';
  TabController? _tabController;

  TextEditingController _search = TextEditingController();
  late ArtistService _artistService;

  bool hasUnreadNotifications = true;
  int? selectedCardIndex;

  late WishlistService _wishlistService;

  Map<String, bool> wishlistStatus = {};

  @override
  void initState() {
    super.initState();
    _productsStream =
        FirebaseFirestore.instance.collection('products').snapshots();
    _artistService = ArtistService();
    _wishlistService = WishlistService(); // Initialize ArtistService
    _tabController = TabController(length: categories.length, vsync: this);
    _fetchData();

    _fetchWishlistStatus();
  }


  Future<void> _fetchWishlistStatus() async {
    _wishlistService.getWishlistProducts().listen((productIds) {
      setState(() {
        wishlistStatus = {for (var id in productIds) id: true};
      });
    });
  }


  Future<void> _fetchData() async {
    // Fetch all artists
    artists = await _artistService.getArtists();

    // Fetch distinct categories
    categories = await _artistService.getDistinctCategories();

    // Rebuild tab system with updated categories
    setState(() {
      _tabController = TabController(length: categories.length, vsync: this);
    });
  }

  List<String> categories = [];

  List<Artist> artists = []; // Assuming Artist is your data model

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

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

      // drawer:Drawer() ,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        // color: Color(0xffFFF5E9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10),
              child: Text(
                "Artist",
                style: TextStyle(
                    color: Color(0xFFB3261E),
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),

            categories.isEmpty
                ? CircularProgressIndicator() // Show loading indicator while fetching data
                : TabBar(
                    controller: _tabController,
                    tabs: categories
                        .map((category) => Tab(text: category))
                        .toList(),
                  ),

            // Tab Bar View with Dynamic Content
            Container(
              height: 155,
              child: TabBarView(
                controller: _tabController,
                children: categories.map((category) {
                  // Filter artists by category
                  final categoryArtists = artists
                      .where((artist) => artist.category == category)
                      .toList();

                  // Return widget for each category
                  return ListView.builder(
                    itemCount: categoryArtists.length,
                    itemBuilder: (context, index) {
                      final artist = categoryArtists[index];
                      print(artist.imageUrl);
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'artistdetail',
                              arguments: artist);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              artist.imageUrl == ""
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/img/person.png',
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                          Container(
                                            color:
                                                Colors.white.withOpacity(0.4),
                                            child: Column(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${artist.name.toUpperCase()}",
                                                  style: TextStyle(
                                                      color: Color(0xFFB3261E),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  "${artist.category.toUpperCase()}",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ))
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Column(
                                        children: [
                                          Image.network(
                                            '${artist.imageUrl}',
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                          Container(
                                            color:
                                                Colors.white.withOpacity(0.4),
                                            child: Column(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${artist.name.toUpperCase()}",
                                                  style: TextStyle(
                                                      color: Color(0xFFB3261E),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  "${artist.category.toUpperCase()}",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                "Art",
                style: TextStyle(
                    color: Color(0xFFB3261E),
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),

            SizedBox(
              height: 50, // Adjust the height as needed
              child: StreamBuilder<QuerySnapshot>(
                stream: _productsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                  List<String> productNames = documents
                      .map((doc) => doc['name'] as String)
                      .toSet()
                      .toList();

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productNames.length,
                    itemBuilder: (BuildContext context, int index) {
                      String productName = productNames[index];
                      bool isSelected = _selectedProductName == productName;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedProductName = productName;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Card(
                            elevation: 7,
                            color: isSelected
                                ? Color(0xffD77272)
                                : Color(0xffF6E4CF), // Change color if selected
                            shadowColor: Colors.orange[300],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  productName,
                                  style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Color(0xffD77272)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            SizedBox(
              height: 10,
            ),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _productsStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
                  if (_selectedProductName.isNotEmpty) {
                    documents = documents.where((doc) {
                      return doc['name'] == _selectedProductName;
                    }).toList();
                  }

                  // var documents = snapshot.data!.docs;





                  return GridView.builder(
                    itemCount: documents.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns in the grid
                      crossAxisSpacing: 10.0, // Spacing between columns
                      mainAxisSpacing: 10.0, // Spacing between rows
                        childAspectRatio: 0.75
                    ),
                    itemBuilder: (context, index) {
                      var product = documents[index].data() as Map<String, dynamic>;
                      var docId = documents[index].id;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArtDetails(
                                productData: product,
                                docId: docId,
                                wishlistStatus: wishlistStatus,
                                wishlistService: _wishlistService,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                  child: Image.network(
                                    product['imageUrl'],
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  product['name'],
                                  style: TextStyle(
                                    color: Color(0xFFB3261E),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\u{20B9}${product['price']}',
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        wishlistStatus[docId] == true
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: wishlistStatus[docId] == true
                                            ? Color(0xffD77272)
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        final productData = {
                                          'productId': docId,
                                          'name': product['name'],
                                          'price': product['price'],
                                          'imageUrl': product['imageUrl'],
                                        };
                                        setState(() {
                                          wishlistStatus[docId] = wishlistStatus[docId] != true;
                                        });
                                        _wishlistService.toggleWishlist(docId, productData);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// SingleChildScrollView(
// scrollDirection: Axis.horizontal,
// child: Padding(
// padding: const EdgeInsets.only(left: 10.0,right: 20,),
// child: Row(
// children: List.generate(cardNames1.length, (index) {
// return GestureDetector(
// onTap: () {
// selectCard1(index);
// },
// child: Card(
// elevation: 7,
// color: selectedCardIndex1 == index ? Color(0xffD77272) : Color(0xffF6E4CF),
// shadowColor: Colors.orange[300],
// child: Padding(
// padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
// child:selectedCardIndex1 == index ?  Text(cardNames1[index], style: TextStyle(color: Colors.white,fontSize: 15))
//     : Text(cardNames1[index], style: TextStyle(color: Color(0xffD77272),fontSize: 15))
// ),
// ),
// );
// }),
// ),
// ),
//
//
// ),
//

// Expanded(
// child: Padding(
// padding: const EdgeInsets.all(20.0),
// child: GridView.count(
// crossAxisCount: 2,
// mainAxisSpacing: 4,
// crossAxisSpacing: 4,
// shrinkWrap: true,
// children: List.generate(
// 12, // Adjust the number of children as needed
// (index) {
// return Stack(
// children: [ ClipRRect(
// borderRadius: BorderRadius.circular(20),
// child: Image.asset(
// 'assets/img/artrim3.jpg',
// height: 200,
// width: 200,
// fit: BoxFit.cover,
// )),
//
// Positioned(
// bottom:0,
// right:0,left:0,
//
//
// child: Container(
// height:40,
// width:100,
//
//
// decoration:BoxDecoration(
//
// color:Color(0xffF6E4CF).withOpacity(0.8),
// borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)
// , )
// ),
// child: Column(
// children: [
// Text("The Pic",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Color(0xffD77272)),),
// Text("JohnDoe",style: TextStyle(fontSize: 10,fontWeight: FontWeight.w500,color: Colors.black54),)
// ],
// ),
// ),
// ),
//
// ]
// );
// },
// ),
// ),
// ),
// ),
