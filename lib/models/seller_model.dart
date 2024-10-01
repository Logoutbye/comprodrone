class Seller {
  String id;
  String sellerName;
  String email;
  String phone;
  String city;
  String typeOfSeller;
  String address;
  String whatsappNo;

  // New fields
  String fecha;
  String numero;
  String cliente;
  String dronAnunciado;
  double precioWeb;
  double precioCliente;
  double comision;
  String seguimiento;
  String estado;
  String observaciones;

  Seller({
    required this.id,
    required this.sellerName,
    required this.email,
    required this.phone,
    required this.city,
    required this.typeOfSeller,
    required this.address,
    required this.whatsappNo,
    required this.fecha,
    required this.numero,
    required this.cliente,
    required this.dronAnunciado,
    required this.precioWeb,
    required this.precioCliente,
    required this.comision,
    required this.seguimiento,
    required this.estado,
    required this.observaciones,
  });

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
      'fecha': fecha,
      'numero': numero,
      'cliente': cliente,
      'dronAnunciado': dronAnunciado,
      'precioWeb': precioWeb,
      'precioCliente': precioCliente,
      'comision': comision,
      'seguimiento': seguimiento,
      'estado': estado,
      'observaciones': observaciones,
    };
  }

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
      fecha: map['fecha'],
      numero: map['numero'],
      cliente: map['cliente'],
      dronAnunciado: map['dronAnunciado'],
      precioWeb: map['precioWeb'],
      precioCliente: map['precioCliente'],
      comision: map['comision'],
      seguimiento: map['seguimiento'],
      estado: map['estado'],
      observaciones: map['observaciones'],
    );
  }
}
