import 'dart:convert';

import 'package:artistry/models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  List<CartModel> _cartItems = [];

  List<CartModel> get cartItems => _cartItems;

  final CollectionReference _cartCollection = FirebaseFirestore.instance.collection('cart');

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cartItems');
    if (cartData != null) {
      final List<dynamic> decodedData = jsonDecode(cartData);
      _cartItems = decodedData.map((item) => CartModel.fromJson(item)).toList();
    }

    // Load from Firestore
    QuerySnapshot querySnapshot = await _cartCollection.get();
    _cartItems = querySnapshot.docs.map((doc) => CartModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(_cartItems.map((item) => item.toJson()).toList());
    await prefs.setString('cartItems', encodedData);

    // Save to Firestore
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var item in _cartItems) {
      var docRef = _cartCollection.doc(item.productId);
      batch.set(docRef, item.toJson());
    }
    await batch.commit();
  }

  Future<void> addToCart(CartModel cartItem) async {
    int index = _cartItems.indexWhere((item) => item.productId == cartItem.productId);
    if (index != -1) {
      _cartItems[index] = CartModel(
        productId: _cartItems[index].productId,
        name: _cartItems[index].name,
        price: _cartItems[index].price,
        quantity: _cartItems[index].quantity + 1,
        imageUrl: _cartItems[index].imageUrl,
      );
    } else {
      _cartItems.add(cartItem);
    }
    await saveCart();
    await _cartCollection.doc(cartItem.productId).set(cartItem.toJson());
  }

  Future<void> removeFromCart(String productId) async {
    _cartItems.removeWhere((item) => item.productId == productId);
    await saveCart();
    await _cartCollection.doc(productId).delete();
  }

  Future<void> increaseQuantity(String productId) async {
    int index = _cartItems.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      _cartItems[index] = CartModel(
        productId: _cartItems[index].productId,
        name: _cartItems[index].name,
        price: _cartItems[index].price,
        quantity: _cartItems[index].quantity + 1,
        imageUrl: _cartItems[index].imageUrl,
      );
      await saveCart();
      await _cartCollection.doc(productId).update({'quantity': _cartItems[index].quantity});
    }
  }

  Future<void> decreaseQuantity(String productId) async {
    int index = _cartItems.indexWhere((item) => item.productId == productId);
    if (index != -1 && _cartItems[index].quantity > 1) {
      _cartItems[index] = CartModel(
        productId: _cartItems[index].productId,
        name: _cartItems[index].name,
        price: _cartItems[index].price,
        quantity: _cartItems[index].quantity - 1,
        imageUrl: _cartItems[index].imageUrl,
      );
      await saveCart();
      await _cartCollection.doc(productId).update({'quantity': _cartItems[index].quantity});
    }
  }

  double getTotalAmount() {
    double total = 0;
    for (var item in _cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    await saveCart();

    // Clear Firestore collection
    QuerySnapshot querySnapshot = await _cartCollection.get();
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
