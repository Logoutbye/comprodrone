import 'package:com_pro_drone/models/seller_model.dart';
import 'package:com_pro_drone/view/add_drone.dart';
import 'package:com_pro_drone/view/add_seller_screen.dart';
import 'package:com_pro_drone/view/drone_list_screen.dart';
import 'package:flutter/material.dart';
import '../services/seller_services.dart';
import 'package:url_launcher/url_launcher.dart';

class SellerListScreen extends StatelessWidget {
  final SellerService sellerService = SellerService();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSellerScreen(),
                ),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
          ),
          appBar: AppBar(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            title: Text('Vendedores'),
            actions: [
              TextButton(
                child: Text(
                  'Ver Drones',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DroneListScreen()),
                  );
                },
              ),
              TextButton(
                child: Text(
                  'Agregar Drones',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddDroneScreen()),
                  );
                },
              ),
            ],
          ),
          body: Center(
            child: Column(
              children: [
                StreamBuilder<List<Seller>>(
                  stream: sellerService.getAllSellers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No se encontraron vendedores',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      );
                    }

                    List<Seller> sellers = snapshot.data!;
                    return _buildResponsiveDataTable(
                        context, sellers, constraints);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Construir la DataTable responsiva
  Widget _buildResponsiveDataTable(
      BuildContext context, List<Seller> sellers, BoxConstraints constraints) {
    final bool isSmallScreen = constraints.maxWidth < 600;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: DataTable(
            border: TableBorder.all(color: Colors.grey[300]!, width: 1),
            columns: _buildTableColumns(isSmallScreen),
            rows: sellers
                .map((seller) => _buildDataRow(context, seller, isSmallScreen))
                .toList(),
          ),
        ),
      ),
    );
  }

  // Crear las columnas de DataTable según el tamaño de la pantalla
  List<DataColumn> _buildTableColumns(bool isSmallScreen) {
    return [
      DataColumn(label: Text('ID', style: _tableHeaderStyle())),
      DataColumn(
          label: Text('Nombre del Vendedor', style: _tableHeaderStyle())),
      if (!isSmallScreen) ...[
        DataColumn(
            label: Text('Correo Electrónico', style: _tableHeaderStyle())),
        DataColumn(label: Text('Teléfono', style: _tableHeaderStyle())),
        DataColumn(label: Text('Ciudad', style: _tableHeaderStyle())),
        DataColumn(label: Text('Tipo', style: _tableHeaderStyle())),
        DataColumn(label: Text('Dirección', style: _tableHeaderStyle())),
        DataColumn(label: Text('WhatsApp', style: _tableHeaderStyle())),
        DataColumn(
            label: Text('Fecha', style: _tableHeaderStyle())), // New field
        DataColumn(
            label: Text('Número', style: _tableHeaderStyle())), // New field
        DataColumn(
            label: Text('Cliente', style: _tableHeaderStyle())), // New field
        DataColumn(
            label: Text('Dron Anunciado',
                style: _tableHeaderStyle())), // New field
        DataColumn(
            label: Text('Precio Web', style: _tableHeaderStyle())), // New field
        DataColumn(
            label: Text('Precio Cliente',
                style: _tableHeaderStyle())), // New field
        DataColumn(
            label: Text('Comisión', style: _tableHeaderStyle())), // New field
        DataColumn(
            label:
                Text('Seguimiento', style: _tableHeaderStyle())), // New field
        DataColumn(
            label: Text('Estado', style: _tableHeaderStyle())), // New field
        DataColumn(
            label:
                Text('Observaciones', style: _tableHeaderStyle())), // New field
      ],
      DataColumn(label: Text('Acciones', style: _tableHeaderStyle())),
    ];
  }

  // Crear DataRow para cada vendedor
  DataRow _buildDataRow(
      BuildContext context, Seller seller, bool isSmallScreen) {
    return DataRow(
      cells: [
        DataCell(Text(seller.id)),
        DataCell(Text(seller.sellerName)),
        if (!isSmallScreen) ...[
          DataCell(Text(seller.email)),
          DataCell(Text(seller.phone)),
          DataCell(Text(seller.city)),
          DataCell(Text(seller.typeOfSeller)),
          DataCell(Text(seller.address)),
          DataCell(Text(seller.whatsappNo)),
          DataCell(Text(seller.fecha)), // New field
          DataCell(Text(seller.numero)), // New field
          DataCell(Text(seller.cliente)), // New field
          DataCell(Text(seller.dronAnunciado)), // New field
          DataCell(Text(seller.precioWeb.toString())), // New field
          DataCell(Text(seller.precioCliente.toString())), // New field
          DataCell(Text(seller.comision.toString())), // New field
          DataCell(Text(seller.seguimiento)), // New field
          DataCell(Text(seller.estado)), // New field
          DataCell(Text(seller.observaciones)), // New field
        ],
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blueAccent),
                onPressed: () {
                  _showEditDialog(context, seller);
                },
                tooltip: 'Editar Vendedor',
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  _confirmDelete(context, seller.id);
                },
                tooltip: 'Eliminar Vendedor',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Método para lanzar WhatsApp
  void _launchWhatsApp(BuildContext context, String phoneNumber) async {
    String formattedNumber =
        phoneNumber.replaceAll('+', '').replaceAll('-', '');
    final Uri whatsappUri = Uri.parse("https://wa.me/$formattedNumber");

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("WhatsApp no está instalado en este dispositivo."),
        ),
      );
    }
  }

  // Método para mostrar el cuadro de diálogo de edición
  void _showEditDialog(BuildContext context, Seller seller) {
    final TextEditingController nameController =
        TextEditingController(text: seller.sellerName);
    final TextEditingController emailController =
        TextEditingController(text: seller.email);
    final TextEditingController phoneController =
        TextEditingController(text: seller.phone);
    final TextEditingController cityController =
        TextEditingController(text: seller.city);
    final TextEditingController typeController =
        TextEditingController(text: seller.typeOfSeller);
    final TextEditingController addressController =
        TextEditingController(text: seller.address);
    final TextEditingController whatsappController =
        TextEditingController(text: seller.whatsappNo);
    final TextEditingController fechaController =
        TextEditingController(text: seller.fecha);
    final TextEditingController numeroController =
        TextEditingController(text: seller.numero);
    final TextEditingController clienteController =
        TextEditingController(text: seller.cliente);
    final TextEditingController dronController =
        TextEditingController(text: seller.dronAnunciado);
    final TextEditingController precioWebController =
        TextEditingController(text: seller.precioWeb.toString());
    final TextEditingController precioClienteController =
        TextEditingController(text: seller.precioCliente.toString());
    final TextEditingController comisionController =
        TextEditingController(text: seller.comision.toString());
    final TextEditingController seguimientoController =
        TextEditingController(text: seller.seguimiento);
    final TextEditingController estadoController =
        TextEditingController(text: seller.estado);
    final TextEditingController observacionesController =
        TextEditingController(text: seller.observaciones);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Vendedor'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(nameController, 'Nombre del Vendedor'),
                _buildTextField(emailController, 'Correo Electrónico'),
                _buildTextField(phoneController, 'Teléfono'),
                _buildTextField(cityController, 'Ciudad'),
                _buildTextField(typeController, 'Tipo de Vendedor'),
                _buildTextField(addressController, 'Dirección'),
                _buildTextField(whatsappController, 'WhatsApp No'),
                _buildTextField(fechaController, 'Fecha'),
                _buildTextField(numeroController, 'Número'),
                _buildTextField(clienteController, 'Cliente'),
                _buildTextField(dronController, 'Dron Anunciado'),
                _buildTextField(precioWebController, 'Precio Web'),
                _buildTextField(precioClienteController, 'Precio Cliente'),
                _buildTextField(comisionController, 'Comisión'),
                _buildTextField(seguimientoController, 'Seguimiento'),
                _buildTextField(estadoController, 'Estado'),
                _buildTextField(observacionesController, 'Observaciones'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Seller updatedSeller = Seller(
                  id: seller.id,
                  sellerName: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  city: cityController.text,
                  typeOfSeller: typeController.text,
                  address: addressController.text,
                  whatsappNo: whatsappController.text,
                  fecha: fechaController.text,
                  numero: numeroController.text,
                  cliente: clienteController.text,
                  dronAnunciado: dronController.text,
                  precioWeb: double.tryParse(precioWebController.text) ?? 0,
                  precioCliente:
                      double.tryParse(precioClienteController.text) ?? 0,
                  comision: double.tryParse(comisionController.text) ?? 0,
                  seguimiento: seguimientoController.text,
                  estado: estadoController.text,
                  observaciones: observacionesController.text,
                );

                await sellerService.updateSeller(seller.id, updatedSeller);
                Navigator.of(context).pop();
              },
              child: Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  // Método para construir un TextField para el cuadro de diálogo de edición
  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  // Método para mostrar el cuadro de confirmación antes de eliminar
  Future<void> _confirmDelete(BuildContext context, String sellerId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar este vendedor?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await sellerService.deleteSeller(sellerId);
                Navigator.of(context).pop();
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  // Estilo del encabezado de la tabla
  TextStyle _tableHeaderStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black54,
      fontSize: 16,
    );
  }
}
