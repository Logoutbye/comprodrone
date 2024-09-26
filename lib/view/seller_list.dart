import 'package:com_pro_drone/models/seller_model.dart'; // Asegúrate de que esta ruta sea correcta
import 'package:com_pro_drone/view/add_drone.dart';
import 'package:com_pro_drone/view/add_seller_screen.dart';
import 'package:com_pro_drone/view/drone_list_screen.dart';
import 'package:flutter/material.dart';
import '../services/seller_services.dart'; // Asegúrate de que esta ruta sea correcta
import 'package:url_launcher/url_launcher.dart'; // Importar url_launcher

class SellerListScreen extends StatelessWidget {
  final SellerService sellerService = SellerService(); // Instanciar el servicio

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
              IconButton(
                icon: Icon(Icons.import_contacts),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DroneListScreen()),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.add),
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
                  stream: sellerService.getAllSellers(), // Obtener vendedores
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
      scrollDirection: Axis.horizontal, // Habilitar desplazamiento horizontal
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: DataTable(
            border: TableBorder.all(color: Colors.grey[300]!, width: 1),
            columns: _buildTableColumns(isSmallScreen), // Ajustar columnas
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
          DataCell(
            Row(
              children: [
                Text(seller.phone),
                IconButton(
                  icon: Icon(Icons.phone, color: Colors.green),
                  onPressed: () {
                    _launchWhatsApp(context, seller.whatsappNo);
                  },
                  tooltip: 'Chatear en WhatsApp',
                ),
              ],
            ),
          ),
          DataCell(Text(seller.city)),
          DataCell(Text(seller.typeOfSeller)),
          DataCell(Text(seller.address)),
          DataCell(Text(seller.whatsappNo)),
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
    // Asegurarse de que el número de teléfono esté en formato internacional sin '+' ni guiones
    String formattedNumber =
        phoneNumber.replaceAll('+', '').replaceAll('-', '');
    final Uri whatsappUri = Uri.parse("https://wa.me/$formattedNumber");

    // Verificar si el dispositivo puede abrir WhatsApp
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      // Mostrar mensaje de error si WhatsApp no está instalado
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
