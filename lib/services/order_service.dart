import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:artistry/models/order_model.dart';

class OrderService {
  final CollectionReference _orderCollection = FirebaseFirestore.instance.collection('orders');

  Future<void> createOrder(OrderModel order) async {
    try {
      await _orderCollection.doc(order.orderId).set(order.toJson());
    } catch (e) {
      print('Error creating order: $e');
      throw e;
    }
  }
}
