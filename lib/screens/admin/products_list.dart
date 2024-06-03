import 'package:artistry/screens/admin/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:artistry/services/product_service.dart'; // Import ProductService
import 'package:artistry/models/product_model.dart'; // Import Product model

class ProductListScreen extends StatefulWidget {
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ProductService _productService = ProductService();
  late Future<List<Product>> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = _productService.getProducts();
  }

  Future<void> _deleteUser(String productId) async {
    try {
      await _productService.deleteProduct(productId);
      // Refresh product list after deletion
      setState(() {
        _productFuture = _productService.getProducts();
      });
    } catch (e) {
      // Handle error
      print('Error deleting product: $e');
    }
  }

  Future<void> _showDeleteConfirmationDialog(String productId, String productName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete $productName?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                _deleteUser(productId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Products'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Color(0xFFB3261E)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found.'));
          } else {
            // Display products in a ListView
            List<Product> products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                // Extract product information
                Product product = products[index];
                String productName = product.name;
                String imageUrl = product.imageUrl;
                String artistName = product.serviceName;

                // Return a ListTile with product information
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                  child: Dismissible(
                    key: UniqueKey(), // Provide a unique key for each Dismissible
                    onDismissed: (direction) {
                      // Delete the user when dismissed
                      _deleteUser(product.id!);
                    },
                    background: Container(color: Colors.grey), // Add background color when swiping
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to product detail screen when tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(productName),
                          subtitle: Text('Artist: $artistName'),
                          // Add image widget to display the product image
                          leading: imageUrl.isNotEmpty ? Image.network(imageUrl) : SizedBox(),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Trigger deletion when delete button is pressed
                              _showDeleteConfirmationDialog(product.id!, productName);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
