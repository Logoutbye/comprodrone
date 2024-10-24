import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com_pro_drone/view/contract_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
  TextEditingController corporateNameController = TextEditingController();
  TextEditingController buyerPhoneController = TextEditingController();
  TextEditingController buyerEmailController = TextEditingController();
  TextEditingController buyerCityController = TextEditingController();

  TextEditingController sellerNameController = TextEditingController();
  TextEditingController OrderNumberController = TextEditingController();
  TextEditingController sellerDNIController = TextEditingController();
  TextEditingController sellerAddressController = TextEditingController();
  TextEditingController sellerPhoneController = TextEditingController();
  TextEditingController sellerEmailController = TextEditingController();
  TextEditingController sellerCityController = TextEditingController();
  TextEditingController modelController = TextEditingController();

  TextEditingController droneModelController = TextEditingController();
  TextEditingController droneSerialController = TextEditingController();
  TextEditingController dronePriceController = TextEditingController();
  TextEditingController uasSerialNumberController = TextEditingController();
  TextEditingController registrationDateController = TextEditingController();
  TextEditingController registrationTypeController = TextEditingController();
  TextEditingController buyerNationalityController = TextEditingController();
  TextEditingController buyerZipCodeController = TextEditingController();
  TextEditingController birthDateCodeController = TextEditingController();
  TextEditingController buyerMunicipalityController = TextEditingController();
  TextEditingController buyerProvinceController = TextEditingController();
  TextEditingController buyerCountryController = TextEditingController();

  TextEditingController uasModelController = TextEditingController();
  TextEditingController notificationMethodController = TextEditingController();
  TextEditingController observationsController = TextEditingController();
  TextEditingController acquisitionController = TextEditingController();

  var image;
  var image1;
  var image2;

  @override
  void dispose() {
    buyerNameController.dispose();
    buyerDNIController.dispose();
    buyerAddressController.dispose();
    buyerPhoneController.dispose();
    buyerEmailController.dispose();
    buyerCityController.dispose();
    OrderNumberController.dispose();

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

  Future<void> _saveDataToFirebase() async {
    try {
      await FirebaseFirestore.instance.collection('contracts').add({
        'nombreComprador':
            buyerNameController.text.isNotEmpty ? buyerNameController.text : "",
        'dniComprador':
            buyerDNIController.text.isNotEmpty ? buyerDNIController.text : "",
        'direccionComprador': buyerAddressController.text.isNotEmpty
            ? buyerAddressController.text
            : "",
        'direccionComprador': corporateNameController.text.isNotEmpty
            ? corporateNameController.text
            : "",
        'telefonoComprador': buyerPhoneController.text.isNotEmpty
            ? buyerPhoneController.text
            : "",
        'emailComprador': buyerEmailController.text.isNotEmpty
            ? buyerEmailController.text
            : "",
        'ciudadComprador':
            buyerCityController.text.isNotEmpty ? buyerCityController.text : "",
        'numeroOrden': OrderNumberController.text.isNotEmpty
            ? OrderNumberController.text
            : "",
        'nombreVendedor': sellerNameController.text.isNotEmpty
            ? sellerNameController.text
            : "",
        'dniVendedor':
            sellerDNIController.text.isNotEmpty ? sellerDNIController.text : "",
        'direccionVendedor': sellerAddressController.text.isNotEmpty
            ? sellerAddressController.text
            : "",
        'telefonoVendedor': sellerPhoneController.text.isNotEmpty
            ? sellerPhoneController.text
            : "",
        'emailVendedor': sellerEmailController.text.isNotEmpty
            ? sellerEmailController.text
            : "",
        'ciudadVendedor': sellerCityController.text.isNotEmpty
            ? sellerCityController.text
            : "",
        'modeloDron': droneModelController.text.isNotEmpty
            ? droneModelController.text
            : "",
        'numeroSerieDron': droneSerialController.text.isNotEmpty
            ? droneSerialController.text
            : "",
        'precioDron': dronePriceController.text.isNotEmpty
            ? dronePriceController.text
            : "",
        'numeroSerieUAS': uasSerialNumberController.text.isNotEmpty
            ? uasSerialNumberController.text
            : "",
        'numeroSerieUAS': registrationTypeController.text.isNotEmpty
            ? registrationTypeController.text
            : "",
        'fechaRegistro': registrationDateController.text.isNotEmpty
            ? registrationDateController.text
            : "",
        'nacionalidadComprador': buyerNationalityController.text.isNotEmpty
            ? buyerNationalityController.text
            : "",
        'fechadenacimiento': birthDateCodeController.text.isNotEmpty
            ? birthDateCodeController.text
            : "",
        'codigoPostalComprador': buyerZipCodeController.text.isNotEmpty
            ? buyerZipCodeController.text
            : "",
        'municipioComprador': buyerMunicipalityController.text.isNotEmpty
            ? buyerMunicipalityController.text
            : "",
        'observations': observationsController.text.isNotEmpty
            ? observationsController.text
            : "",
        'observations': acquisitionController.text.isNotEmpty
            ? acquisitionController.text
            : "",
        'provinciaComprador': buyerProvinceController.text.isNotEmpty
            ? buyerProvinceController.text
            : "",
        'modeloUAS':
            uasModelController.text.isNotEmpty ? uasModelController.text : "",
        'metodoNotificacion': notificationMethodController.text.isNotEmpty
            ? notificationMethodController.text
            : "",
        'timestamp': FieldValue
            .serverTimestamp(), // To store when the document is created
      });
      print("Datos guardados exitosamente en Firebase!");
    } catch (e) {
      print("Error al guardar los datos en Firebase: $e");
    }
  }

  @override
  void initState() {
    makeImage();
    super.initState();
  }

  void makeImage() async {
    image = (await rootBundle.load('logo.png')).buffer.asUint8List();
    image1 = (await rootBundle.load('logo2.png')).buffer.asUint8List();
    image2 = (await rootBundle.load('logo1.png')).buffer.asUint8List();
  }

  Future<void> _generateRegistryPDF() async {
    final fontData = await rootBundle.load('fonts/Roboto-Regular.ttf');
    final fontBoldData = await rootBundle.load('fonts/Roboto-Bold.ttf');
    final font = pw.Font.ttf(fontData);
    final fontBold = pw.Font.ttf(fontBoldData);

    final pdfSecondPage = pw.Document();

    pdfSecondPage.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Padding(
            padding: pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Image(
                          width: 200,
                          height: 100,
                          pw.MemoryImage(image1),
                        ),
                        pw.Image(
                          width: 140,
                          height: 100,
                          pw.MemoryImage(image2),
                        ),
                        pw.Image(
                          width: 120,
                          height: 100,
                          pw.MemoryImage(image),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 20),
                    pw.Text(
                      "REGISTRO DE VENTA DE SISTEMAS DE AERONAVES NO TRIPULADAS (UAS)",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        font: fontBold,
                      ),
                    ),
                    pw.SizedBox(height: 20),

                    pw.Table(
                      border: pw.TableBorder.all(
                          color: PdfColors.black, width: 0.5),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Tipo de Registro",
                              style: pw.TextStyle(
                                  fontSize: 9,
                                  fontWeight: pw.FontWeight.bold,
                                  font: fontBold),
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Text(
                              uasSerialNumberController.text,
                              style: pw.TextStyle(
                                fontSize: 9,
                                font: font,
                              ),
                            ),
                          ),
                        ]),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                      },
                      children: [],
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                        2: pw.FlexColumnWidth(3),
                        3: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Número de Serie de UAS",
                              style: pw.TextStyle(
                                  fontSize: 9,
                                  fontWeight: pw.FontWeight.bold,
                                  font: fontBold),
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Row(
                              children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    uasSerialNumberController.text,
                                    style: pw.TextStyle(
                                      color: PdfColors.green600,
                                      fontSize: 13,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ],
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Fecha de registro",
                              style: pw.TextStyle(
                                  fontSize: 9,
                                  fontWeight: pw.FontWeight.bold,
                                  font: fontBold),
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Row(
                              children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    registrationDateController.text,
                                    style: pw.TextStyle(
                                      fontSize: 9,
                                      color: PdfColors.red,
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ],
                            ),
                          ),
                        ]),
                      ],
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(1),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              color: PdfColors.grey300,
                              child: pw.Text(
                                "COMPRADOR DE UAS",
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  fontSize: 9,
                                  fontWeight: pw.FontWeight.bold,
                                  font: fontBold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                      },
                      children: [
                        _buildTableRow("nombre completo o razón social",
                            corporateNameController.text,
                            font: font, fontBold: fontBold),
                      ],
                    ),
                    // First Table for DNI and Address
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                      },
                      children: [
                        _buildTableRow("DNI, NIF, NIE o Pasaporte",
                            buyerDNIController.text,
                            font: font, fontBold: fontBold),
                      ],
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                        2: pw.FlexColumnWidth(3),
                        3: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Nacionalidad",
                              style: pw.TextStyle(
                                  fontSize: 9, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Row(children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    buyerNationalityController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ])),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Fecha de Nacimiento",
                              style: pw.TextStyle(
                                  fontSize: 9, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Row(
                              children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    birthDateCodeController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ],
                            ),
                          ),
                        ]),
                      ],
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                        2: pw.FlexColumnWidth(3),
                        3: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Teléfono",
                              style: pw.TextStyle(
                                  fontSize: 9, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Row(children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    buyerPhoneController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ])),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Correo Electrónico",
                              style: pw.TextStyle(
                                  fontSize: 9, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Row(children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    buyerEmailController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ])),
                        ]),
                      ],
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                      },
                      children: [
                        _buildTableRow("Dirección", buyerAddressController.text,
                            font: font, fontBold: fontBold),
                      ],
                    ),
                    // First Table for Código Postal and Municipio
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                        2: pw.FlexColumnWidth(3),
                        3: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Código Postal",
                              style: pw.TextStyle(
                                  fontSize: 9, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Row(children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    buyerZipCodeController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ])),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Municipio",
                              style: pw.TextStyle(
                                  fontSize: 9, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Row(children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    buyerMunicipalityController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ])),
                        ]),
                      ],
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                        2: pw.FlexColumnWidth(3),
                        3: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Provincia",
                              style: pw.TextStyle(
                                  fontSize: 9, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Row(children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    buyerProvinceController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ])),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "País/Country",
                              style: pw.TextStyle(
                                  fontSize: 9, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Row(children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    buyerCountryController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ])),
                        ]),
                      ],
                    ),
                    // Table for Método de Notificación
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Método de Notificación",
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                                font: fontBold,
                              ),
                            ),
                          ),
                          pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Row(children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    notificationMethodController.text == 'email'
                                        ? 'Por Email'
                                        : 'Por Papel',
                                    style:
                                        pw.TextStyle(fontSize: 9, font: font),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ])),
                        ]),
                      ],
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Marca y modelo del UAS",
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                                font: fontBold,
                              ),
                            ),
                          ),
                          pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Row(children: [
                                pw.Text(
                                  modelController.text,
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    color: PdfColors.yellow,
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ])),
                        ]),
                      ],
                    ),

                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "medio de adquisición",
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                                font: fontBold,
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Row(
                              children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    acquisitionController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ],
                            ),
                          ),
                        ]),
                      ],
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Observaciones",
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                                font: fontBold,
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Row(
                              children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    observationsController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ],
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    pdfSecondPage.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Padding(
            padding: pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Image(
                          width: 200,
                          height: 100,
                          pw.MemoryImage(image1),
                        ),
                        pw.Image(
                          width: 140,
                          height: 100,
                          pw.MemoryImage(image2),
                        ),
                        pw.Image(
                          width: 120,
                          height: 100,
                          pw.MemoryImage(image),
                        ),
                      ],
                    ),

                    pw.SizedBox(height: 20),
                    // Start of Table
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                      },
                      children: [],
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                        2: pw.FlexColumnWidth(3),
                        3: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Número de Serie de UAS",
                              style: pw.TextStyle(
                                  fontSize: 9,
                                  fontWeight: pw.FontWeight.bold,
                                  font: fontBold),
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Row(
                              children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    uasSerialNumberController.text,
                                    style: pw.TextStyle(
                                      color: PdfColors.green600,
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ],
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Fecha de registro",
                              style: pw.TextStyle(
                                  fontSize: 9,
                                  fontWeight: pw.FontWeight.bold,
                                  font: fontBold),
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Row(
                              children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    registrationDateController.text,
                                    style: pw.TextStyle(
                                      fontSize: 9,
                                      color: PdfColors.red,
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ],
                            ),
                          ),
                        ]),
                      ],
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(1),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              color: PdfColors.grey300,
                              child: pw.Text(
                                "VENDEDOR DE UAS",
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  fontSize: 9,
                                  fontWeight: pw.FontWeight.bold,
                                  font: fontBold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                      },
                      children: [
                        _buildTableRow("nombre completo o razón social",
                            corporateNameController.text,
                            font: font, fontBold: fontBold),
                      ],
                    ),
                    // First Table for DNI and Address
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                      },
                      children: [
                        _buildTableRow("DNI, NIF, NIE o Pasaporte",
                            buyerDNIController.text,
                            font: font, fontBold: fontBold),
                      ],
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                        2: pw.FlexColumnWidth(3),
                        3: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Nacionalidad",
                              style: pw.TextStyle(
                                  fontSize: 9, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Row(children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    buyerNationalityController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ])),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Fecha de Nacimiento",
                              style: pw.TextStyle(
                                  fontSize: 9, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Row(
                              children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    birthDateCodeController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ],
                            ),
                          ),
                        ]),
                      ],
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                        2: pw.FlexColumnWidth(3),
                        3: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Teléfono",
                              style: pw.TextStyle(
                                  fontSize: 9, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Row(children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    buyerPhoneController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ])),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Correo Electrónico",
                              style: pw.TextStyle(
                                  fontSize: 9, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Row(children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    buyerEmailController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ])),
                        ]),
                      ],
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                      },
                      children: [
                        _buildTableRow("Dirección", buyerAddressController.text,
                            font: font, fontBold: fontBold),
                      ],
                    ),
                    // First Table for Código Postal and Municipio
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                        2: pw.FlexColumnWidth(3),
                        3: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Código Postal",
                              style: pw.TextStyle(
                                  fontSize: 9, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Row(children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    buyerZipCodeController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ])),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Municipio",
                              style: pw.TextStyle(
                                  fontSize: 9, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Row(children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    buyerMunicipalityController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ])),
                        ]),
                      ],
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                        2: pw.FlexColumnWidth(3),
                        3: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Provincia",
                              style: pw.TextStyle(
                                  fontSize: 9, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Row(children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    buyerProvinceController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ])),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "País/Country",
                              style: pw.TextStyle(
                                  fontSize: 9, fontWeight: pw.FontWeight.bold),
                            ),
                          ),
                          pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Row(children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    buyerCountryController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ])),
                        ]),
                      ],
                    ),
                    // Table for Método de Notificación
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Método de Notificación",
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                                font: fontBold,
                              ),
                            ),
                          ),
                          pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Row(children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    notificationMethodController.text == 'email'
                                        ? 'Por Email'
                                        : 'Por Papel',
                                    style:
                                        pw.TextStyle(fontSize: 9, font: font),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ])),
                        ]),
                      ],
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Marca y modelo del UAS",
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                                font: fontBold,
                              ),
                            ),
                          ),
                          pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Row(children: [
                                pw.Text(
                                  modelController.text,
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    color: PdfColors.yellow,
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ])),
                        ]),
                      ],
                    ),

                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "medio de adquisición",
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                                font: fontBold,
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Row(
                              children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    acquisitionController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ],
                            ),
                          ),
                        ]),
                      ],
                    ),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(3),
                        1: pw.FlexColumnWidth(5),
                      },
                      children: [
                        pw.TableRow(children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            color: PdfColors.grey300,
                            child: pw.Text(
                              "Observaciones",
                              style: pw.TextStyle(
                                fontSize: 9,
                                fontWeight: pw.FontWeight.bold,
                                font: fontBold,
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(8),
                            child: pw.Row(
                              children: [
                                pw.Container(
                                  color: PdfColors.yellow,
                                  child: pw.Text(
                                    observationsController.text,
                                    style: pw.TextStyle(fontSize: 9),
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(""),
                                )
                              ],
                            ),
                          ),
                        ]),
                      ],
                    ),
                    pw.SizedBox(height: 10),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.black,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: pw.FlexColumnWidth(1),
                      },
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              color: PdfColors.grey300,
                              child: pw.Text(
                                "DECLARACIÓN RESPONSABLE",
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  fontSize: 9,
                                  fontWeight: pw.FontWeight.bold,
                                  font: fontBold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Container(
                              padding: pw.EdgeInsets.all(8),
                              child: pw.Text(
                                "El presente documento constituye una declaración responsable. Que todos los documentos presentados en este registro son ciertos y su contenido coincide plenamente con los originales de los que son, responsabilizándome de la veracidad de los mismos. Adjuntado a este documento copia de DNI, NIF, NIE o nº pasaporte del comprador y vendedor.",
                                style: pw.TextStyle(
                                  fontSize: 9,
                                  font: font,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );

    pdfSecondPage.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => [
          pw.Padding(
            padding: pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColors.black,
                    width: 0.5,
                  ),
                  columnWidths: {
                    0: pw.FlexColumnWidth(1),
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          color: PdfColors.grey300,
                          child: pw.Text(
                            "NORMATIVA DE REGISTRO DE AERONAVES/ AIRCRAFT REGISTRATION REGULATIONS",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              font: fontBold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.start,
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  "Según BOE, Nº136, miércoles 5 de junio del 2024.\n\n"
                                  "En su capítulo VI de la sección 1ª, en los artículos:\n\n"
                                  "Artículo 48. Registro de operadores de UAS.\n\n"
                                  "Artículo 49. Inscripción y actualización de datos registrados\n\n"
                                  "Artículo 50. Cancelación y suspensión de la inscripción a instancia de parte.\n\n"
                                  "Artículo 51. Cancelación de la inscripción de oficio.\n\n"
                                  "En su sección 2ª, articulo 52 Registro de aeronaves no tripuladas cuyo diseño esté sujeto a certificación.\n\n",
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    font: font,
                                  ),
                                ),
                                //   pw.Text(
                                //    "Sección 3ª, Registro aeronaves no tripuladas del Ministerio del Interior y registro de comercialización y venta.\n\n"

                                //  ,
                                //   style: pw.TextStyle(
                                //     fontSize: 9,
                                //     font: font,
                                //   ),
                                // ),
                                pw.Container(
                                  padding: pw.EdgeInsets.all(8),
                                  child: pw.Row(
                                    children: [
                                      pw.Container(
                                        color: PdfColors.greenAccent,
                                        child: pw.Text(
                                          "Sección 3ª, Registro aeronaves no tripuladas del Ministerio del Interior y registro de\ncomercialización y venta.\n",
                                          style: pw.TextStyle(
                                            fontSize: 9,
                                            font: font,
                                          ),
                                        ),
                                      ),
                                      pw.Expanded(
                                        child: pw.Text(""),
                                      )
                                    ],
                                  ),
                                ),
                                pw.Text(
                                  "En los artículos:\n\n",
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    font: font,
                                  ),
                                ),
                                pw.Text(
                                  "Artículo 53. Creación del Registro de aeronaves no tripuladas del Ministerio del Interior.\n",
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    font: font,
                                  ),
                                ),
                                pw.Container(
                                  padding: pw.EdgeInsets.all(8),
                                  child: pw.Row(
                                    children: [
                                      pw.Container(
                                        color: PdfColors.greenAccent,
                                        child: pw.Text(
                                          "Artículo 54. Obligaciones de inscripción en la comercialización, venta y adquisición.\n\n",
                                          style: pw.TextStyle(
                                            fontSize: 9,
                                            font: font,
                                          ),
                                        ),
                                      ),
                                      pw.Expanded(
                                        child: pw.Text(""),
                                      )
                                    ],
                                  ),
                                ),

                                pw.Text(
                                  "Artículo 55. Obligaciones de comunicar la transmisión de las aeronaves no tripuladas.\n\n"
                                  "Artículo 56. Obligaciones de inscripción sobre la pérdida de la aeronave o su inhabilidad para operar.\n\n"
                                  "Artículo 57. Obligaciones adicionales del establecimiento.\n\n"
                                  "Artículo 58. Tratamiento de datos de carácter personal.",
                                  style: pw.TextStyle(
                                    fontSize: 9,
                                    font: font,
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColors.black,
                    width: 0.5,
                  ),
                  columnWidths: {
                    0: pw.FlexColumnWidth(1),
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          color: PdfColors.grey300,
                          child: pw.Text(
                            "VALIDEZ DEL PRESENTE DOCUMENTO",
                            textAlign: pw.TextAlign.center,
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              font: fontBold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text(
                            "Los documentos emitidos por COMPRODRONE disponen de un código de verificación para que el destinatario pueda verificar su autenticidad. Este código puede encontrarse al pie del documento. Por tanto, el Código Seguro de Verificación (CSV) o Código de Identificación del Documento (CID) permite la verificación de la integridad de la copia de este documento.",
                            style: pw.TextStyle(
                              color: PdfColors.brown,
                              fontSize: 9,
                              font: font,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 70),
                pw.Center(
                  child: pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    color: PdfColors.grey300,
                    child: pw.Text(
                      "COMPRODRONE\n C/ Afueras de Santa Ana 22\n 37210 Vitigudino\n (Salamanca)",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 9,
                        font: font,
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Center(
                  child: pw.Image(
                    pw.MemoryImage(image),
                    width: 200, // Set the desired width
                    height: 200, // Set the desired height
                  ),
                ),
                pw.SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );

    await Printing.sharePdf(
        bytes: await pdfSecondPage.save(), filename: 'Sale_Registration.pdf');
  }

  pw.TableRow _buildTableRow(String field, String value,
      {bool grey = false, required pw.Font font, required pw.Font fontBold}) {
    return pw.TableRow(children: [
      // First Column: Field Name (Grey Background)
      pw.Container(
        padding: pw.EdgeInsets.all(8),
        color: grey ? PdfColors.grey300 : PdfColors.white,
        child: pw.Text(
          field,
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            font: fontBold, // Use fontBold for the field name
          ),
        ),
      ),
      // Second Column: Value
      // pw.Container(
      //   padding: pw.EdgeInsets.all(8),
      //   child: pw.Text(
      //     value,
      //     style: pw.TextStyle(fontSize: 9, font: font), // Use font for value
      //   ),
      // ),
      pw.Container(
        padding: pw.EdgeInsets.all(8),
        child: pw.Row(
          children: [
            pw.Container(
              color: PdfColors.yellow,
              child: pw.Text(
                value,
                style: pw.TextStyle(fontSize: 9, font: font),
              ),
            ),
            pw.Expanded(
              child: pw.Text(""),
            ),
          ],
        ),
      ),
    ]);
  }

  Future<void> _generateContractPDF() async {
    // 1st page: Contract of Sale
// Primera página: Contrato de Venta
    final pdfFirstPage = pw.Document();
    pdfFirstPage.addPage(
      pw.MultiPage(
        header: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.center,
            padding: const pw.EdgeInsets.only(bottom: 3),
            child: pw.Container(
              width: 30,
              height: 30,
              alignment: pw.Alignment.center,
              decoration: pw.BoxDecoration(
                color: PdfColors.blue,
                shape: pw.BoxShape.circle,
              ),
              child: pw.Text(
                '${context.pageNumber}',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
          );
        },
        build: (pw.Context context) => [
          pw.Padding(
            padding: pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Image(pw.MemoryImage(
                  image,
                )),
                pw.SizedBox(height: 20),

                pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    "Número de Orden ${OrderNumberController.text}",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 16),
                  ),
                ),
                pw.SizedBox(height: 30),
                pw.Text(
                  "CONTRATO DE VENTA DE DRONE DE SEGUNDA MANO",
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    "En ${buyerCityController.text} a ${DateFormat('d de MMMM de yyyy').format(DateTime.now())}",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 16),
                  ),
                ),

                pw.SizedBox(height: 20),
                pw.Container(
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    textAlign: pw.TextAlign.center,
                    "REUNIDOS:",
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold),
                  ),
                ),

                pw.SizedBox(height: 10),
                pw.Text(
                  textAlign: pw.TextAlign.left,
                  "Por un lado, como EL VENDEDOR",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Container(
                  child: pw.Text(
                    "El Sr. ${sellerNameController.text}, mayor de edad, con D.N.I ${sellerDNIController.text} y con domicilio en ${sellerAddressController.text}, ${sellerCityController.text}.",
                    textAlign: pw.TextAlign.left,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  textAlign: pw.TextAlign.left,
                  "Por otro lado, como EL COMPRADOR:",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Container(
                  child: pw.Text(
                    "El Sr. ${buyerNameController.text}, mayor de edad, con D.N.I ${buyerDNIController.text} y con domicilio en ${buyerAddressController.text}, ${buyerCityController.text}.",
                    textAlign: pw.TextAlign.left,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  "Ambas partes contratantes reconocen tener capacidad legal para este acto, y actúan en su propio nombre y derecho.",
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  "Exponen:",
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.Bullet(
                  text:
                      "Que el vendedor ha anunciado su dron en la página web www.comprodrone.com propiedad del Sr. Eliseo Prieto Iglesias con D.N.I 70873396T, residente en Afueras de Santa Ana 22, Vitigudino Salamanca. En adelante, ComproDrone.",
                ),
                pw.Bullet(
                  text:
                      "El comprador ha adquirido el dron, especificado a continuación, a través de la plataforma ComproDrone.",
                ),
                pw.Bullet(
                  text:
                      "Que ambas partes han acordado formalizar un contrato de compraventa de un dron usado:",
                ),
                pw.SizedBox(height: 10),
                pw.Text("MARCA: ${droneModelController.text}",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("MODELO: ${droneModelController.text}",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("NÚMERO DE SERIE: ${droneSerialController.text}",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("ESTADO: SEMINUEVO",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text("POSIBLES DEFECTOS: NINGUNO",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Bullet(
                  text:
                      "Que el comprador declara haber sido informado del estado del dron, en su conjunto y en sus elementos mecánicos y componentes fundamentales, su antigüedad así como los extras que posee. También del estado de las baterías.",
                ),
                pw.SizedBox(height: 10),
                pw.Bullet(
                  text:
                      "Se declara además que el comprador ha examinado personalmente y de forma directa el dron o a través de un tercero o por medios telemáticos y ha realizado las pruebas que libremente ha considerado pertinentes para verificar su correcto funcionamiento.",
                ),
                pw.SizedBox(height: 10),
                pw.Bullet(
                  text:
                      "Que el dron objeto de esta compraventa no tiene defectos ocultos ni fallos conocidos y funciona correctamente. El vendedor debe informar al comprador de cualquier posible defecto, fallo o accidente que el dron haya sufrido durante su uso.",
                ),
                pw.SizedBox(height: 10),
                pw.Bullet(
                  text:
                      "El comprador ha adquirido el dron a través de la página web www.comprodrone.com.",
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  "ESTIPULACIONES:",
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 15),
                pw.Text(
                    "PRIMERO: El vendedor vende al comprador el dron de su propiedad previamente especificado por el importe de ${dronePriceController.text} euros, excluyendo los impuestos correspondientes, si los hubiere (no todos los países requieren impuestos para la venta del dron), que serán a cargo del comprador, así como la comisión a ComproDrone.",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text(
                    "SEGUNDO: El vendedor declara que no existen cargas ni gravámenes, impuestos, pagos pendientes, deudas o sanciones pendientes sobre dicho dron en la fecha de la firma de este contrato, y se compromete en caso contrario a regularizar tal situación a su costa. Asimismo, el vendedor garantiza que el dron ha sido dado de baja en el registro de operadores profesionales o en cualquier otro registro asociado al vendedor.",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text(
                    "TERCERO: Por el presente acto, el dron se entrega al comprador. El comprador es responsable desde la fecha de este documento de cualquier asunto que pueda surgir del uso o posesión del mismo, incluyendo responsabilidades, sanciones, seguros de responsabilidad civil o cualquier otro documento exigido por la normativa del país para el uso de drones.",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text(
                    "CUARTO: El comprador declara conocer el estado actual del dron y exonera expresamente a ComproDrone y al vendedor de cualquier responsabilidad por defectos ocultos o posibles averías que el bien pudiera manifestar en el futuro, según lo determinado en el Código Civil del país, salvo aquellos ocultos que se originen en fraude o mala fe del vendedor y no hayan sido comunicados.",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                pw.Text(
                  "El vendedor será responsable ante el comprador tanto de la posesión legal y pacífica del dron como de los defectos ocultos que pueda tener, durante el periodo establecido por la ley de acuerdo con el Código Civil del país.",
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  "No habrá responsabilidad del vendedor por averías o deficiencias del dron, aparecidas después de su entrega, cuando estas circunstancias se produzcan o se motiven por un uso indebido; o por fuerza mayor, robo, negligencia, accidente o falta de mantenimiento aconsejado por el fabricante, así como los defectos existentes en el momento de la entrega del dron, siempre que fueran conocidos y consentidos por el comprador.",
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  "La empresa ComproDrone no se responsabiliza de los daños sufridos por los artículos enviados, así como de la pérdida o retrasos en la logística.",
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                    "QUINTO: Para cualquier litigio que surja entre las partes en relación con la interpretación o cumplimiento de este contrato, se someten, con renuncia expresa a la jurisdicción que pudiera corresponderles, a los Juzgados y Tribunales de Salamanca.",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text(
                    "Y para que conste, firman este contrato de compraventa de 5 páginas, por duplicado, en la fecha y lugar indicados anteriormente."),
                pw.SizedBox(height: 70),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text(
                          "Firma del VENDEDOR",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 50),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text(
                          "Firma del COMPRADOR",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 50),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text(
                          "Firma del TESTIGO",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.SizedBox(height: 50),
                      ],
                    ),
                  ],
                ),

                // Quiero mostrar aquí una imagen de mis activos como assets/logo.png,
                pw.Image(pw.MemoryImage(
                  image,
                )),
              ],
            ),
          ),
        ],
      ),
    );
    await Printing.sharePdf(
        bytes: await pdfFirstPage.save(), filename: 'Contract_of_Sale.pdf');

    // 2nd page: UAS Sale Registration and Declaration
    // final pdfSecondPage = pw.Document();

    // await Printing.sharePdf(
    //     bytes: await pdfSecondPage.save(), filename: 'Sale_Registration.pdf');
  }

  // pw.TableRow _buildTableRow(String field, String value, {bool grey = false}) {
  //   return pw.TableRow(children: [
  //     // First Column: Field Name (Grey Background)
  //     pw.Container(
  //       padding: pw.EdgeInsets.all(8),
  //       color: grey ? PdfColors.grey300 : PdfColors.white,
  //       child: pw.Text(field,
  //           style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
  //     ),
  //     // Second Column: Value
  //     pw.Container(
  //       padding: pw.EdgeInsets.all(8),
  //       child: pw.Text(value, style: pw.TextStyle(fontSize: 9)),
  //     ),
  //   ]);
  // }

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
                  corporateNameController, 'Nombre Corporativo', Icons.home),
              _buildTextField(
                  buyerPhoneController, 'Teléfono del Comprador', Icons.phone),
              _buildTextField(
                  buyerEmailController, 'Email del Comprador', Icons.email),
              _buildTextField(
                  OrderNumberController, 'numeroOrden', Icons.location_city),
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
                  sellerEmailController, 'Email del Vendedor', Icons.email),
              _buildTextField(sellerCityController, 'Ciudad del Vendedor',
                  Icons.location_city),
              SizedBox(height: 20),

              Text('Detalles del Dron',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              _buildTextField(
                  droneModelController, 'Modelo del Dron', Icons.toys),
              _buildTextField(droneSerialController, 'Número de Serie',
                  Icons.confirmation_number),
              _buildTextField(
                  dronePriceController, 'Precio del Dron', Icons.attach_money),
              SizedBox(height: 20),
              Text("Para el Registro",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              // Add these additional fields to the form:
              _buildTextField(uasSerialNumberController,
                  'Número de Serie de UAS', Icons.confirmation_number),
              _buildTextField(registrationTypeController, 'Tipo de Registro',
                  Icons.confirmation_number),
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      registrationDateController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
                child: AbsorbPointer(
                  child: _buildTextField(
                    registrationDateController,
                    'Fecha de Registro',
                    Icons.date_range,
                  ),
                ),
              ),
              _buildTextField(
                  buyerNationalityController, 'Nacionalidad', Icons.flag),
              _buildTextField(
                  birthDateCodeController, 'Fecha de Nacimiento', Icons.person),
              _buildTextField(
                  buyerZipCodeController, 'Código Postal', Icons.location_on),
              _buildTextField(buyerMunicipalityController, 'Municipio',
                  Icons.location_city),
              _buildTextField(
                  buyerProvinceController, 'Provincia', Icons.kayaking),
              _buildTextField(
                  buyerCountryController, 'País del Comprador', Icons.map),
              _buildTextField(modelController, 'Modelo', Icons.update),
              // _buildTextField(buyerCityController, 'País', Icons.map),
              _buildTextField(uasModelController, 'Modelo de UAS', Icons.toys),
              _buildTextField(
                  observationsController, 'Observaciones', Icons.note),
              _buildTextField(acquisitionController, 'Medio de Adquisición',
                  Icons.label_important),
              Row(
                children: [
                  Text('Método de Notificación:'),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Por Email'),
                      value: 'email',
                      groupValue: notificationMethodController.text,
                      onChanged: (value) {
                        setState(() {
                          notificationMethodController.text = value!;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text('Por Papel'),
                      value: 'paper',
                      groupValue: notificationMethodController.text,
                      onChanged: (value) {
                        setState(() {
                          notificationMethodController.text = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _submitFormAndGenerateContractPDF,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Generar Contrato PDF',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _submitFormAndGenerateRegistryPDF,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Generar Registro PDF',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitFormAndGenerateContractPDF() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _saveDataToFirebase(); // Save to Firebase
      await _generateContractPDF(); // Generate and share Contract PDF
    }
  }

  Future<void> _submitFormAndGenerateRegistryPDF() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _saveDataToFirebase(); // Save to Firebase
      await _generateRegistryPDF(); // Generate and share Registry PDF
    }
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
        validator: (value) => value!.isEmpty ? 'This field is required' : null,
      ),
    );
  }
}
