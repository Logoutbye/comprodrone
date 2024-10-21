class Contract {
  String id;
  String contractNumber;
  String buyerName;
  String buyerEmail;
  String buyerPhone;
  String buyerCity;
  String sellerName;
  String sellerEmail;
  String sellerPhone;
  String sellerCity;
  String droneModel;
  String price;
  String commission;
  DateTime createdAt;

  Contract({
    required this.id,
    required this.contractNumber,
    required this.buyerName,
    required this.buyerEmail,
    required this.buyerPhone,
    required this.buyerCity,
    required this.sellerName,
    required this.sellerEmail,
    required this.sellerPhone,
    required this.sellerCity,
    required this.droneModel,
    required this.price,
    required this.commission,
    required this.createdAt,
  });

  // Converts Contract object to map for saving to Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contractNumber': contractNumber,
      'buyerName': buyerName,
      'buyerEmail': buyerEmail,
      'buyerPhone': buyerPhone,
      'buyerCity': buyerCity,
      'sellerName': sellerName,
      'sellerEmail': sellerEmail,
      'sellerPhone': sellerPhone,
      'sellerCity': sellerCity,
      'droneModel': droneModel,
      'price': price,
      'commission': commission,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Creates a Contract object from a map
  factory Contract.fromMap(Map<String, dynamic> map) {
    return Contract(
      id: map['id'] ?? '', // Default to an empty string if null
      contractNumber: map['contractNumber'] ?? '', // Default to empty string
      buyerName: map['buyerName'] ?? '', // Default to empty string
      buyerEmail: map['buyerEmail'] ?? '', // Default to empty string
      buyerPhone: map['buyerPhone'] ?? '', // Default to empty string
      buyerCity: map['buyerCity'] ?? '', // Default to empty string
      sellerName: map['sellerName'] ?? '', // Default to empty string
      sellerEmail: map['sellerEmail'] ?? '', // Default to empty string
      sellerPhone: map['sellerPhone'] ?? '', // Default to empty string
      sellerCity: map['sellerCity'] ?? '', // Default to empty string
      droneModel: map['droneModel'] ?? '', // Default to empty string
      price: map['price'] ?? '0', // Default to '0' in case of null
      commission: map['commission'] ?? '0', // Default to '0' in case of null
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(), // Default to the current time if null
    );
  }
}
