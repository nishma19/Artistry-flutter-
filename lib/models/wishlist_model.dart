class WishlistItem {
  final String productId;
  final bool isInWishlist;

  WishlistItem({required this.productId, required this.isInWishlist});

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'isInWishlist': isInWishlist,
    };
  }

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      productId: json['productId'],
      isInWishlist: json['isInWishlist'],
    );
  }
}