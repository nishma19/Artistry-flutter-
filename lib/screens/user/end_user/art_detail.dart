import 'package:artistry/models/cart_model.dart';
import 'package:artistry/screens/user/end_user/review/review.dart';
import 'package:artistry/screens/user/end_user/review/write_review.dart';
import 'package:artistry/services/cart_service.dart';
import 'package:artistry/services/wishlist_service.dart';
import 'package:artistry/widgets/apptext.dart';
import 'package:flutter/material.dart';

class ArtDetails extends StatefulWidget {
  final Map<String, dynamic>? productData;
  final String? docId;
  final Map<String, bool>? wishlistStatus;
  final WishlistService? wishlistService;


  const ArtDetails({
    Key? key,
     this.productData,
     this.docId,
     this.wishlistStatus,
     this.wishlistService,
  }) : super(key: key);

  @override
  State<ArtDetails> createState() => _ArtDetailsState();
}

class _ArtDetailsState extends State<ArtDetails> {
  late Map<String, bool> wishlistStatus;
  late WishlistService _wishlistService;
  late String docId;
  late CartService _cartService;


  @override
  void initState() {
    super.initState();
    wishlistStatus = widget.wishlistStatus!;
    _wishlistService = widget.wishlistService!;
    docId = widget.docId!;

    _cartService = CartService();
    _cartService.loadCart();
  }


  void _addToCart() {
    final cartItem = CartModel(
      productId: widget.docId!,
      name: widget.productData!['name'],
      price: widget.productData!['price'],
      quantity: 1,
      imageUrl: widget.productData!['imageUrl'],
    );
    _cartService.addToCart(cartItem);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    String description =
        "Crafted with passion and precision,\neach piece reflects the artisan's mastery,\nweaving together tradition and innovation into\ntangible beauty.";

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              wishlistStatus[docId] == true ? Icons.favorite : Icons.favorite_border,
              color: wishlistStatus[docId] == true ? Color(0xffD77272) : Colors.grey,
            ),
            onPressed: () {
              final productData = {
                'productId': docId,
                'name': widget.productData!['name'],
                'price': widget.productData!['price'],
                'imageUrl': widget.productData!['imageUrl'],
              };
              setState(() {
                wishlistStatus[docId] = wishlistStatus[docId] != true;
              });
              _wishlistService.toggleWishlist(docId, productData);
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 400,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    widget.productData!['imageUrl'],
                    height: 350,
                    width: 400,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height:450,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.currency_rupee,
                            size: 30,
                          ),
                          AppText(
                              data: widget.productData!['price'].toString(),
                              size: 25,
                              fw: FontWeight.w800),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AppText(
                        data: widget.productData!['name'],
                        size: 20,
                        fw: FontWeight.w500,
                      ),
                      AppText(
                        data: widget.productData!['artistName'],
                        color: Color(0xFFB3261E),
                        size: 20,
                        fw: FontWeight.w600,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: description
                            .split('\n')
                            .map((line) => AppText(
                          data: line,
                          color: Color(0xffD77272),
                          size: 15,
                        ))
                            .toList(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AppText(
                        data: "Review&Rating",
                        size: 20,
                        fw: FontWeight.w600,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
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
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WriteReviewPage()));
                          },
                          child: Center(
                            child: Text(
                              "Write a Review",
                              style: TextStyle(
                                color: Colors.black26,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserReviewPage()));
                          },
                          child: Center(
                              child: AppText(
                                data: "View Reviews",
                                color: Color(0xFFB3261E),
                                size: 15,
                                fw: FontWeight.w700,
                              ))),


                      SizedBox(height: 10,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: _addToCart,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xffFFF5E9),
                            ),
                            child: Text(
                              "Add to Cart",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xffD77272),
                              ),
                            ),
                          ),
                ElevatedButton(
                  onPressed: () {
                    // Add your onPressed callback logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffFFF5E9),
                  ),
                  child: AppText(data: "Order Now",size: 15,fw: FontWeight.w500,color: Color(0xffD77272),),
                ),
                        ],
                      ),
                    ],
                  ),




                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
