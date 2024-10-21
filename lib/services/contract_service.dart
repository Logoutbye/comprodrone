import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/contract_model.dart';

class ContractService {
  final CollectionReference _contractCollection =
      FirebaseFirestore.instance.collection('contracts');

  // Stream for all contracts
  Stream<List<Contract>> getAllContracts() {
    return _contractCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Contract.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Add a new contract
  Future<void> addContract(Contract contract) async {
    try {
      await _contractCollection.doc(contract.id).set(contract.toMap());
      print("Contract added: ${contract.contractNumber}");
    } catch (e) {
      print("Failed to add contract: $e");
    }
  }

  // Delete a contract by ID
  Future<bool> deleteContract(String id) async {
    try {
      await _contractCollection.doc(id).delete();
      print("Contract deleted with ID: $id");
      return true;
    } catch (e) {
      print("Failed to delete contract: $e");
      return false;
    }
  }
}
