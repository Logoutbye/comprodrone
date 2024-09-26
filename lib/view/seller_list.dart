import 'package:com_pro_drone/models/seller_model.dart'; // Ensure correct model path
import 'package:com_pro_drone/view/add_drone.dart';
import 'package:com_pro_drone/view/add_seller_screen.dart';
import 'package:com_pro_drone/view/drone_list_screen.dart';
import 'package:flutter/material.dart';
import '../services/seller_services.dart'; // Ensure correct service path
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class SellerListScreen extends StatelessWidget {
  final SellerService sellerService =
      SellerService(); // Instantiate the service

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
            title: Text('Sellers'),
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
                  stream: sellerService.getAllSellers(), // Fetch sellers
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
                          'No Sellers Found',
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

  // Build the responsive DataTable
  Widget _buildResponsiveDataTable(
      BuildContext context, List<Seller> sellers, BoxConstraints constraints) {
    final bool isSmallScreen = constraints.maxWidth < 600;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enable horizontal scroll
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: DataTable(
            border: TableBorder.all(color: Colors.grey[300]!, width: 1),
            columns: _buildTableColumns(isSmallScreen), // Adjust columns
            rows: sellers
                .map((seller) => _buildDataRow(context, seller, isSmallScreen))
                .toList(),
          ),
        ),
      ),
    );
  }

  // Create the DataTable columns based on screen size
  List<DataColumn> _buildTableColumns(bool isSmallScreen) {
    return [
      DataColumn(label: Text('ID', style: _tableHeaderStyle())),
      DataColumn(label: Text('Seller Name', style: _tableHeaderStyle())),
      if (!isSmallScreen) ...[
        DataColumn(label: Text('Email', style: _tableHeaderStyle())),
        DataColumn(label: Text('Phone', style: _tableHeaderStyle())),
        DataColumn(label: Text('City', style: _tableHeaderStyle())),
        DataColumn(label: Text('Type', style: _tableHeaderStyle())),
        DataColumn(label: Text('Address', style: _tableHeaderStyle())),
        DataColumn(label: Text('WhatsApp', style: _tableHeaderStyle())),
      ],
      DataColumn(label: Text('Actions', style: _tableHeaderStyle())),
    ];
  }

  // Create the DataRow for each seller
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
                  tooltip: 'Chat on WhatsApp',
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
                tooltip: 'Edit Seller',
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () {
                  _confirmDelete(context, seller.id);
                },
                tooltip: 'Delete Seller',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Method to launch WhatsApp
  void _launchWhatsApp(BuildContext context, String phoneNumber) async {
    // Ensure the phone number is in international format without '+' or dashes
    String formattedNumber =
        phoneNumber.replaceAll('+', '').replaceAll('-', '');
    final Uri whatsappUri = Uri.parse("https://wa.me/$formattedNumber");

    // Check if the device can launch WhatsApp
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      // Show an error message if WhatsApp is not installed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("WhatsApp is not installed on this device."),
        ),
      );
    }
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
        TextEditingController(text: seller.whatsappNo);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Seller'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(nameController, 'Seller Name'),
                _buildTextField(emailController, 'Email'),
                _buildTextField(phoneController, 'Phone'),
                _buildTextField(cityController, 'City'),
                _buildTextField(typeController, 'Type of Seller'),
                _buildTextField(addressController, 'Address'),
                _buildTextField(whatsappController, 'WhatsApp No'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
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
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Method to build a TextField for the Edit dialog
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
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await sellerService.deleteSeller(sellerId);
                Navigator.of(context).pop();
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Table Header Styling
  TextStyle _tableHeaderStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black54,
      fontSize: 16,
    );
  }
}
