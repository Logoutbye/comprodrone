import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart' as order_model;

class OrderService {
  final CollectionReference orderCollection = FirebaseFirestore.instance.collection('orders');

  // Add new order to Firebase
  Future<void> addOrder(order_model.Order order) {
    return orderCollection.doc(order.id).set(order.toMap());
  }

  // Get all orders from Firebase
  Stream<List<order_model.Order>> getAllOrders() {
    return orderCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => order_model.Order.fromMap(doc.data() as Map<String, dynamic>)).toList());
  }

  // Update an order in Firebase
  Future<void> updateOrder(String id, order_model.Order updatedOrder) {
    return orderCollection.doc(id).update(updatedOrder.toMap());
  }

  // Delete an order from Firebase
  Future<void> deleteOrder(String id) {
    return orderCollection.doc(id).delete();
  }
}
