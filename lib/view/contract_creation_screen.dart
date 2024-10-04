import 'package:com_pro_drone/view/contract_history.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ContractCreationScreen extends StatefulWidget {
  @override
  _ContractCreationScreenState createState() => _ContractCreationScreenState();
}

class _ContractCreationScreenState extends State<ContractCreationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for buyer, seller, and drone details
  TextEditingController buyerNameController = TextEditingController();
  TextEditingController buyerDNIController = TextEditingController();
  TextEditingController buyerAddressController = TextEditingController();
  TextEditingController buyerPhoneController = TextEditingController();
  TextEditingController buyerEmailController = TextEditingController();
  TextEditingController buyerCityController = TextEditingController();

  TextEditingController sellerNameController = TextEditingController();
  TextEditingController sellerDNIController = TextEditingController();
  TextEditingController sellerAddressController = TextEditingController();
  TextEditingController sellerPhoneController = TextEditingController();
  TextEditingController sellerEmailController = TextEditingController();
  TextEditingController sellerCityController = TextEditingController();

  TextEditingController droneModelController = TextEditingController();
  TextEditingController droneSerialController = TextEditingController();
  TextEditingController dronePriceController = TextEditingController();

  @override
  void dispose() {
    buyerNameController.dispose();
    buyerDNIController.dispose();
    buyerAddressController.dispose();
    buyerPhoneController.dispose();
    buyerEmailController.dispose();
    buyerCityController.dispose();

    sellerNameController.dispose();
    sellerDNIController.dispose();
    sellerAddressController.dispose();
    sellerPhoneController.dispose();
    sellerEmailController.dispose();
    sellerCityController.dispose();

    droneModelController.dispose();
    droneSerialController.dispose();
    dronePriceController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _generateContractPDF();
    }
  }

  Future<void> _generateContractPDF() async {
    final pdf = pw.Document();

    // 1st page: Contract of Sale
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
                pw.SizedBox(height: 10),
                pw.Text("En Vitigudino a 3 de Diciembre del 2022",
                    style: pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 20),
                pw.Text("REUNIDOS:",
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text(
                    "De una parte, como LA PARTE VENDEDORA:\nD. ${sellerNameController.text}, "
                    "mayor de edad, con D.N.I ${sellerDNIController.text} y con domicilio en ${sellerAddressController.text}, "
                    "${sellerCityController.text}."),
                pw.SizedBox(height: 10),
                pw.Text(
                    "De otra parte, como LA PARTE COMPRADORA:\nD. ${buyerNameController.text}, "
                    "mayor de edad, con D.N.I ${buyerDNIController.text} y con domicilio en ${buyerAddressController.text}, "
                    "${buyerCityController.text}."),
                pw.SizedBox(height: 20),
                pw.Text("EXPONEN:",
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Bullet(
                    text:
                        "El vendedor ha anunciado su dron en la plataforma web www.comprodrone.com."),
                pw.Bullet(
                    text:
                        "El comprador ha comprado el dron por la plataforma de ComproDrone."),
                pw.Bullet(
                    text:
                        "Que ambas partes han convenido formalizar contrato de compraventa de un dron usado:"),
                pw.SizedBox(height: 10),
                pw.Text("MARCA: ${droneModelController.text}"),
                pw.Text("Nº DE SERIE: ${droneSerialController.text}"),
                pw.Text("ESTADO DEL APARATO: SEMI-NUEVO"),
                pw.Text("POSIBLES DEFECTOS: NINGUNO"),
                pw.SizedBox(height: 10),
                pw.Text(
                    "Que la parte compradora manifiesta que ha sido informada del estado del dron, en su conjunto y en el "
                    "de sus elementos mecánicos y componentes fundamentales."),
                pw.SizedBox(height: 10),
                pw.Text("ESTIPULACIONES:",
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.Text(
                    "PRIMERA: El vendedor vende al comprador el dron de su propiedad anteriormente especificado por la cantidad de ${dronePriceController.text} euros."),
                pw.Text(
                    "SEGUNDA: El vendedor declara que no pesa sobre el citado dron ninguna carga o gravamen ni impuesto."),
                pw.Text(
                    "TERCERA: El comprador se hace responsable desde la fecha del presente documento de cuantas cuestiones pudieran derivarse del uso o posesión."),
                pw.SizedBox(height: 20),
                pw.Text("Firmas:"),
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text("Firma del Vendedor: _____________________"),
                    pw.Text("Firma del Comprador: _____________________"),
                    pw.Text("Firma de ComproDrone: _____________________"),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    // 2nd page: UAS Sale Registration and Declaration
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Padding(
            padding: pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "REGISTRO DE VENTA DE AERONAVES NO TRIPULADAS (UAS)",
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: pw.FlexColumnWidth(3),
                    1: pw.FlexColumnWidth(5),
                  },
                  children: [
                    // Header Row
                    pw.TableRow(
                      children: [
                        pw.Text("Campo",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text("Detalle",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                    // UAS Info
                    pw.TableRow(children: [
                      pw.Text("Número de Serie de UAS"),
                      pw.Text("P3A0531221111132"),
                    ]),
                    pw.TableRow(children: [
                      pw.Text("Fecha de registro"),
                      pw.Text("31/07/2024"),
                    ]),
                    // Buyer Info
                    pw.TableRow(
                      children: [
                        pw.Text("COMPRADOR DE UAS",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(""),
                      ],
                    ),
                    pw.TableRow(children: [
                      pw.SizedBox(height: 10),
                      pw.SizedBox(height: 10),
                    ]),
                    pw.TableRow(children: [
                      pw.Text("Nombre completo o razón social"),
                      pw.Text("Mariano Campaña González"),
                    ]),
                    pw.TableRow(children: [
                      pw.Text("DNI"),
                      pw.Text("47425829 J"),
                    ]),
                    pw.TableRow(children: [
                      pw.Text("Nacionalidad"),
                      pw.Text("ESPAÑOLA"),
                    ]),
                    pw.TableRow(children: [
                      pw.Text("Fecha de Nacimiento"),
                      pw.Text("23/08/1998"),
                    ]),
                    pw.TableRow(children: [
                      pw.Text("Teléfono"),
                      pw.Text("615655125"),
                    ]),
                    pw.TableRow(children: [
                      pw.Text("Correo electrónico"),
                      pw.Text("mcampana@aronatur.com"),
                    ]),
                    pw.TableRow(children: [
                      pw.Text("Dirección"),
                      pw.Text(
                          "La Cilla, nº10, 41620, Marchena, Sevilla, España"),
                    ]),
                    pw.TableRow(children: [
                      pw.SizedBox(height: 10),
                      pw.SizedBox(height: 10),
                    ]), // Seller Info
                    pw.TableRow(
                      children: [
                        pw.Text("VENDEDOR DE UAS",
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(""),
                      ],
                    ),
                    pw.TableRow(children: [
                      pw.Text("Nombre completo o razón social"),
                      pw.Text("Gabriel Palacios Hernandez"),
                    ]),
                    pw.TableRow(children: [
                      pw.Text("DNI"),
                      pw.Text("50078703K"),
                    ]),
                    pw.TableRow(children: [
                      pw.Text("Nacionalidad"),
                      pw.Text("Española"),
                    ]),
                    pw.TableRow(children: [
                      pw.Text("Teléfono"),
                      pw.Text("605572884"),
                    ]),
                    pw.TableRow(children: [
                      pw.Text("Correo electrónico"),
                      pw.Text("Gabby6705@gmail.com"),
                    ]),
                    pw.TableRow(children: [
                      pw.Text("Dirección"),
                      pw.Text(
                          "C/ Jupiter 143, chalet, 28341, Valdemoro, Madrid, España"),
                    ]),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  "DECLARACIÓN RESPONSABLE",
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  "El presente documento constituye una declaración responsable. Que todos los documentos presentados en este registro son ciertos y su contenido coincide plenamente con los originales de los que son.",
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  "NORMATIVA DE REGISTRO DE AERONAVES/ AIRCRAFT REGISTRATION REGULATIONS",
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  "Según BOE, Nº136, miércoles 5 de junio del 2024.\n\n"
                  "En su capítulo VI de la sección 1ª, en los artículos:",
                ),
                pw.Bullet(text: "Artículo 48. Registro de operadores de UAS."),
                pw.Bullet(
                    text:
                        "Artículo 49. Inscripción y actualización de datos registrados."),
                pw.Bullet(
                    text:
                        "Artículo 50. Cancelación y suspensión de la inscripción a instancia de parte."),
                pw.Bullet(
                    text:
                        "Artículo 51. Cancelación de la inscripción de oficio."),
                pw.SizedBox(height: 10),
                pw.Text(
                  "En su sección 2ª, articulo 52 Registro de aeronaves no tripuladas cuyo diseño esté sujeto a certificación.",
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  "Sección 3ª, Registro aeronaves no tripuladas del Ministerio del Interior y registro de comercialización y venta.\n\n"
                  "En los artículos:",
                ),
                pw.Bullet(
                    text:
                        "Artículo 53. Creación del Registro de aeronaves no tripuladas del Ministerio del Interior."),
                pw.Bullet(
                    text:
                        "Artículo 54. Obligaciones de inscripción en la comercialización, venta y adquisición."),
                pw.Bullet(
                    text:
                        "Artículo 55. Obligaciones de comunicar la transmisión de las aeronaves no tripuladas."),
                pw.Bullet(
                    text:
                        "Artículo 56. Obligaciones de inscripción sobre la pérdida de la aeronave o su inhabilidad para operar."),
                pw.Bullet(
                    text:
                        "Artículo 57. Obligaciones adicionales del establecimiento."),
                pw.Bullet(
                    text:
                        "Artículo 58. Tratamiento de datos de carácter personal."),
              ],
            ),
          ),
        ],
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'contract.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: Icon(Icons.history),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return ContractHistoryScreen();
                },
              ));
            },
          ),
        ],
        title: Text('Crear Contrato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Detalles del Comprador',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildTextField(
                  buyerNameController, 'Nombre del Comprador', Icons.person),
              _buildTextField(
                  buyerDNIController, 'DNI del Comprador', Icons.credit_card),
              _buildTextField(buyerAddressController, 'Dirección del Comprador',
                  Icons.home),
              _buildTextField(
                  buyerPhoneController, 'Teléfono del Comprador', Icons.phone),
              _buildTextField(
                  buyerEmailController, 'Correo del Comprador', Icons.email),
              _buildTextField(buyerCityController, 'Ciudad del Comprador',
                  Icons.location_city),
              SizedBox(height: 20),
              Text('Detalles del Vendedor',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildTextField(
                  sellerNameController, 'Nombre del Vendedor', Icons.person),
              _buildTextField(
                  sellerDNIController, 'DNI del Vendedor', Icons.credit_card),
              _buildTextField(sellerAddressController, 'Dirección del Vendedor',
                  Icons.home),
              _buildTextField(
                  sellerPhoneController, 'Teléfono del Vendedor', Icons.phone),
              _buildTextField(
                  sellerEmailController, 'Correo del Vendedor', Icons.email),
              _buildTextField(sellerCityController, 'Ciudad del Vendedor',
                  Icons.location_city),
              SizedBox(height: 20),
              Text('Detalles del Drone',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildTextField(
                  droneModelController, 'Modelo del Drone', Icons.toys),
              _buildTextField(droneSerialController, 'Número de Serie',
                  Icons.confirmation_number),
              _buildTextField(
                  dronePriceController, 'Precio del Drone', Icons.attach_money),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _submitForm,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Generar PDF del Contrato',
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for text fields
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        validator: (value) =>
            value!.isEmpty ? 'Este campo es obligatorio' : null,
      ),
    );
  }
}
s