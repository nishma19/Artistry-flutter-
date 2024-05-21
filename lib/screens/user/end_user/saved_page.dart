import 'package:artistry/screens/user/end_user/art_detail.dart';
import 'package:flutter/material.dart';
import 'package:artistry/services/wishlist_service.dart'; // Import your wishlist service
import 'package:artistry/services/product_service.dart'; // Import your product service
import 'package:artistry/widgets/apptext.dart';

class SavedItems extends StatefulWidget {
  const SavedItems({Key? key}) : super(key: key);

  @override
  State<SavedItems> createState() => _SavedItemsState();
}

class _SavedItemsState extends State<SavedItems> {
  late List<Map<String, dynamic>> wishlistItems;
  late WishlistService _wishlistService;
  late ProductService _productService;
  Map<String, bool> wishlistStatus = {};

  void initState() {
    super.initState();
    _wishlistService = WishlistService(); // Initialize your wishlist service
    _productService = ProductService(); // Initialize your product service
    wishlistItems = []; // Initialize the list of wishlist items
    fetchWishlistItems(); // Fetch wishlist items when the widget initializes
  }

  Future<void> fetchWishlistItems() async {
    // Fetch wishlist item IDs from the wishlist service
    try {
      List<String> itemIds = await _wishlistService.getWishlistProducts().first;
      // Fetch details of each wishlist item from the product service
      List<Map<String, dynamic>> items = [];
      for (String itemId in itemIds) {
        Map<String, dynamic>? productData = await _productService.getProductById(itemId);
        if (productData != null) {
          items.add(productData);
          wishlistStatus[itemId] = true; // Set wishlist status for each item
        }
      }
      setState(() {
        wishlistItems = items;
      });
    } catch (e) {
      // Handle error if any
      print('Failed to fetch wishlist items: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xffFFF5E9),
          title: AppText(data: "Wishlist",color: Color(0xFFB3261E),size: 20,fw: FontWeight.w600,)
      ),
      body: GridView.builder(
        itemCount: wishlistItems.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of columns in the grid
            crossAxisSpacing: 10.0, // Spacing between columns
            mainAxisSpacing: 10.0, // Spacing between rows
            childAspectRatio: 0.75
        ),
        itemBuilder: (context, index) {
          var product = wishlistItems[index];
          var docId = product['productId'];

          return GestureDetector(
            onTap: () {
              print('Product: $product');
              print('DocId: $docId');
              print('WishlistStatus: $wishlistStatus');
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
                          '\$${product['price']}',
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
      ),
    );
  }
}

