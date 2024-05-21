import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addToWishlist(Map<String, dynamic> productData) async {
    try {
      await _firestore.collection('wishlist').add(productData);
    } catch (e) {
      throw ('Failed to add to wishlist: $e');
    }
  }

  Future<void> removeFromWishlist(String productId) async {
    try {
      await _firestore.collection('wishlist').doc(productId).delete();
    } catch (e) {
      throw ('Failed to remove from wishlist: $e');
    }
  }

  Stream<List<String>> getWishlistProducts() {
    return _firestore.collection('wishlist').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc['productId'] as String).toList();
    });
  }

  Future<void> toggleWishlist(String productId, Map<String, dynamic> productData) async {
    try {
      final wishlistCollection = _firestore.collection('wishlist');
      final snapshot = await wishlistCollection.where('productId', isEqualTo: productId).get();

      if (snapshot.docs.isEmpty) {
        // Product is not in the wishlist, add it
        await addToWishlist(productData);
      } else {
        // Product is in the wishlist, remove it
        await removeFromWishlist(snapshot.docs.first.id);
      }
    } catch (e) {
      throw ('Failed to toggle wishlist: $e');
    }
  }
}
