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
                pw.Text("Buyer Information:",
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text("Name: ${buyerNameController.text}"),
                pw.Text("Email: ${buyerEmailController.text}"),
                pw.Text("Phone: ${buyerPhoneController.text}"),
                pw.Text("City: ${buyerCityController.text}"),
                pw.SizedBox(height: 10),

                // Seller Information
                pw.Text("Seller Information:",
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text("Name: ${sellerNameController.text}"),
                pw.Text("Email: ${sellerEmailController.text}"),
                pw.Text("Phone: ${sellerPhoneController.text}"),
                pw.Text("City: ${sellerCityController.text}"),
                pw.SizedBox(height: 10),

                // Drone Information
                pw.Text("Drone Information:",
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text("Model: ${droneModelController.text}"),
                pw.Text("Brand: DroneX"),
                pw.Text("Serial Number: SN-123456789"),
                pw.Text("Price: \$9500.00"),
                pw.Text("Commission: \$500"),
                pw.SizedBox(height: 20),

                // Constant Terms and Conditions
                pw.Text(
                  "Terms and Conditions:",
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
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
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
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
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Create Contract',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Buyer Section
              Text(
                'Buyer Details',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900]),
              ),
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTextField(
                          controller: buyerNameController,
                          labelText: 'Buyer Name',
                          icon: Icons.person),
                      SizedBox(height: 10),
                      _buildTextField(
                          controller: buyerEmailController,
                          labelText: 'Buyer Email',
                          icon: Icons.email),
                      SizedBox(height: 10),
                      _buildTextField(
                          controller: buyerPhoneController,
                          labelText: 'Buyer Phone',
                          icon: Icons.phone),
                      SizedBox(height: 10),
                      _buildTextField(
                          controller: buyerCityController,
                          labelText: 'Buyer City',
                          icon: Icons.location_city),
                    ],
                  ),
                ),
              ),
              Divider(),

              // Seller Section
              Text(
                'Seller Details',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900]),
              ),
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTextField(
                          controller: sellerNameController,
                          labelText: 'Seller Name',
                          icon: Icons.person),
                      SizedBox(height: 10),
                      _buildTextField(
                          controller: sellerEmailController,
                          labelText: 'Seller Email',
                          icon: Icons.email),
                      SizedBox(height: 10),
                      _buildTextField(
                          controller: sellerPhoneController,
                          labelText: 'Seller Phone',
                          icon: Icons.phone),
                      SizedBox(height: 10),
                      _buildTextField(
                          controller: sellerCityController,
                          labelText: 'Seller City',
                          icon: Icons.location_city),
                    ],
                  ),
                ),
              ),
              Divider(),

              // Drone and Contract Section
              Text(
                'Contract & Drone Details',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[900]),
              ),
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTextField(
                          controller: droneModelController,
                          labelText: 'Drone Model',
                          icon: Icons.toys),
                      SizedBox(height: 10),
                      _buildTextField(
                          controller: contractNumberController,
                          labelText: 'Contract Number',
                          icon: Icons.confirmation_number),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: () async {
                  await _submitForm();
                },
                child: Text(
                  'Preview and Generate Contract',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build TextFormFields with icon and validation
  Widget _buildTextField(
      {required TextEditingController controller,
      required String labelText,
      required IconData icon}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'Enter $labelText' : null,
    );
  }
}
