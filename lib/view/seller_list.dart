import 'package:com_pro_drone/models/seller_model.dart'; // Make sure the correct path is used for your Seller model
import 'package:com_pro_drone/view/add_drone.dart';
import 'package:com_pro_drone/view/add_seller_screen.dart';
import 'package:com_pro_drone/view/drone_list_screen.dart';
import 'package:flutter/material.dart';
import '../services/seller_services.dart'; // Update this path to your SellerService

class SellerListScreen extends StatelessWidget {
  final SellerService sellerService =
      SellerService(); // Instantiate the service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddSellerScreen()), // Adjust path for AddSellerScreen
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(title: Text('Sellers')),
      body: StreamBuilder<List<Seller>>(
        stream: sellerService.getAllSellers(), // Fetch the sellers in real-time
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading state
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Error state
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Sellers Found')); // Empty state
          }

          // If we have data, display it in a DataTable
          List<Seller> sellers = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Handle overflow
            child: DataTable(
              border: TableBorder.all(
                  color: Colors.grey), // Add border to the table
              columns: [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Seller Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Phone')),
                DataColumn(label: Text('City')),
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Address')),
                DataColumn(label: Text('WhatsApp Link')),
                DataColumn(label: Text('Actions')),
              ],
              rows: sellers.map((seller) {
                return DataRow(cells: [
                  DataCell(Text(seller.id)),
                  DataCell(Text(seller.sellerName)),
                  DataCell(Text(seller.email)),
                  DataCell(Text(seller.phone)),
                  DataCell(Text(seller.city)),
                  DataCell(Text(seller.typeOfSeller)),
                  DataCell(Text(seller.address)),
                  DataCell(Text(seller.whatsappLink)), // Show WhatsApp link
                  DataCell(
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditDialog(context, seller); // Show dialog
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _confirmDelete(
                                context,
                                seller
                                    .id); // Call confirmation dialog before deleting
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.import_contacts),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DroneListScreen()),
                            );
                          },
                        ), IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddDroneScreen()),
                            );
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

  // Method to show the edit dialog
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
        TextEditingController(text: seller.whatsappLink);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Seller'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Seller Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(labelText: 'City'),
                ),
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(labelText: 'Type of Seller'),
                ),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: whatsappController,
                  decoration: InputDecoration(labelText: 'WhatsApp No'),
                ),
              ],
            ),
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
                // Update the seller's information
                Seller updatedSeller = Seller(
                  id: seller.id, // Keep the same ID
                  sellerName: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  city: cityController.text,
                  typeOfSeller: typeController.text,
                  address: addressController.text,
                  whatsappLink: whatsappController.text,
                );

                await sellerService.updateSeller(
                    seller.id, updatedSeller); // Update the seller
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Method to show a confirmation dialog before deleting
  Future<void> _confirmDelete(BuildContext context, String sellerId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this seller?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await sellerService.deleteSeller(sellerId); // Delete seller
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
