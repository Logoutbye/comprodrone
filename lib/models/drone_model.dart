class Drone {
  String dId;             // Drone ID
  String sId;             // Seller ID
  String bId;             // Buyer ID
  String brand;
  bool status;
  String model;
  String serialNumber;
  String webPrice;        // Price on the website
  String customerPrice;   // Price given to the customer
  String commision;       // Commission for sale
  String followUp;        // Follow-up status or actions
  DateTime? soldDate;     // Sold date (optional)
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
    this.soldDate,         // Make soldDate optional
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
      'soldDate': soldDate?.toIso8601String(),  // Convert DateTime to ISO format, null if soldDate is null
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
      soldDate: map['soldDate'] != null ? DateTime.parse(map['soldDate']) : null,  // Handle null value
      contractNo: map['contractNo'],
    );
  }
}
