import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:com_pro_drone/models/contract_model.dart';
import 'package:com_pro_drone/services/contract_service.dart';
import 'package:com_pro_drone/view/contract_history.dart';

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
    Contract newContract = Contract(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      contractNumber: contractNumberController.text,
      buyerName: buyerNameController.text,
      buyerEmail: buyerEmailController.text,
      buyerPhone: buyerPhoneController.text,
      buyerCity: buyerCityController.text,
      sellerName: sellerNameController.text,
      sellerEmail: sellerEmailController.text,
      sellerPhone: sellerPhoneController.text,
      sellerCity: sellerCityController.text,
      droneModel: droneModelController.text,
      price: '1000 €', // Example price
      commission: '100 €', // Example commission
      createdAt: DateTime.now(),
    );
    await ContractService().addContract(newContract);

    // Generate the contract PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Padding(
            padding: pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "CONTRATO DE COMPRAVENTA DE DRONES de Segunda Mano",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                // More content here...
              ],
            ),
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'contrato_${contractNumberController.text}.pdf',
    );

    // Clear form after contract is generated
    _clearForm();

    // Show a SnackBar after contract is generated
    _showSnackBar(context, '¡Contrato generado exitosamente!');
  }

  // Clear all form fields after generating the contract
  void _clearForm() {
    setState(() {
      buyerNameController.clear();
      buyerEmailController.clear();
      buyerPhoneController.clear();
      buyerCityController.clear();
      sellerNameController.clear();
      sellerEmailController.clear();
      sellerPhoneController.clear();
      sellerCityController.clear();
      droneModelController.clear();
      contractNumberController.clear();
    });
  }

  // Custom method to display a SnackBar
  void _showSnackBar(BuildContext context, String message) {
    // Ensure the ScaffoldMessenger is properly linked
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _showPreviewDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Previsualizar Detalles del Contrato'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nombre del Comprador: ${buyerNameController.text}"),
                Text("Correo del Comprador: ${buyerEmailController.text}"),
                Text("Teléfono del Comprador: ${buyerPhoneController.text}"),
                Text("Ciudad del Comprador: ${buyerCityController.text}"),
                SizedBox(height: 10),
                Text("Nombre del Vendedor: ${sellerNameController.text}"),
                Text("Correo del Vendedor: ${sellerEmailController.text}"),
                Text("Teléfono del Vendedor: ${sellerPhoneController.text}"),
                Text("Ciudad del Vendedor: ${sellerCityController.text}"),
                SizedBox(height: 10),
                Text("Modelo del Drone: ${droneModelController.text}"),
                Text("Número de Contrato: ${contractNumberController.text}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Editar'),
              onPressed: () {
                Navigator.of(context).pop(); // Volver al formulario
              },
            ),
            ElevatedButton(
              child: Text('Generar PDF'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Cerrar el diálogo de vista previa
                _generateContractPDF(); // Generar el PDF
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
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContractHistoryScreen()),
              );
            },
            tooltip: 'Ver Historial de Contratos',
          ),
        ],
        foregroundColor: Colors.white,
        title: Text('Crear Contrato', style: TextStyle(fontSize: 20)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildBuyerSection(),
              _buildSellerSection(),
              _buildDroneContractSection(),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildBuyerSection() {
    return Column(
      children: [
        Text('Detalles del Comprador',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900])),
        Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTextField(
                    controller: buyerNameController,
                    labelText: 'Nombre del Comprador',
                    icon: Icons.person),
                _buildTextField(
                    controller: buyerEmailController,
                    labelText: 'Correo del Comprador',
                    icon: Icons.email),
                _buildTextField(
                    controller: buyerPhoneController,
                    labelText: 'Teléfono del Comprador',
                    icon: Icons.phone),
                _buildTextField(
                    controller: buyerCityController,
                    labelText: 'Ciudad del Comprador',
                    icon: Icons.location_city),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildSellerSection() {
    return Column(
      children: [
        Text('Detalles del Vendedor',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900])),
        Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTextField(
                    controller: sellerNameController,
                    labelText: 'Nombre del Vendedor',
                    icon: Icons.person),
                _buildTextField(
                    controller: sellerEmailController,
                    labelText: 'Correo del Vendedor',
                    icon: Icons.email),
                _buildTextField(
                    controller: sellerPhoneController,
                    labelText: 'Teléfono del Vendedor',
                    icon: Icons.phone),
                _buildTextField(
                    controller: sellerCityController,
                    labelText: 'Ciudad del Vendedor',
                    icon: Icons.location_city),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildDroneContractSection() {
    return Column(
      children: [
        Text('Detalles del Contrato & Drone',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900])),
        Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTextField(
                    controller: droneModelController,
                    labelText: 'Modelo del Drone',
                    icon: Icons.toys),
                _buildTextField(
                    controller: contractNumberController,
                    labelText: 'Número de Contrato',
                    icon: Icons.confirmation_number),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          await _submitForm();
        },
        child: Text('Previsualizar y Generar Contrato',
            style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue,
          textStyle: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  // Helper for TextFormFields with icon and validation
  Widget _buildTextField(
      {required TextEditingController controller,
      required String labelText,
      required IconData icon}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      ),
      validator: (value) => value!.isEmpty ? 'Ingresa $labelText' : null,
    );
  }
}
