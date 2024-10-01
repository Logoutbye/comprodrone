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
      id: map['id'],
      contractNumber: map['contractNumber'],
      buyerName: map['buyerName'],
      buyerEmail: map['buyerEmail'],
      buyerPhone: map['buyerPhone'],
      buyerCity: map['buyerCity'],
      sellerName: map['sellerName'],
      sellerEmail: map['sellerEmail'],
      sellerPhone: map['sellerPhone'],
      sellerCity: map['sellerCity'],
      droneModel: map['droneModel'],
      price: map['price'],
      commission: map['commission'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
