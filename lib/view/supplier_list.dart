import 'package:flutter/material.dart';
import '../models/supplier_model.dart';
import '../services/supplier_services.dart';
import 'add_supplier.dart'; // Asegúrate de que esta ruta sea correcta

class SupplierListScreen extends StatelessWidget {
  final SupplierService supplierService =
      SupplierService(); // Instanciar el servicio

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: () {
          // Navegar a AddSupplierScreen (debes implementarlo)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSupplierScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text(
          'Proveedores',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            Center(
              child: StreamBuilder<List<Supplier>>(
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

                  // Mostrar proveedores en una DataTable
                  List<Supplier> suppliers = snapshot.data!;
                  return Center(
                    child: SingleChildScrollView(
                      scrollDirection:
                          Axis.horizontal, // Manejar desbordamiento para tablas grandes
                      child: DataTable(
                        headingRowColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white!),
                        columnSpacing: 20,
                        border: TableBorder.all(color: Colors.grey[300]!),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'ID',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Nombre',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Detalles de Contacto',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Acciones',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ),
                        ],
                        rows: suppliers.map((supplier) {
                          return DataRow(cells: [
                            DataCell(Text(supplier.id)),
                            DataCell(Text(supplier.name)),
                            DataCell(Text(supplier.contactDetails)),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Colors.blueAccent),
                                    tooltip: 'Editar Proveedor',
                                    onPressed: () {
                                      _showEditDialog(context, supplier);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    tooltip: 'Eliminar Proveedor',
                                    onPressed: () {
                                      _confirmDelete(context, supplier.id);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mostrar cuadro de diálogo para editar proveedor
  void _showEditDialog(BuildContext context, Supplier supplier) {
    final TextEditingController nameController =
        TextEditingController(text: supplier.name);
    final TextEditingController contactDetailsController =
        TextEditingController(text: supplier.contactDetails);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Proveedor'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(controller: nameController, label: 'Nombre'),
              SizedBox(height: 10),
              _buildTextField(
                  controller: contactDetailsController,
                  label: 'Detalles de Contacto'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Actualizar la información del proveedor
                Supplier updatedSupplier = Supplier(
                  id: supplier.id, // Mantener el mismo ID
                  name: nameController.text,
                  contactDetails: contactDetailsController.text,
                );

                await supplierService.updateSupplier(
                    supplier.id, updatedSupplier);
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Actualizar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[800], // Color del botón Actualizar
              ),
            ),
          ],
        );
      },
    );
  }

  // Mostrar cuadro de confirmación antes de eliminar
  Future<void> _confirmDelete(BuildContext context, String supplierId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar este proveedor?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await supplierService.deleteSupplier(supplierId);
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Eliminar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, // Color del botón Eliminar
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper para construir campos de texto
  Widget _buildTextField(
      {required TextEditingController controller, required String label}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
