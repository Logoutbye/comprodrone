import 'package:com_pro_drone/models/buyer_model.dart';
import '../services/buyer_services.dart';
import 'package:flutter/material.dart';

class BuyerController extends ChangeNotifier {
  final BuyerService _buyerService = BuyerService();

  // List of buyers to store the current data
  List<Buyer> buyers = [];
  Buyer? currentBuyer;

  // Loading state
  bool isLoading = false;

  // Fetch all buyers in real-time using a stream
  void listenToAllBuyers() {
    _buyerService.getAllBuyers().listen((buyerList) {
      buyers = buyerList;
      notifyListeners(); // Notify listeners when data changes
    });
  }

  // Fetch a single buyer by ID in real-time using a stream
  void listenToBuyerById(String id) {
    _buyerService.getBuyerById(id).listen((buyer) {
      currentBuyer = buyer;
      notifyListeners(); // Notify listeners to update UI
    });
  }

  // Add a new buyer
  Future<void> addBuyer(Buyer buyer) async {
    isLoading = true;
    notifyListeners(); // Update UI for loading state
    await _buyerService.addBuyer(buyer);
    isLoading = false;
    notifyListeners(); // Update UI after adding the buyer
  }

  // Update an existing buyer
  Future<void> updateBuyer(String id, Buyer updatedBuyer) async {
    isLoading = true;
    notifyListeners();
    await _buyerService.updateBuyer(id, updatedBuyer);
    isLoading = false;
    notifyListeners();
  }

  // Delete a buyer
  Future<void> deleteBuyer(String id) async {
    isLoading = true;
    notifyListeners();
    await _buyerService.deleteBuyer(id);
    isLoading = false;
    notifyListeners();
  }
}
