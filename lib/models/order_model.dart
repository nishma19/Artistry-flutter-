class OrderModel {
  final String orderId;
  final String userId;
  final String userName;
  final String userPhone;
  final String userAddress;
  final String productId;
  final String productName;
  final String productImageUrl;
  final String artistId;
  final String artistName;
  final String status;
  final DateTime createdAt;
  final DateTime deadline;
  final double productPrice;
  final String payment;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userAddress,
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.artistId,
    required this.artistName,
    required this.status,
    required this.createdAt,
    required this.deadline,
    required this.productPrice,
    required this.payment,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'userAddress': userAddress,
      'productId': productId,
      'productName': productName,
      'productImageUrl': productImageUrl,
      'artistId': artistId,
      'artistName': artistName,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'productPrice': productPrice,
      'payment': payment,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['orderId'],
      userId: json['userId'],
      userName: json['userName'],
      userPhone: json['userPhone'],
      userAddress: json['userAddress'],
      productId: json['productId'],
      productName: json['productName'],
      productImageUrl: json['productImageUrl'],
      artistId: json['artistId'],
      artistName: json['artistName'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      deadline: DateTime.parse(json['deadline']),
      productPrice: json['productPrice'],
      payment: json['payment'],
    );
  }
}
