import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/buyer_model.dart';

class BuyerService {
  final CollectionReference _buyerCollection =
      FirebaseFirestore.instance.collection('buyers');

  // Stream for all buyers
  Stream<List<Buyer>> getAllBuyers() {
    return _buyerCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Buyer.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
  

  // Stream for a single buyer by ID
  Stream<Buyer?> getBuyerById(String id) {
    return _buyerCollection.doc(id).snapshots().map((doc) {
      if (doc.exists) {
        return Buyer.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  // Add a new buyer
  Future<void> addBuyer(Buyer buyer) async {
    try {
      await _buyerCollection.doc(buyer.id).set(buyer.toMap());
      print("Buyer added: ${buyer.buyer}");
    } catch (e) {
      print("Failed to add buyer: $e");
    }
  }

  // Update a buyer by ID
  Future<bool> updateBuyer(String id, Buyer updatedBuyer) async {
    try {
      await _buyerCollection.doc(id).update(updatedBuyer.toMap());
      print("Buyer updated: ${updatedBuyer.buyer}");
      return true;
    } catch (e) {
      print("Failed to update buyer: $e");
      return false;
    }
  }

  // Delete a buyer by ID
  Future<bool> deleteBuyer(String id) async {
    try {
      await _buyerCollection.doc(id).delete();
      print("Buyer deleted with ID: $id");
      return true;
    } catch (e) {
      print("Failed to delete buyer: $e");
      return false;
    }
  }
}
