class Drone {
  String dId;             // Drone ID
  String sId;             // Seller ID
  String bId;             // Buyer ID
  String brand;
  String status;
  String model;
  String serialNumber;
  double webPrice;        // Price on the website
  double customerPrice;   // Price given to the customer
  String commision;       // Commission for sale
  String followUp;        // Follow-up status or actions
  DateTime soldDate;
  String contractNo;      // Contract number for the sale
  List<String> images;    // List of image URLs

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
    required this.images,
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
      'images': images,
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
      images: List<String>.from(map['images']),   // Convert the list to List<String>
    );
  }
}
