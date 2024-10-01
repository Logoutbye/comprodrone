class Supplier {
  String id;
  String name;
  String contactDetails;

  // New fields
  String cliente;
  String empresa;
  String contacto;
  String email;
  String telefono;
  String ciudad;
  String paginaWeb;
  String observaciones;

  Supplier({
    required this.id,
    required this.name,
    required this.contactDetails,
    required this.cliente,
    required this.empresa,
    required this.contacto,
    required this.email,
    required this.telefono,
    required this.ciudad,
    required this.paginaWeb,
    required this.observaciones,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contactDetails': contactDetails,
      'cliente': cliente,
      'empresa': empresa,
      'contacto': contacto,
      'email': email,
      'telefono': telefono,
      'ciudad': ciudad,
      'paginaWeb': paginaWeb,
      'observaciones': observaciones,
    };
  }

  factory Supplier.fromMap(Map<String, dynamic> map) {
    return Supplier(
      id: map['id'],
      name: map['name'],
      contactDetails: map['contactDetails'],
      cliente: map['cliente'],
      empresa: map['empresa'],
      contacto: map['contacto'],
      email: map['email'],
      telefono: map['telefono'],
      ciudad: map['ciudad'],
      paginaWeb: map['paginaWeb'],
      observaciones: map['observaciones'],
    );
  }
}
