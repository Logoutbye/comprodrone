import 'package:flutter/material.dart';
import '../models/supplier_model.dart';
import '../services/supplier_services.dart';
import 'add_supplier.dart'; // Ensure this path is correct

class SupplierListScreen extends StatelessWidget {
  final SupplierService supplierService =
      SupplierService(); // Instantiate the service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: () {
          // Navigate to AddSupplierScreen (you'll need to implement it)
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
          'Suppliers',
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
                    return Center(child: Text('No Suppliers Found'));
                  }

                  // Display suppliers in a DataTable
                  List<Supplier> suppliers = snapshot.data!;
                  return Center(
                    child: SingleChildScrollView(
                      scrollDirection:
                          Axis.horizontal, // Handle overflow for large tables
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
                              'Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Contact Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Actions',
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
                                    tooltip: 'Edit Supplier',
                                    onPressed: () {
                                      _showEditDialog(context, supplier);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    tooltip: 'Delete Supplier',
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

  // Show dialog to edit supplier
  void _showEditDialog(BuildContext context, Supplier supplier) {
    final TextEditingController nameController =
        TextEditingController(text: supplier.name);
    final TextEditingController contactDetailsController =
        TextEditingController(text: supplier.contactDetails);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Supplier'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(controller: nameController, label: 'Name'),
              SizedBox(height: 10),
              _buildTextField(
                  controller: contactDetailsController,
                  label: 'Contact Details'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Update the supplier's information
                Supplier updatedSupplier = Supplier(
                  id: supplier.id, // Keep the same ID
                  name: nameController.text,
                  contactDetails: contactDetailsController.text,
                );

                await supplierService.updateSupplier(
                    supplier.id, updatedSupplier);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Update'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey[800], // Update button color
              ),
            ),
          ],
        );
      },
    );
  }

  // Show confirmation dialog before deleting
  Future<void> _confirmDelete(BuildContext context, String supplierId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this supplier?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await supplierService.deleteSupplier(supplierId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent, // Delete button color
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper to build text fields
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
// fnhfhfhfhfhf