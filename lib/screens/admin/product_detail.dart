import 'package:flutter/material.dart';
import 'package:artistry/models/product_model.dart'; // Import Product model

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.product.imageUrl.isNotEmpty
                ? Image.network(widget.product.imageUrl)
                : Placeholder(fallbackHeight: 200),
            SizedBox(height: 20),
            Text('Name: ${widget.product.name}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Artist: ${widget.product.serviceName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Description: ${widget.product.description}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Price: \$${widget.product.price}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            // Text('Artist ID: ${widget.product.Id}', style: TextStyle(fontSize: 18)),
            // SizedBox(height: 10),
            // Add more product details here as needed
          ],
        ),
      ),
    );
  }
}
