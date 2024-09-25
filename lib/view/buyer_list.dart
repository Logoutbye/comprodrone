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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBuyerScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(title: Text('Buyers')),
      body: StreamBuilder<List<Buyer>>(
        stream: buyerService.getAllBuyers(), // Fetch the buyers in real-time
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading state
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error state
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Buyers Found')); // Empty state
          }

          // If we have data, display it in a DataTable
          List<Buyer> buyers = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Handle overflow
            child: DataTable(
              border: TableBorder.all(color: Colors.grey), // Add border to the table
              columns: [
                DataColumn(label: Text('ID')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('City')),
                DataColumn(label: Text('Phone')),
                DataColumn(label: Text('Requirements')),
                DataColumn(label: Text('Remarks')),
                DataColumn(label: Text('Follow Up')),
                DataColumn(label: Text('Notes')),
                DataColumn(label: Text('Budget')),
                DataColumn(label: Text('Actions')),
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
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditDialog(context, buyer); // Show dialog
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _confirmDelete(context, buyer.id); // Call confirmation dialog before deleting
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
        initialDate: DateFormat('dd-MM-yyyy').parse(buyer.date), // Use the current date as initial
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null) {
        dateController.text = DateFormat('dd-MM-yyyy').format(picked); // Format the date
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
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
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
                  controller: requirementsController,
                  decoration: InputDecoration(labelText: 'Requirements'),
                ),
                TextField(
                  controller: remarksController,
                  decoration: InputDecoration(labelText: 'Remarks'),
                ),
                TextField(
                  controller: followUpController,
                  decoration: InputDecoration(labelText: 'Follow Up'),
                ),
                TextField(
                  controller: notesController,
                  decoration: InputDecoration(labelText: 'Notes'),
                ),
                TextField(
                  controller: budgetController,
                  decoration: InputDecoration(labelText: 'Budget'),
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

                await buyerService.updateBuyer(buyer.id, updatedBuyer); // Update the buyer
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
            TextButton(
              onPressed: () async {
                await buyerService.deleteBuyer(buyerId); // Delete buyer
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
