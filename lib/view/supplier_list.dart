import 'package:com_pro_drone/view/add_supplier.dart';
import 'package:flutter/material.dart';
import '../models/supplier_model.dart';
import '../services/supplier_services.dart';

class SupplierListScreen extends StatelessWidget {
  final SupplierService supplierService =
      SupplierService(); // Instantiate the service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to AddSupplierScreen (you'll need to implement it)
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddSupplierScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(title: Text('Suppliers')),
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
            return Center(child: Text('No Suppliers Found'));
          }

          // Display suppliers in a DataTable
          List<Supplier> suppliers = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Handle overflow
            child: DataTable(
              border: TableBorder.all(
                  color: Colors.grey), // Add border to the table
              columns: [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Contact Details')),
                DataColumn(label: Text('Actions')),
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
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditDialog(context, supplier);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
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
          );
        },
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
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: contactDetailsController,
                decoration: InputDecoration(labelText: 'Contact Details'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
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
            TextButton(
              onPressed: () async {
                await supplierService.deleteSupplier(supplierId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
