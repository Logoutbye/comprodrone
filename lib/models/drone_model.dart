class Drone {
  String dId;             // Drone ID
  String sId;             // Seller ID
  String bId;             // Buyer ID
  String brand;
  bool status;
  String model;
  String serialNumber;
  double webPrice;        // Price on the website
  double customerPrice;   // Price given to the customer
  String commision;       // Commission for sale
  String followUp;        // Follow-up status or actions
  DateTime soldDate;
  String contractNo;      // Contract number for the sale

  Drone({
    required this.dId,
    required this.sId,
    required this.bId,
    required this.brand,
    required this.status,
    required this.model,
    required this.serialNumber,
    required this.webPrice,
    required this.customerPrice,
    required this.commision,
    required this.followUp,
    required this.soldDate,
    required this.contractNo,
  });

  // Convert to Map (useful for Firestore or other database storage)
  Map<String, dynamic> toMap() {
    return {
      'dId': dId,
      'sId': sId,
      'bId': bId,
      'brand': brand,
      'status': status,
      'model': model,
      'serialNumber': serialNumber,
      'webPrice': webPrice,
      'customerPrice': customerPrice,
      'commision': commision,
      'followUp': followUp,
      'soldDate': soldDate.toIso8601String(),  // Convert DateTime to ISO format
      'contractNo': contractNo,
    };
  }

  // Create from Map (e.g., for Firestore)
  factory Drone.fromMap(Map<String, dynamic> map) {
    return Drone(
      dId: map['dId'],
      sId: map['sId'],
      bId: map['bId'],
      brand: map['brand'],
      status: map['status'],
      model: map['model'],
      serialNumber: map['serialNumber'],
      webPrice: map['webPrice'],
      customerPrice: map['customerPrice'],
      commision: map['commision'],
      followUp: map['followUp'],
      soldDate: DateTime.parse(map['soldDate']),  // Parse ISO formatted date
      contractNo: map['contractNo'],
    );
  }
}
