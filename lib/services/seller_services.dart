import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com_pro_drone/models/seller_model.dart';

class SellerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _sellersCollection => _firestore.collection('sellers');

  // Add a new seller
  Future<void> addSeller(Seller seller) async {
    await _sellersCollection.doc(seller.id).set(seller.toMap());
  }

  // Update an existing seller
  Future<void> updateSeller(String id, Seller seller) async {
    await _sellersCollection.doc(id).update(seller.toMap());
  }

  // Delete a seller
  Future<void> deleteSeller(String id) async {
    await _sellersCollection.doc(id).delete();
  }

  // Retrieve all sellers as a stream
  Stream<List<Seller>> getAllSellers() {
    return _sellersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Seller.fromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }
}
