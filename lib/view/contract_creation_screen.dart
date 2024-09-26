import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ContractCreationScreen extends StatefulWidget {
  @override
  _ContractCreationScreenState createState() => _ContractCreationScreenState();
}

class _ContractCreationScreenState extends State<ContractCreationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los detalles del comprador y vendedor
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
                  "ACUERDO DE VENTA COMPRODRONE",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),

                // Número de contrato
                pw.Text(
                  "Número de Contrato: ${contractNumberController.text}",
                  style: pw.TextStyle(fontSize: 16),
                ),
                pw.SizedBox(height: 20),

                // Texto del acuerdo
                pw.Text(
                  "Este acuerdo se celebra entre el vendedor y el comprador en los términos y condiciones que se detallan a continuación:",
                  style: pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 10),

                // Información del Comprador
                pw.Text("Información del Comprador:",
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text("Nombre: ${buyerNameController.text}"),
                pw.Text("Correo: ${buyerEmailController.text}"),
                pw.Text("Teléfono: ${buyerPhoneController.text}"),
                pw.Text("Ciudad: ${buyerCityController.text}"),
                pw.SizedBox(height: 10),

                // Información del Vendedor
                pw.Text("Información del Vendedor:",
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text("Nombre: ${sellerNameController.text}"),
                pw.Text("Correo: ${sellerEmailController.text}"),
                pw.Text("Teléfono: ${sellerPhoneController.text}"),
                pw.Text("Ciudad: ${sellerCityController.text}"),
                pw.SizedBox(height: 10),

                // Información del Drone
                pw.Text("Información del Drone:",
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.Text("Modelo: ${droneModelController.text}"),
                pw.Text("Marca: DroneX"),
                pw.Text("Número de Serie: SN-123456789"),
                pw.Text("Precio: \$9500.00"),
                pw.Text("Comisión: \$500"),
                pw.SizedBox(height: 20),

                // Términos y Condiciones
                pw.Text(
                  "Términos y Condiciones:",
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  "1. El vendedor garantiza que el dron está en buenas condiciones.",
                  style: pw.TextStyle(fontSize: 14),
                ),
                pw.Text(
                  "2. El comprador acepta el precio y los términos de pago.",
                  style: pw.TextStyle(fontSize: 14),
                ),
                pw.Text(
                  "3. Este contrato es vinculante para ambas partes.",
                  style: pw.TextStyle(fontSize: 14),
                ),
                pw.SizedBox(height: 20),

                pw.Text(
                  "Firmas:",
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 30),
                pw.Text("Firma del Comprador: ______________________"),
                pw.SizedBox(height: 20),
                pw.Text("Firma del Vendedor: ______________________"),
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
                Navigator.of(context).pop(); // Cerrar el diálogo de vista previa
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
        foregroundColor: Colors.white,
        title: Text(
          'Crear Contrato',
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
              // Sección del Comprador
              Text(
                'Detalles del Comprador',
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
                          labelText: 'Nombre del Comprador',
                          icon: Icons.person),
                      SizedBox(height: 10),
                      _buildTextField(
                          controller: buyerEmailController,
                          labelText: 'Correo del Comprador',
                          icon: Icons.email),
                      SizedBox(height: 10),
                      _buildTextField(
                          controller: buyerPhoneController,
                          labelText: 'Teléfono del Comprador',
                          icon: Icons.phone),
                      SizedBox(height: 10),
                      _buildTextField(
                          controller: buyerCityController,
                          labelText: 'Ciudad del Comprador',
                          icon: Icons.location_city),
                    ],
                  ),
                ),
              ),
              Divider(),

              // Sección del Vendedor
              Text(
                'Detalles del Vendedor',
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
                          labelText: 'Nombre del Vendedor',
                          icon: Icons.person),
                      SizedBox(height: 10),
                      _buildTextField(
                          controller: sellerEmailController,
                          labelText: 'Correo del Vendedor',
                          icon: Icons.email),
                      SizedBox(height: 10),
                      _buildTextField(
                          controller: sellerPhoneController,
                          labelText: 'Teléfono del Vendedor',
                          icon: Icons.phone),
                      SizedBox(height: 10),
                      _buildTextField(
                          controller: sellerCityController,
                          labelText: 'Ciudad del Vendedor',
                          icon: Icons.location_city),
                    ],
                  ),
                ),
              ),
              Divider(),

              // Sección del Drone y Contrato
              Text(
                'Detalles del Contrato & Drone',
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
                          labelText: 'Modelo del Drone',
                          icon: Icons.toys),
                      SizedBox(height: 10),
                      _buildTextField(
                          controller: contractNumberController,
                          labelText: 'Número de Contrato',
                          icon: Icons.confirmation_number),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Botón de enviar
              ElevatedButton(
                onPressed: () async {
                  await _submitForm();
                },
                child: Text(
                  'Previsualizar y Generar Contrato',
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

  // Helper para construir TextFormFields con ícono y validación
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
      validator: (value) => value!.isEmpty ? 'Ingresa $labelText' : null,
    );
  }
}
