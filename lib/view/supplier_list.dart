import 'package:flutter/material.dart';
import '../models/supplier_model.dart';
import '../services/supplier_services.dart';
import 'add_supplier.dart';

class SupplierListScreen extends StatelessWidget {
  final SupplierService supplierService = SupplierService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Proveedores'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSupplierScreen()),
          );
        },
      ),
      body: StreamBuilder<List<Supplier>>(
        stream: supplierService.getAllSuppliers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No se encontraron proveedores'));
          }

          List<Supplier> suppliers = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: _buildTableColumns(),
              rows: suppliers.map((supplier) => _buildDataRow(context, supplier)).toList(),
            ),
          );
        },
      ),
    );
  }

  List<DataColumn> _buildTableColumns() {
    return [
      DataColumn(label: Text('ID', style: _tableHeaderStyle())),
      DataColumn(label: Text('Nombre', style: _tableHeaderStyle())),
      DataColumn(label: Text('Detalles de Contacto', style: _tableHeaderStyle())),
      DataColumn(label: Text('Cliente', style: _tableHeaderStyle())), // New field
      DataColumn(label: Text('Empresa', style: _tableHeaderStyle())), // New field
      DataColumn(label: Text('Contacto', style: _tableHeaderStyle())), // New field
      DataColumn(label: Text('Correo Electrónico', style: _tableHeaderStyle())), // New field
      DataColumn(label: Text('Teléfono', style: _tableHeaderStyle())), // New field
      DataColumn(label: Text('Ciudad', style: _tableHeaderStyle())), // New field
      DataColumn(label: Text('Página Web', style: _tableHeaderStyle())), // New field
      DataColumn(label: Text('Observaciones', style: _tableHeaderStyle())), // New field
      DataColumn(label: Text('Acciones', style: _tableHeaderStyle())),
    ];
  }

  DataRow _buildDataRow(BuildContext context, Supplier supplier) {
    return DataRow(
      cells: [
        DataCell(Text(supplier.id)),
        DataCell(Text(supplier.name)),
        DataCell(Text(supplier.contactDetails)),
        DataCell(Text(supplier.cliente)), // New field
        DataCell(Text(supplier.empresa)), // New field
        DataCell(Text(supplier.contacto)), // New field
        DataCell(Text(supplier.email)), // New field
        DataCell(Text(supplier.telefono)), // New field
        DataCell(Text(supplier.ciudad)), // New field
        DataCell(Text(supplier.paginaWeb)), // New field
        DataCell(Text(supplier.observaciones)), // New field
        DataCell(
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blueAccent),
                onPressed: () {
                  _showEditDialog(context, supplier);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  _confirmDelete(context, supplier.id);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Edit dialog
  void _showEditDialog(BuildContext context, Supplier supplier) {
    final TextEditingController nameController = TextEditingController(text: supplier.name);
    final TextEditingController contactDetailsController = TextEditingController(text: supplier.contactDetails);
    final TextEditingController clienteController = TextEditingController(text: supplier.cliente);
    final TextEditingController empresaController = TextEditingController(text: supplier.empresa);
    final TextEditingController contactoController = TextEditingController(text: supplier.contacto);
    final TextEditingController emailController = TextEditingController(text: supplier.email);
    final TextEditingController telefonoController = TextEditingController(text: supplier.telefono);
    final TextEditingController ciudadController = TextEditingController(text: supplier.ciudad);
    final TextEditingController paginaWebController = TextEditingController(text: supplier.paginaWeb);
    final TextEditingController observacionesController = TextEditingController(text: supplier.observaciones);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Proveedor'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(nameController, 'Nombre'),
                _buildTextField(contactDetailsController, 'Detalles de Contacto'),
                _buildTextField(clienteController, 'Cliente'), // New field
                _buildTextField(empresaController, 'Empresa'), // New field
                _buildTextField(contactoController, 'Contacto'), // New field
                _buildTextField(emailController, 'Correo Electrónico'), // New field
                _buildTextField(telefonoController, 'Teléfono'), // New field
                _buildTextField(ciudadController, 'Ciudad'), // New field
                _buildTextField(paginaWebController, 'Página Web'), // New field
                _buildTextField(observacionesController, 'Observaciones'), // New field
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                Supplier updatedSupplier = Supplier(
                  id: supplier.id,
                  name: nameController.text,
                  contactDetails: contactDetailsController.text,
                  cliente: clienteController.text,
                  empresa: empresaController.text,
                  contacto: contactoController.text,
                  email: emailController.text,
                  telefono: telefonoController.text,
                  ciudad: ciudadController.text,
                  paginaWeb: paginaWebController.text,
                  observaciones: observacionesController.text,
                );

                await supplierService.updateSupplier(supplier.id, updatedSupplier);
                Navigator.of(context).pop();
              },
              child: Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  // Confirm delete
  Future<void> _confirmDelete(BuildContext context, String supplierId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar este proveedor?'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                await supplierService.deleteSupplier(supplierId);
                Navigator.of(context).pop();
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  // Helper method for text fields
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

  TextStyle _tableHeaderStyle() {
    return TextStyle(fontWeight: FontWeight.bold, color: Colors.black54);
  }
}
