import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ContractCreationScreen extends StatefulWidget {
  @override
  _ContractCreationScreenState createState() => _ContractCreationScreenState();
}

class _ContractCreationScreenState extends State<ContractCreationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for buyer and seller details
  TextEditingController buyerNameController = TextEditingController();
  TextEditingController buyerEmailController = TextEditingController();
  TextEditingController buyerPhoneController = TextEditingController();
  TextEditingController buyerCityController = TextEditingController();

  TextEditingController sellerNameController = TextEditingController();
  TextEditingController sellerEmailController = TextEditingController();
  TextEditingController sellerPhoneController = TextEditingController();
  TextEditingController sellerCityController = TextEditingController();

  TextEditingController droneModelController = TextEditingController();
  TextEditingController contractNumberController = TextEditingController();

  @override
  void dispose() {
    buyerNameController.dispose();
    buyerEmailController.dispose();
    buyerPhoneController.dispose();
    buyerCityController.dispose();

    sellerNameController.dispose();
    sellerEmailController.dispose();
    sellerPhoneController.dispose();
    sellerCityController.dispose();

    droneModelController.dispose();
    contractNumberController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _showPreviewDialog();
    }
  }

  Future<void> _generateContractPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Padding(
            padding: pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "COMPRODRONE SALES AGREEMENT",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),

                // Contract Number
                pw.Text(
                  "Contract Number: ${contractNumberController.text}",
                  style: pw.TextStyle(fontSize: 16),
                ),
                pw.SizedBox(height: 20),

                // Agreement Text
                pw.Text(
                  "This agreement is made between the seller and the buyer on the terms and conditions outlined below:",
                  style: pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 10),

                // Buyer Information
                pw.Text("Buyer Information:", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text("Name: ${buyerNameController.text}"),
                pw.Text("Email: ${buyerEmailController.text}"),
                pw.Text("Phone: ${buyerPhoneController.text}"),
                pw.Text("City: ${buyerCityController.text}"),
                pw.SizedBox(height: 10),

                // Seller Information
                pw.Text("Seller Information:", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text("Name: ${sellerNameController.text}"),
                pw.Text("Email: ${sellerEmailController.text}"),
                pw.Text("Phone: ${sellerPhoneController.text}"),
                pw.Text("City: ${sellerCityController.text}"),
                pw.SizedBox(height: 10),

                // Drone Information
                pw.Text("Drone Information:", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text("Model: ${droneModelController.text}"),
                pw.Text("Brand: DroneX"),
                pw.Text("Serial Number: SN-123456789"),
                pw.Text("Price: \$9500.00"),
                pw.Text("Commission: \$500"),
                pw.SizedBox(height: 20),

                // Constant Terms and Conditions
                pw.Text(
                  "Terms and Conditions:",
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  "1. The seller guarantees that the drone is in good working condition.",
                  style: pw.TextStyle(fontSize: 14),
                ),
                pw.Text(
                  "2. The buyer agrees to the price and terms of payment.",
                  style: pw.TextStyle(fontSize: 14),
                ),
                pw.Text(
                  "3. This contract is binding upon both parties.",
                  style: pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 20),

                pw.Text(
                  "Signatures:",
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 30),
                pw.Text("Buyer Signature: ______________________"),
                pw.SizedBox(height: 20),
                pw.Text("Seller Signature: ______________________"),
              ],
            ),
          );
        },
      ),
    );

    // Share the PDF (download it to device or share it)
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'contract_${contractNumberController.text}.pdf',
    );
  }

  Future<void> _showPreviewDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Preview Contract Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Buyer Name: ${buyerNameController.text}"),
                Text("Buyer Email: ${buyerEmailController.text}"),
                Text("Buyer Phone: ${buyerPhoneController.text}"),
                Text("Buyer City: ${buyerCityController.text}"),
                SizedBox(height: 10),
                Text("Seller Name: ${sellerNameController.text}"),
                Text("Seller Email: ${sellerEmailController.text}"),
                Text("Seller Phone: ${sellerPhoneController.text}"),
                Text("Seller City: ${sellerCityController.text}"),
                SizedBox(height: 10),
                Text("Drone Model: ${droneModelController.text}"),
                Text("Contract Number: ${contractNumberController.text}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Edit'),
              onPressed: () {
                Navigator.of(context).pop(); // Go back to the form
              },
            ),
            ElevatedButton(
              child: Text('Generate PDF'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the preview dialog
                _generateContractPDF(); // Generate the PDF
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Contract')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Buyer Name Field
              TextFormField(
                controller: buyerNameController,
                decoration: InputDecoration(labelText: 'Buyer Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter the buyer name' : null,
                textInputAction: TextInputAction.next,
              ),
              // Buyer Email Field
              TextFormField(
                controller: buyerEmailController,
                decoration: InputDecoration(labelText: 'Buyer Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter the buyer email' : null,
                textInputAction: TextInputAction.next,
              ),
              // Buyer Phone Field
              TextFormField(
                controller: buyerPhoneController,
                decoration: InputDecoration(labelText: 'Buyer Phone'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter the buyer phone number' : null,
                textInputAction: TextInputAction.next,
              ),
              // Buyer City Field
              TextFormField(
                controller: buyerCityController,
                decoration: InputDecoration(labelText: 'Buyer City'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter the buyer city' : null,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 10),

              // Seller Name Field
              TextFormField(
                controller: sellerNameController,
                decoration: InputDecoration(labelText: 'Seller Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter the seller name' : null,
                textInputAction: TextInputAction.next,
              ),
              // Seller Email Field
              TextFormField(
                controller: sellerEmailController,
                decoration: InputDecoration(labelText: 'Seller Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter the seller email' : null,
                textInputAction: TextInputAction.next,
              ),
              // Seller Phone Field
              TextFormField(
                controller: sellerPhoneController,
                decoration: InputDecoration(labelText: 'Seller Phone'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter the seller phone number' : null,
                textInputAction: TextInputAction.next,
              ),
              // Seller City Field
              TextFormField(
                controller: sellerCityController,
                decoration: InputDecoration(labelText: 'Seller City'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter the seller city' : null,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 10),

              // Drone Model Field
              TextFormField(
                controller: droneModelController,
                decoration: InputDecoration(labelText: 'Drone Model'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter the drone model' : null,
                textInputAction: TextInputAction.next,
              ),
              // Contract Number Field
              TextFormField(
                controller: contractNumberController,
                decoration: InputDecoration(labelText: 'Contract Number'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter the contract number' : null,
                textInputAction: TextInputAction.done,
              ),
              SizedBox(height: 20),
              // Submit Button
              ElevatedButton(
                onPressed: () async {
                  await _submitForm();
                },
                child: Text('Preview and Generate Contract'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
