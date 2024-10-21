import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import '../models/drone_model.dart'; // Import the Drone model

class DroneService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collection = 'drones'; // Firestore collection name

  // Add a new drone
  Future<void> addDrone(Drone drone) async {
    await _firestore.collection(collection).doc(drone.dId).set(drone.toMap());
  }

  // Update a drone
  Future<void> updateDrone(String dId, Drone drone) async {
    await _firestore.collection(collection).doc(dId).update(drone.toMap());
  }

  // Delete a drone
  Future<void> deleteDrone(String dId) async {
    await _firestore.collection(collection).doc(dId).delete();
  }

  // Fetch all drones for a specific seller by seller ID
  Stream<List<Drone>> getDronesBySellerId(String sId) {
    return _firestore
        .collection(collection)
        .where('sId', isEqualTo: sId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Drone.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Fetch all drones
  Stream<List<Drone>> getAllDrones() {
    return _firestore.collection(collection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Drone.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
