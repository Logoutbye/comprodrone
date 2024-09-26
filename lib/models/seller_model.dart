class Seller {
  String id;
  String sellerName;
  String email;
  String phone;
  String city;
  String typeOfSeller;
  String address;
  String whatsappNo; // Link for WhatsApp contact

  Seller({
    required this.id,
    required this.sellerName,
    required this.email,
    required this.phone,
    required this.city,
    required this.typeOfSeller,
    required this.address,
    required this.whatsappNo,
  });

  // Convert to a Map (useful for Firestore or other database storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sellerName': sellerName,
      'email': email,
      'phone': phone,
      'city': city,
      'typeOfSeller': typeOfSeller,
      'address': address,
      'whatsappNo': whatsappNo,
    };
  }

  // Create from Map (e.g., for Firestore)
  factory Seller.fromMap(Map<String, dynamic> map) {
    return Seller(
      id: map['id'],
      sellerName: map['sellerName'],
      email: map['email'],
      phone: map['phone'],
      city: map['city'],
      typeOfSeller: map['typeOfSeller'],
      address: map['address'],
      whatsappNo: map['whatsappNo'],
    );
  }
}
