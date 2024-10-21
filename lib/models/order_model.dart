class Order {
  String id;
  String date;
  String client;
  String email;
  String phone;
  String city;
  String need;
  String budget;
  String followUp;
  String remarks;

  Order({
    required this.id,
    required this.date,
    required this.client,
    required this.email,
    required this.phone,
    required this.city,
    required this.need,
    required this.budget,
    required this.followUp,
    required this.remarks,
  });

  // Converts the Order object to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'client': client,
      'email': email,
      'phone': phone,
      'city': city,
      'need': need,
      'budget': budget,
      'followUp': followUp,
      'remarks': remarks,
    };
  }

  // Creates an Order object from a map
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      date: map['date'],
      client: map['client'],
      email: map['email'],
      phone: map['phone'],
      city: map['city'],
      need: map['need'],
      budget: map['budget'],
      followUp: map['followUp'],
      remarks: map['remarks'],
    );
  }
}
