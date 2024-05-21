import 'package:artistry/models/cart_model.dart';
import 'package:artistry/services/cart_service.dart';
import 'package:artistry/widgets/apptext.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late CartService _cartService;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cartService = CartService();
    _loadCart();
  }

  Future<void> _loadCart() async {
    await _cartService.loadCart();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _removeFromCart(String productId) async {
    await _cartService.removeFromCart(productId);
    setState(() {});
  }

  Future<void> _increaseQuantity(String productId) async {
    await _cartService.increaseQuantity(productId);
    setState(() {});
  }

  Future<void> _decreaseQuantity(String productId) async {
    await _cartService.decreaseQuantity(productId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Color(0xffFFF5E9),
            title: AppText(data: "My Cart",color: Color(0xFFB3261E),size: 20,fw: FontWeight.w600,)
        ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _cartService.cartItems.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartService.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = _cartService.cartItems[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 0.4,
                    shadowColor: Colors.black,surfaceTintColor: Colors.red,


                    child: ListTile(
                      leading: Image.network(
                        cartItem.imageUrl,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(left: 10.0,top: 10),
                        child: Text(cartItem.name,style: TextStyle(color: Color(0xffD77272),fontWeight: FontWeight.w800),),
                      ),
                      subtitle: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove,),
                            onPressed: () async {
                              await _decreaseQuantity(cartItem.productId);
                            },
                          ),
                          Text('${cartItem.quantity}'),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () async {
                              await _increaseQuantity(cartItem.productId);
                            },
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete,color: Color(0xffD77272)),
                        onPressed: () async {
                          await _removeFromCart(cartItem.productId);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  data: 'Total Amount:',
                  size: 18,
                  fw: FontWeight.bold,
                  color: Color(0xFFB3261E),
                ),
                AppText(
                  data: '\u{20B9}${_cartService.getTotalAmount().toStringAsFixed(2)}',
                  size: 18,
                  fw: FontWeight.bold,
                  color: Color(0xFFB3261E),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Handle checkout
              },
              child: Text('Checkout',style:  TextStyle(color:  Color(0xFFB3261E),fontWeight: FontWeight.w800),),
              style: ElevatedButton.styleFrom(

                 backgroundColor: Color(0xffFFF5E9).withOpacity(0.3),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
