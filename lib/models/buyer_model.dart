class Buyer {
  String id;
  String date;
  String buyer;
  String email;
  String phone;
  String city;
  String requirements;
  String remarks;
  String followUp; // 'follow up' cannot be used directly as it's two words, so 'followUp' is used.
  String notes;
  String budget;
  

  Buyer({

    required this.id,
    required this.date,
    required this.buyer,
    required this.email,
    required this.phone,
    required this.city,
    required this.requirements,
    required this.remarks,
    required this.followUp,
    required this.notes,
    required this.budget,

  });

  // Converts the Buyer object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'buyer': buyer,
      'email': email,
      'phone': phone,
      'city': city,
      'need': requirements,
      'quote': remarks,
      'followUp': followUp,
      'notes': notes,
      'budget': budget,
    };
  }

  // Creates a Buyer object from a map
  factory Buyer.fromMap(Map<String, dynamic> map) {
    return Buyer(
      id: map['id'],
      date: map['date'],
      buyer: map['buyer'],
      email: map['email'],
      phone: map['phone'],
      city: map['city'],
      requirements: map['need'],
      remarks: map['quote'],
      followUp: map['followUp'],
      notes: map['notes'],
      budget: map['budget'],
    );
  }
}
