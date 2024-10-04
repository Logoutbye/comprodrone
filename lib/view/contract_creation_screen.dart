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

    // 1st page: Contract of Sale

    // Using MultiPage to handle page breaks automatically
    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Padding(
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
                pw.Text(
                  "En Vitigudino a 3 de Diciembre del 2022",
                  style: pw.TextStyle(fontSize: 16),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  "REUNIDOS:",
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  "De una parte, como LA PARTE VENDEDORA:\n"
                  "D. Jorge Pajares Maldonado, mayor de edad, con D.N.I 40562375N y con domicilio en Sant Martí Puigcerda (Girona), Clna. Colonia Simón 29 C P01 -0001",
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  "De otra parte, como LA PARTE COMPRADORA:\n"
                  "D. Miguel Ángel Sánchez Vizcaíno, mayor de edad, con D.N.I 75895782Z y con domicilio en Algeciras (Cádiz), Urbn Los Sauces 1 P09D",
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  "Ambas partes contratantes se reconocen capacidad legal para este acto, e intervienen en su propio nombre y derecho.",
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  "EXPONEN:",
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
                pw.Bullet(
                  text:
                      "Que el vendedor ha anunciado su dron en la plataforma web www.comprodrone.com propiedad de Don Eliseo Prieto Iglesias con D.N.I 70873396T con domicilio en calle Afueras de Santa Ana 22 de Vitigudino Salamanca. En adelante ComproDrone.",
                ),
                pw.Bullet(
                  text:
                      "El comprador ha comprado el dron, más abajo especificado, por la plataforma de ComproDrone.",
                ),
                pw.Bullet(
                  text:
                      "Que ambas partes han convenido formalizar contrato de compraventa de un dron usado:",
                ),
                pw.SizedBox(height: 10),
                pw.Text("MARCA: YUNEEC"),
                pw.Text("MODELO: TYPHOON H"),
                pw.Text("Nº DE SERIE: YU16230469B08A02"),
                pw.Text("ESTADO DEL APARATO: SEMI-NUEVO"),
                pw.Text("POSIBLES DEFECTOS: NINGUNO"),
                pw.SizedBox(height: 10),
                pw.Text(
                  "Que la parte compradora manifiesta que ha sido informada del estado del dron, en su conjunto y en el de sus elementos mecánicos y componentes fundamentales, de su antigüedad así como de los extras que tiene. También del estado de las baterías.",
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  "Asimismo se hace constar que el comprador ha examinado personal y directamente o a través de un tercero o por medios telemáticos el dron y realizado las pruebas que libremente ha estimado pertinentes para comprobar su buen funcionamiento.",
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  "Que el dron objeto de la presente Compra-Venta no tiene fallos o vicios ocultos conocidos y que funciona correctamente. Debiendo el vendedor avisar al comprador de posibles desperfectos, fallas o accidentes que haya sufrido el dron durante su uso.",
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  "El comprador ha adquirido el dron mediante la plataforma web www.comprodrone.com.",
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  "ESTIPULACIONES:",
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  "PRIMERA: El vendedor vende al comprador el dron de su propiedad anteriormente especificado por la cantidad de 450 euros, sin incluir los impuestos correspondientes, si se generaran (no todos los países hay que pagar impuestos por la venta del dron), que será a cargo del comprador y la comisión a ComproDrone.",
                ),
                pw.Text(
                  "SEGUNDA: El vendedor declara que no pesa sobre el citado dron ninguna carga o gravamen ni impuesto, ni pago pendiente, ni deuda o sanción pendiente de abono en la fecha de la firma de este contrato, y se compromete en caso contrario a regularizar tal situación a su exclusivo cargo. Igualmente el vendedor garantiza que el dron ha sido dado de baja del registro de operadoras profesionales o cualquier otro registro asociado al vendedor.",
                ),
                pw.Text(
                  "TERCERA: Por el acto se hace entrega al comprador del drone. El comprador se hace responsable desde la fecha del presente documento, de cuantas cuestiones pudieran derivarse del uso o posesión del mismo, incluidas responsabilidades, sanciones, contratación de seguros de responsabilidad civil o cualquier otro documento que la regulación del país requiera para el uso de drones.",
                ),
                pw.Text(
                  "CUARTA: El comprador declara conocer el estado actual del dron y exonera de manera expresa a ComproDrone y al vendedor de cualquier responsabilidad por vicios o defectos ocultos o posibles averías que el bien manifieste en un futuro, según se determina en el Código Civil del país, salvo aquellos ocultos que tengan su origen en dolo o mala fe del vendedor y no hayan sido comunicados.",
                ),
                pw.Text(
                  "El vendedor responderá frente al comprador tanto de la posesión legal y pacífica del dron como de los vicios o defectos ocultos que tuviere, durante el plazo que marque la ley de conformidad con lo establecido en el Código Civil del país.",
                ),
                pw.Text(
                  "No existirá responsabilidad del vendedor por averías o deficiencias del dron, aparecidas con posterioridad a la entrega del mismo, cuando estas circunstancias se produzcan o vengan motivadas por un uso inadecuado; o a consecuencia de fuerza mayor, robo, hurto, negligencia, accidente o falta de mantenimiento aconsejado por el fabricante, así como de los defectos existentes en el momento de la entrega del dron, siempre y cuando hubieran sido conocidos y consentidos por el comprador.",
                ),
                pw.Text(
                  "La empresa ComproDrone no se hace responsable por los daños que sufran los artículos enviados, así como por perdida o por retrasos en la logística.",
                ),
                pw.Text(
                  "QUINTA: Para cualquier litigio que surja entre las partes de la interpretación o cumplimiento del presente contrato, estas, con expresa renuncia al fuero que pudiera corresponderles, se someterán a los Juzgados y Tribunales de Salamanca.",
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                    "Y para que así conste, firman el presente contrato de compraventa de 5 hojas, por duplicado, en la fecha y lugar arriba indicados."),
                pw.SizedBox(height: 40),
                pw.Text(
                  "Firma de EL VENDEDOR                    Firma de ComproDrone                   Firma de EL COMPRADOR",
                ),
              ],
            ),
          ),
        ],
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
