import 'package:com_pro_drone/models/buyer_model.dart';
import 'package:com_pro_drone/view/add_buyer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import '../services/buyer_services.dart';

class BuyerListScreen extends StatelessWidget {
  final BuyerService buyerService = BuyerService(); // Instantiate the service

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBuyerScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent, // Update the button color
      ),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Buyer List', style: TextStyle(fontSize: 22)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent, // Update the app bar color
        elevation: 0,
      ),
      body: Column(
        children: [
          Center(
            child: StreamBuilder<List<Buyer>>(
              stream:
                  buyerService.getAllBuyers(), // Fetch the buyers in real-time
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator()); // Loading state
                }

                if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}')); // Error state
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No Buyers Found',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ); // Empty state
                }

                // If we have data, display it in a DataTable
                List<Buyer> buyers = snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection:
                      Axis.horizontal, // Handle overflow for many columns
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DataTable(
                        border: TableBorder.all(
                            color: Colors.grey[300]!,
                            width: 1), // Add border to the table
                        columns: [
                          DataColumn(
                              label: Text('ID', style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Date', style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Name', style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Email', style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('City', style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Phone', style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Requirements',
                                  style: _tableHeaderStyle())),
                          DataColumn(
                              label:
                                  Text('Remarks', style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Follow Up',
                                  style: _tableHeaderStyle())),
                          DataColumn(
                              label: Text('Notes', style: _tableHeaderStyle())),
                          DataColumn(
                              label:
                                  Text('Budget', style: _tableHeaderStyle())),
                          DataColumn(
                              label:
                                  Text('Actions', style: _tableHeaderStyle())),
                        ],
                        rows: buyers.map((buyer) {
                          return DataRow(cells: [
                            DataCell(Text(buyer.id)),
                            DataCell(Text(buyer.date)),
                            DataCell(Text(buyer.buyer)),
                            DataCell(Text(buyer.email)),
                            DataCell(Text(buyer.city)),
                            DataCell(Text(buyer.phone)),
                            DataCell(Text(buyer.requirements)),
                            DataCell(Text(buyer.remarks)), // Show remarks
                            DataCell(Text(buyer.followUp)), // Show follow-up
                            DataCell(Text(buyer.notes)), // Show notes
                            DataCell(Text(buyer.budget)), // Show budget
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: Colors.blueAccent),
                                    onPressed: () {
                                      _showEditDialog(
                                          context, buyer); // Show edit dialog
                                    },
                                    tooltip: 'Edit Buyer',
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.redAccent),
                                    onPressed: () {
                                      _confirmDelete(context,
                                          buyer.id); // Show delete confirmation
                                    },
                                    tooltip: 'Delete Buyer',
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Method to show the edit dialog
  void _showEditDialog(BuildContext context, Buyer buyer) {
    final TextEditingController dateController =
        TextEditingController(text: buyer.date);
    final TextEditingController nameController =
        TextEditingController(text: buyer.buyer);
    final TextEditingController emailController =
        TextEditingController(text: buyer.email);
    final TextEditingController phoneController =
        TextEditingController(text: buyer.phone);
    final TextEditingController cityController =
        TextEditingController(text: buyer.city);
    final TextEditingController requirementsController =
        TextEditingController(text: buyer.requirements);
    final TextEditingController remarksController =
        TextEditingController(text: buyer.remarks);
    final TextEditingController followUpController =
        TextEditingController(text: buyer.followUp);
    final TextEditingController notesController =
        TextEditingController(text: buyer.notes);
    final TextEditingController budgetController =
        TextEditingController(text: buyer.budget);

    // Function to handle date picking
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateFormat('dd-MM-yyyy')
            .parse(buyer.date), // Use the current date as initial
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        dateController.text =
            DateFormat('dd-MM-yyyy').format(picked); // Format the date
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Buyer'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  readOnly: true, // Make this field read-only
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    hintText: 'Select date',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context), // Open date picker
                    ),
                  ),
                ),
                _buildTextField(nameController, 'Name', Icons.person),
                _buildTextField(emailController, 'Email', Icons.email),
                _buildTextField(phoneController, 'Phone', Icons.phone),
                _buildTextField(cityController, 'City', Icons.location_city),
                _buildTextField(
                    requirementsController, 'Requirements', Icons.list),
                _buildTextField(remarksController, 'Remarks', Icons.comment),
                _buildTextField(
                    followUpController, 'Follow Up', Icons.follow_the_signs),
                _buildTextField(notesController, 'Notes', Icons.note),
                _buildTextField(budgetController, 'Budget', Icons.attach_money),
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
            ElevatedButton(
              onPressed: () async {
                // Update the buyer's information
                Buyer updatedBuyer = Buyer(
                  id: buyer.id, // Keep the same ID
                  date: dateController.text, // Update date
                  buyer: nameController.text,
                  email: emailController.text,
                  phone: phoneController.text,
                  city: cityController.text,
                  requirements: requirementsController.text, // Add requirements
                  remarks: remarksController.text, // Add remarks
                  followUp: followUpController.text, // Add followUp
                  notes: notesController.text, // Add notes
                  budget: budgetController.text,
                );

                await buyerService.updateBuyer(
                    buyer.id, updatedBuyer); // Update the buyer
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Method to build text field with icon
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  // Method to show a confirmation dialog before deleting
  Future<void> _confirmDelete(BuildContext context, String buyerId) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this buyer?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await buyerService.deleteBuyer(buyerId); // Delete buyer
                Navigator.of(context).pop(); // Close the dialog
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

  // Method to define table header style
  TextStyle _tableHeaderStyle() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black54,
      fontSize: 16,
    );
  }
}
