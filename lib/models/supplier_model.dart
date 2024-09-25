
class Supplier {
  String id;
  String name;
  String contactDetails;

  Supplier({
    required this.id,
    required this.name,
    required this.contactDetails,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contactDetails': contactDetails,
    };
  }

  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      id: map['id'],
      name: map['name'],
      contactDetails: map['contactDetails'],
    );
  }
}
