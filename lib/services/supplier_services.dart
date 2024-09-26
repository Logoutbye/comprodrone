import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/supplier_model.dart';

class SupplierService {
  final CollectionReference _supplierCollection =
      FirebaseFirestore.instance.collection('suppliers');

  // Stream for all suppliers
  Stream<List<Supplier>> getAllSuppliers() {
    return _supplierCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Supplier.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Stream for a single supplier by ID
  Stream<Supplier?> getSupplierById(String id) {
    return _supplierCollection.doc(id).snapshots().map((doc) {
      if (doc.exists) {
        return Supplier.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  // Add a new supplier
  Future<bool> addSupplier(Supplier supplier) async {
    try {
      await FirebaseFirestore.instance
          .collection('suppliers')
          .doc(supplier.id)
          .set(supplier.toMap())
          .then((v) => print(":::: DONE SAVING ON FIREBASE"));
      print("Supplier added: ${supplier.name}");
      return true;
    } catch (e) {
      print("Failed to add supplier: $e");
      return false;
    }
  }

  // Update a supplier by ID
  Future<bool> updateSupplier(String id, Supplier updatedSupplier) async {
    try {
      await _supplierCollection.doc(id).update(updatedSupplier.toMap());
      print("Supplier updated: ${updatedSupplier.name}");
      return true;
    } catch (e) {
      print("Failed to update supplier: $e");
      return false;
    }
  }

  // Delete a supplier by ID
  Future<bool> deleteSupplier(String id) async {
    try {
      await _supplierCollection.doc(id).delete();
      print("Supplier deleted with ID: $id");
      return true;
    } catch (e) {
      print("Failed to delete supplier: $e");
      return false;
    }
  }
}
