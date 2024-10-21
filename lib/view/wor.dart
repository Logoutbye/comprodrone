// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:com_pro_drone/view/contract_history.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:intl/intl.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class ContractCreationScreen extends StatefulWidget {
//   @override
//   _ContractCreationScreenState createState() => _ContractCreationScreenState();
// }

// class _ContractCreationScreenState extends State<ContractCreationScreen> {
//   final _formKey = GlobalKey<FormState>();

//   // Controllers for buyer, seller, and drone details
//   TextEditingController buyerNameController = TextEditingController();
//   TextEditingController buyerDNIController = TextEditingController();
//   TextEditingController buyerAddressController = TextEditingController();
//   TextEditingController buyerPhoneController = TextEditingController();
//   TextEditingController buyerEmailController = TextEditingController();
//   TextEditingController buyerCityController = TextEditingController();

//   TextEditingController sellerNameController = TextEditingController();
//   TextEditingController sellerDNIController = TextEditingController();
//   TextEditingController sellerAddressController = TextEditingController();
//   TextEditingController sellerPhoneController = TextEditingController();
//   TextEditingController sellerEmailController = TextEditingController();
//   TextEditingController sellerCityController = TextEditingController();

//   TextEditingController droneModelController = TextEditingController();
//   TextEditingController droneSerialController = TextEditingController();
//   TextEditingController dronePriceController = TextEditingController();
//   TextEditingController uasSerialNumberController = TextEditingController();
//   TextEditingController registrationDateController = TextEditingController();
//   TextEditingController buyerNationalityController = TextEditingController();
//   TextEditingController buyerZipCodeController = TextEditingController();
//   TextEditingController birthDateCodeController = TextEditingController();
//   TextEditingController buyerMunicipalityController = TextEditingController();
//   TextEditingController buyerProvinceController = TextEditingController();
//   TextEditingController buyerCountryController = TextEditingController();

//   TextEditingController uasModelController = TextEditingController();
//   TextEditingController notificationMethodController = TextEditingController();
//   TextEditingController observationsController = TextEditingController();

//   var image;
//   var image1;
//   var image2;

//   @override
//   void dispose() {
//     buyerNameController.dispose();
//     buyerDNIController.dispose();
//     buyerAddressController.dispose();
//     buyerPhoneController.dispose();
//     buyerEmailController.dispose();
//     buyerCityController.dispose();

//     sellerNameController.dispose();
//     sellerDNIController.dispose();
//     sellerAddressController.dispose();
//     sellerPhoneController.dispose();
//     sellerEmailController.dispose();
//     sellerCityController.dispose();

//     droneModelController.dispose();
//     droneSerialController.dispose();
//     dronePriceController.dispose();
//     super.dispose();
//   }

//   Future<void> _saveDataToFirebase() async {
//     try {
//       await FirebaseFirestore.instance.collection('contracts').add({
//         'nombreComprador':
//             buyerNameController.text.isNotEmpty ? buyerNameController.text : "",
//         'dniComprador':
//             buyerDNIController.text.isNotEmpty ? buyerDNIController.text : "",
//         'direccionComprador': buyerAddressController.text.isNotEmpty
//             ? buyerAddressController.text
//             : "",
//         'telefonoComprador': buyerPhoneController.text.isNotEmpty
//             ? buyerPhoneController.text
//             : "",
//         'emailComprador': buyerEmailController.text.isNotEmpty
//             ? buyerEmailController.text
//             : "",
//         'ciudadComprador':
//             buyerCityController.text.isNotEmpty ? buyerCityController.text : "",
//         'nombreVendedor': sellerNameController.text.isNotEmpty
//             ? sellerNameController.text
//             : "",
//         'dniVendedor':
//             sellerDNIController.text.isNotEmpty ? sellerDNIController.text : "",
//         'direccionVendedor': sellerAddressController.text.isNotEmpty
//             ? sellerAddressController.text
//             : "",
//         'telefonoVendedor': sellerPhoneController.text.isNotEmpty
//             ? sellerPhoneController.text
//             : "",
//         'emailVendedor': sellerEmailController.text.isNotEmpty
//             ? sellerEmailController.text
//             : "",
//         'ciudadVendedor': sellerCityController.text.isNotEmpty
//             ? sellerCityController.text
//             : "",
//         'modeloDron': droneModelController.text.isNotEmpty
//             ? droneModelController.text
//             : "",
//         'numeroSerieDron': droneSerialController.text.isNotEmpty
//             ? droneSerialController.text
//             : "",
//         'precioDron': dronePriceController.text.isNotEmpty
//             ? dronePriceController.text
//             : "",
//         'numeroSerieUAS': uasSerialNumberController.text.isNotEmpty
//             ? uasSerialNumberController.text
//             : "",
//         'fechaRegistro': registrationDateController.text.isNotEmpty
//             ? registrationDateController.text
//             : "",
//         'nacionalidadComprador': buyerNationalityController.text.isNotEmpty
//             ? buyerNationalityController.text
//             : "",
//         'fechadenacimiento': birthDateCodeController.text.isNotEmpty
//             ? birthDateCodeController.text
//             : "",
//         'codigoPostalComprador': buyerZipCodeController.text.isNotEmpty
//             ? buyerZipCodeController.text
//             : "",
//         'municipioComprador': buyerMunicipalityController.text.isNotEmpty
//             ? buyerMunicipalityController.text
//             : "",
//         'observations': observationsController.text.isNotEmpty
//             ? observationsController.text
//             : "",
//         'provinciaComprador': buyerProvinceController.text.isNotEmpty
//             ? buyerProvinceController.text
//             : "",
//         'modeloUAS':
//             uasModelController.text.isNotEmpty ? uasModelController.text : "",
//         'metodoNotificacion': notificationMethodController.text.isNotEmpty
//             ? notificationMethodController.text
//             : "",
//         'timestamp': FieldValue
//             .serverTimestamp(), // To store when the document is created
//       });
//       print("Datos guardados exitosamente en Firebase!");
//     } catch (e) {
//       print("Error al guardar los datos en Firebase: $e");
//     }
//   }

//   void initState() {
//     makeImage();
//     super.initState();
//   }

//   void makeImage() async {
//     image = (await rootBundle.load('logo.png')).buffer.asUint8List();
//     image1 = (await rootBundle.load('logo2.png')).buffer.asUint8List();
//     image2 = (await rootBundle.load('logo1.png')).buffer.asUint8List();
//   }

//   Future<void> _generateRegistryPDF() async {
//     final fontData = await rootBundle.load('fonts/Roboto-Regular.ttf');
//     final fontBoldData = await rootBundle.load('fonts/Roboto-Bold.ttf');
//     final font = pw.Font.ttf(fontData);
//     final fontBold = pw.Font.ttf(fontBoldData);

//     final pdfSecondPage = pw.Document();
//     pdfSecondPage.addPage(
//       pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) => [
//           pw.Padding(
//             padding: pw.EdgeInsets.all(20),
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Padding(
//                   padding: pw.EdgeInsets.all(20),
//                   child: pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       pw.Row(
//                         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                         children: [
//                           pw.Image(
//                             width: 200,
//                             height: 100,
//                             pw.MemoryImage(image1),
//                           ),
//                           pw.Image(
//                             width: 200,
//                             height: 100,
//                             pw.MemoryImage(image2),
//                           ),
//                           pw.Image(
//                             width: 200,
//                             height: 100,
//                             pw.MemoryImage(image),
//                           ),
//                         ],
//                       ),
//                       pw.SizedBox(height: 50),
//                       pw.Text(
//                         "REGISTRO DE VENTA DE SISTEMAS DE AERONAVES NO TRIPULADAS (UAS)",
//                         textAlign: pw.TextAlign.center,
//                         style: pw.TextStyle(
//                           fontSize: 15,
//                           fontWeight: pw.FontWeight.bold,
//                           font: fontBold,
//                         ),
//                       ),
//                       pw.SizedBox(height: 20),
//                       // Start of Table
//                       pw.Table(
//                         border: pw.TableBorder.all(
//                           color: PdfColors.black,
//                           width: 0.5,
//                         ),
//                         columnWidths: {
//                           0: pw.FlexColumnWidth(3),
//                           1: pw.FlexColumnWidth(5),
//                         },
//                         children: [
//                           // Header Row for Serial and Date
//                           pw.TableRow(children: [
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.grey300,
//                               child: pw.Text(
//                                 "Número de Serie de UAS",
//                                 style: pw.TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: pw.FontWeight.bold,
//                                     font: fontBold),
//                               ),
//                             ),
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.yellow,
//                               child: pw.Text(
//                                 uasSerialNumberController.text,
//                                 style: pw.TextStyle(
//                                   fontSize: 12,
//                                   font: font,
//                                 ),
//                               ),
//                             ),
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.white,
//                               child: pw.Text(
//                                 "Fecha de registro",
//                                 style: pw.TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: pw.FontWeight.bold,
//                                     font: fontBold),
//                               ),
//                             ),
//                             pw.Container(
//                               color: PdfColors.yellow,
//                               padding: pw.EdgeInsets.all(8),
//                               child: pw.Text(
//                                 registrationDateController.text,
//                                 style: pw.TextStyle(fontSize: 12, font: font),
//                               ),
//                             ),
//                           ]),
//                           // UAS Buyer Info Section
//                           pw.TableRow(children: [
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.grey300,
//                               child: pw.Text(
//                                 "COMPRADOR DE UAS",
//                                 style: pw.TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: pw.FontWeight.bold,
//                                   font: fontBold,
//                                 ),
//                               ),
//                             ),
//                           ]),
//                           pw.TableRow(children: [
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.yellow,
//                               child: pw.Text(
//                                 buyerNameController.text,
//                                 style: pw.TextStyle(fontSize: 12, font: font),
//                               ),
//                             ),
//                           ]),
//                           pw.TableRow(children: [
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.grey300,
//                               child: pw.Text(
//                                 "DNI, NIF, NIE o Pasaporte",
//                                 style: pw.TextStyle(
//                                   fontSize: 12,
//                                   fontWeight: pw.FontWeight.bold,
//                                   font: fontBold,
//                                 ),
//                               ),
//                             ),
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.yellow,
//                               child: pw.Text(
//                                 buyerDNIController.text,
//                                 style: pw.TextStyle(fontSize: 12, font: font),
//                               ),
//                             ),
//                           ]),
//                           pw.TableRow(children: [
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.grey300,
//                               child: pw.Text(
//                                 "Nacionalidad",
//                                 style: pw.TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: pw.FontWeight.bold),
//                               ),
//                             ),
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.yellow,
//                               child: pw.Text(
//                                 buyerNationalityController.text,
//                                 style: pw.TextStyle(fontSize: 12),
//                               ),
//                             ),
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.grey300,
//                               child: pw.Text(
//                                 "Fecha de Nacimiento",
//                                 style: pw.TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: pw.FontWeight.bold),
//                               ),
//                             ),
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.yellow,
//                               child: pw.Text(
//                                 birthDateCodeController.text,
//                                 style: pw.TextStyle(fontSize: 12),
//                               ),
//                             ),
//                           ]),

//                           pw.TableRow(children: [
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.grey300,
//                               child: pw.Text(
//                                 "Teléfono",
//                                 style: pw.TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: pw.FontWeight.bold),
//                               ),
//                             ),
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.yellow,
//                               child: pw.Text(
//                                 buyerPhoneController.text,
//                                 style: pw.TextStyle(fontSize: 12),
//                               ),
//                             ),
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.grey300,
//                               child: pw.Text(
//                                 "Correo Electrónico",
//                                 style: pw.TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: pw.FontWeight.bold),
//                               ),
//                             ),
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.yellow,
//                               child: pw.Text(
//                                 buyerEmailController.text,
//                                 style: pw.TextStyle(fontSize: 12),
//                               ),
//                             ),
//                           ]),
//                           // Continue table rows...
//                           _buildTableRow(
//                               "Dirección", buyerAddressController.text,
//                               font: font, fontBold: fontBold),
//                           pw.TableRow(children: [
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.grey300,
//                               child: pw.Text(
//                                 "Código Postal",
//                                 style: pw.TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: pw.FontWeight.bold),
//                               ),
//                             ),
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.yellow,
//                               child: pw.Text(
//                                 buyerZipCodeController.text,
//                                 style: pw.TextStyle(fontSize: 12),
//                               ),
//                             ),
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.grey300,
//                               child: pw.Text(
//                                 "Municipio",
//                                 style: pw.TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: pw.FontWeight.bold),
//                               ),
//                             ),
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.yellow,
//                               child: pw.Text(
//                                 buyerMunicipalityController.text,
//                                 style: pw.TextStyle(fontSize: 12),
//                               ),
//                             ),
//                           ]),
//                           pw.TableRow(children: [
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.grey300,
//                               child: pw.Text(
//                                 "Provincia",
//                                 style: pw.TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: pw.FontWeight.bold),
//                               ),
//                             ),
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.yellow,
//                               child: pw.Text(
//                                 buyerProvinceController.text,
//                                 style: pw.TextStyle(fontSize: 12),
//                               ),
//                             ),
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.grey300,
//                               child: pw.Text(
//                                 "País",
//                                 style: pw.TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: pw.FontWeight.bold),
//                               ),
//                             ),
//                             pw.Container(
//                               padding: pw.EdgeInsets.all(8),
//                               color: PdfColors.yellow,
//                               child: pw.Text(
//                                 buyerCountryController.text,
//                                 style: pw.TextStyle(fontSize: 12),
//                               ),
//                             ),
//                           ]),

//                           // Add additional rows as necessary
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 pw.SizedBox(height: 50),
//                 // Footer Section
//                 pw.Container(
//                   color: PdfColors.grey300,
//                   width: 600,
//                   height: 60,
//                   alignment: pw.Alignment.center,
//                   child: pw.Text(
//                     'VALIDEZ DE ESTE DOCUMENTO',
//                     style: pw.TextStyle(
//                       fontSize: 18,
//                       fontWeight: pw.FontWeight.bold,
//                       font: fontBold,
//                     ),
//                   ),
//                 ),
//                 pw.SizedBox(height: 20),
//                 pw.Text(
//                   'Los documentos emitidos por COMPRODRONE tienen un código de verificación para que el destinatario pueda verificar su autenticidad. Este código se puede encontrar en la parte inferior del documento. Por lo tanto, el Código Seguro de Verificación (CSV) o Código de Identificación del Documento (CID) permite verificar la integridad de la copia de este documento.',
//                   textAlign: pw.TextAlign.center,
//                   style: pw.TextStyle(fontSize: 12, font: font),
//                 ),
//                 pw.SizedBox(height: 20),
//                 // Empty signature-like section (3 columns, 2 rows)
//                 pw.Table(
//                   border:
//                       pw.TableBorder.all(color: PdfColors.black, width: 0.5),
//                   columnWidths: {
//                     0: pw.FlexColumnWidth(3),
//                     1: pw.FlexColumnWidth(5),
//                   },
//                   children: [
//                     pw.TableRow(children: [
//                       pw.Container(height: 100), // First row, 3 empty cells
//                       pw.Container(height: 100),
//                       pw.Container(height: 100),
//                     ]),
//                     pw.TableRow(children: [
//                       pw.Container(height: 100), // Second row, 3 empty cells
//                       pw.Container(height: 100),
//                       pw.Container(height: 100),
//                     ]),
//                   ],
//                 ),
//                 pw.Container(
//                   color: PdfColors.grey300,
//                   padding: pw.EdgeInsets.all(16),
//                   width: 600,
//                   alignment: pw.Alignment.center,
//                   child: pw.Text(
//                     'COMPRODRONE\n'
//                     'C/ Afueras de Santa Ana 22\n'
//                     '37210 Vitigudino\n'
//                     '(Salamanca)',
//                     textAlign: pw.TextAlign.center,
//                     style: pw.TextStyle(
//                       fontSize: 12,
//                       font: font,
//                     ),
//                   ),
//                 ),
//                 pw.SizedBox(height: 50),
//                 pw.Image(pw.MemoryImage(image)),
//                 pw.SizedBox(height: 50),
//                 pw.Container(
//                   alignment: pw.Alignment.center,
//                   child: pw.Text(
//                     "VENTA NO. 1 Tipo de registro",
//                     style: pw.TextStyle(
//                       fontWeight: pw.FontWeight.bold,
//                       font: fontBold,
//                     ),
//                     textAlign: pw.TextAlign.center,
//                   ),
//                 ),
//                 pw.SizedBox(height: 20),
//                 pw.Text(
//                   textAlign: pw.TextAlign.center,
//                   style: pw.TextStyle(
//                     fontWeight: pw.FontWeight.bold,
//                     font: fontBold,
//                   ),
//                   "Este documento constituye una declaración responsable. Que todos los documentos presentados en este registro son verdaderos y su contenido coincide plenamente con los originales de los cuales son, asumiendo la responsabilidad por la veracidad de los mismos. Adjunto a este documento se encuentra una copia del DNI, NIF, NIE o pasaporte del comprador y vendedor. DECLARACIÓN RESPONSABLE",
//                 ),
//                 pw.SizedBox(height: 20),
//                 pw.Text(
//                   textAlign: pw.TextAlign.center,
//                   style: pw.TextStyle(
//                     fontSize: 12,
//                     font: font,
//                   ),
//                   "NORMATIVA DE REGISTRO DE AERONAVES"
//                   "Según BOE, Nº136, Miércoles, 5 de junio de 2024."
//                   "En su capítulo VI de la sección 1, en los artículos:"
//                   "Artículo 48. Registro de Operadores de UAS."
//                   "Artículo 49. Registro y actualización de datos registrados."
//                   "Artículo 50. Cancelación y suspensión del registro a solicitud de la parte."
//                   "Artículo 51. Cancelación del registro de oficio."
//                   "En su sección 2, artículo 52 Registro de aeronaves no tripuladas cuyo diseño está sujeto a certificación."
//                   "Sección 3, Registro de aeronaves no tripuladas del Ministerio del Interior y registro de comercialización y venta."
//                   "En los artículos:"
//                   "Artículo 53. Creación del Registro de aeronaves no tripuladas del Ministerio del Interior."
//                   "Artículo 54. Obligaciones de registro en comercialización, venta y adquisición."
//                   "Artículo 55. Obligaciones de comunicar la transmisión de aeronaves no tripuladas."
//                   "Artículo 56. Obligaciones de registro sobre la pérdida de la aeronave o su incapacidad para operar."
//                   "Artículo 57. Obligaciones adicionales del establecimiento."
//                   "Artículo 58. Tratamiento de datos personales.",
//                 ),
//                 pw.SizedBox(height: 150),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );

//     await Printing.sharePdf(
//         bytes: await pdfSecondPage.save(), filename: 'Sale_Registration.pdf');
//   }

//   pw.TableRow _buildTableRow(String field, String value,
//       {bool grey = false, required pw.Font font, required pw.Font fontBold}) {
//     return pw.TableRow(children: [
//       // First Column: Field Name (Grey Background)
//       pw.Container(
//         padding: pw.EdgeInsets.all(8),
//         color: grey ? PdfColors.grey300 : PdfColors.white,
//         child: pw.Text(
//           field,
//           style: pw.TextStyle(
//             fontSize: 12,
//             fontWeight: pw.FontWeight.bold,
//             font: fontBold, // Use fontBold for the field name
//           ),
//         ),
//       ),
//       // Second Column: Value
//       pw.Container(
//         padding: pw.EdgeInsets.all(8),
//         child: pw.Text(
//           value,
//           style: pw.TextStyle(fontSize: 12, font: font), // Use font for value
//         ),
//       ),
//     ]);
//   }

//   Future<void> _generateContractPDF() async {
//     // 1st page: Contract of Sale
// // Primera página: Contrato de Venta
//     final pdfFirstPage = pw.Document();
//     pdfFirstPage.addPage(
//       pw.MultiPage(
//         build: (pw.Context context) => [
//           pw.Padding(
//             padding: pw.EdgeInsets.all(20),
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Image(pw.MemoryImage(
//                   image,
//                 )),
//                 pw.SizedBox(height: 50),
//                 pw.Text(
//                   "CONTRATO DE VENTA DE DRONE DE SEGUNDA MANO",
//                   textAlign: pw.TextAlign.center,
//                   style: pw.TextStyle(
//                       fontSize: 20, fontWeight: pw.FontWeight.bold),
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Container(
//                   alignment: pw.Alignment.center,
//                   child: pw.Text(
//                     "En ${buyerCityController.text} a ${DateFormat('d de MMMM de yyyy').format(DateTime.now())}",
//                     textAlign: pw.TextAlign.center,
//                     style: pw.TextStyle(fontSize: 16),
//                   ),
//                 ),

//                 pw.SizedBox(height: 20),
//                 pw.Container(
//                   alignment: pw.Alignment.center,
//                   child: pw.Text(
//                     textAlign: pw.TextAlign.center,
//                     "REUNIDOS:",
//                     style: pw.TextStyle(
//                         fontSize: 18, fontWeight: pw.FontWeight.bold),
//                   ),
//                 ),

//                 pw.SizedBox(height: 10),
//                 pw.Text(
//                   textAlign: pw.TextAlign.left,
//                   "Por un lado, como EL VENDEDOR",
//                   style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                 ),
//                 pw.Container(
//                   color: PdfColors.yellow,
//                   child: pw.Text(
//                     "El Sr. ${sellerNameController.text}, mayor de edad, con D.N.I ${sellerDNIController.text} y con domicilio en ${sellerAddressController.text}, ${sellerCityController.text}.",
//                     textAlign: pw.TextAlign.left,
//                   ),
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Text(
//                   textAlign: pw.TextAlign.left,
//                   "Por otro lado, como EL COMPRADOR:",
//                   style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
//                 ),
//                 pw.Container(
//                   color: PdfColors.yellow,
//                   child: pw.Text(
//                     "El Sr. ${buyerNameController.text}, mayor de edad, con D.N.I ${buyerDNIController.text} y con domicilio en ${buyerAddressController.text}, ${buyerCityController.text}.",
//                     textAlign: pw.TextAlign.left,
//                   ),
//                 ),
//                 pw.SizedBox(height: 20),
//                 pw.Text(
//                   "Ambas partes contratantes reconocen tener capacidad legal para este acto, y actúan en su propio nombre y derecho.",
//                 ),
//                 pw.SizedBox(height: 20),
//                 pw.Text(
//                   "Exponen:",
//                   style: pw.TextStyle(
//                       fontSize: 16, fontWeight: pw.FontWeight.bold),
//                 ),
//                 pw.Bullet(
//                   text:
//                       "Que el vendedor ha anunciado su dron en la página web www.comprodrone.com propiedad del Sr. Eliseo Prieto Iglesias con D.N.I 70873396T, residente en Afueras de Santa Ana 22, Vitigudino Salamanca. En adelante, ComproDrone.",
//                 ),
//                 pw.Bullet(
//                   text:
//                       "El comprador ha adquirido el dron, especificado a continuación, a través de la plataforma ComproDrone.",
//                 ),
//                 pw.Bullet(
//                   text:
//                       "Que ambas partes han acordado formalizar un contrato de compraventa de un dron usado:",
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Text("MARCA: ${droneModelController.text}",
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                 pw.Text("MODELO: ${droneModelController.text}",
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                 pw.Text("NÚMERO DE SERIE: ${droneSerialController.text}",
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                 pw.Text("ESTADO: SEMINUEVO",
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                 pw.Text("POSIBLES DEFECTOS: NINGUNO",
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                 pw.SizedBox(height: 10),
//                 pw.Bullet(
//                   text:
//                       "Que el comprador declara haber sido informado del estado del dron, en su conjunto y en sus elementos mecánicos y componentes fundamentales, su antigüedad así como los extras que posee. También del estado de las baterías.",
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Bullet(
//                   text:
//                       "Se declara además que el comprador ha examinado personalmente y de forma directa el dron o a través de un tercero o por medios telemáticos y ha realizado las pruebas que libremente ha considerado pertinentes para verificar su correcto funcionamiento.",
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Bullet(
//                   text:
//                       "Que el dron objeto de esta compraventa no tiene defectos ocultos ni fallos conocidos y funciona correctamente. El vendedor debe informar al comprador de cualquier posible defecto, fallo o accidente que el dron haya sufrido durante su uso.",
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Bullet(
//                   text:
//                       "El comprador ha adquirido el dron a través de la página web www.comprodrone.com.",
//                 ),
//                 pw.SizedBox(height: 20),
//                 pw.Text(
//                   "ESTIPULACIONES:",
//                   style: pw.TextStyle(
//                       fontSize: 16, fontWeight: pw.FontWeight.bold),
//                 ),
//                 pw.SizedBox(height: 15),
//                 pw.Text(
//                     "PRIMERO: El vendedor vende al comprador el dron de su propiedad previamente especificado por el importe de ${dronePriceController.text} euros, excluyendo los impuestos correspondientes, si los hubiere (no todos los países requieren impuestos para la venta del dron), que serán a cargo del comprador, así como la comisión a ComproDrone.",
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                 pw.SizedBox(height: 10),
//                 pw.Text(
//                     "SEGUNDO: El vendedor declara que no existen cargas ni gravámenes, impuestos, pagos pendientes, deudas o sanciones pendientes sobre dicho dron en la fecha de la firma de este contrato, y se compromete en caso contrario a regularizar tal situación a su costa. Asimismo, el vendedor garantiza que el dron ha sido dado de baja en el registro de operadores profesionales o en cualquier otro registro asociado al vendedor.",
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                 pw.SizedBox(height: 10),
//                 pw.Text(
//                     "TERCERO: Por el presente acto, el dron se entrega al comprador. El comprador es responsable desde la fecha de este documento de cualquier asunto que pueda surgir del uso o posesión del mismo, incluyendo responsabilidades, sanciones, seguros de responsabilidad civil o cualquier otro documento exigido por la normativa del país para el uso de drones.",
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                 pw.SizedBox(height: 10),
//                 pw.Text(
//                     "CUARTO: El comprador declara conocer el estado actual del dron y exonera expresamente a ComproDrone y al vendedor de cualquier responsabilidad por defectos ocultos o posibles averías que el bien pudiera manifestar en el futuro, según lo determinado en el Código Civil del país, salvo aquellos ocultos que se originen en fraude o mala fe del vendedor y no hayan sido comunicados.",
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                 pw.SizedBox(height: 10),
//                 pw.Text(
//                   "El vendedor será responsable ante el comprador tanto de la posesión legal y pacífica del dron como de los defectos ocultos que pueda tener, durante el periodo establecido por la ley de acuerdo con el Código Civil del país.",
//                 ),
//                 pw.SizedBox(height: 5),
//                 pw.Text(
//                   "No habrá responsabilidad del vendedor por averías o deficiencias del dron, aparecidas después de su entrega, cuando estas circunstancias se produzcan o se motiven por un uso indebido; o por fuerza mayor, robo, negligencia, accidente o falta de mantenimiento aconsejado por el fabricante, así como los defectos existentes en el momento de la entrega del dron, siempre que fueran conocidos y consentidos por el comprador.",
//                 ),
//                 pw.SizedBox(height: 5),
//                 pw.Text(
//                   "La empresa ComproDrone no se responsabiliza de los daños sufridos por los artículos enviados, así como de la pérdida o retrasos en la logística.",
//                 ),
//                 pw.SizedBox(height: 5),
//                 pw.Text(
//                     "QUINTO: Para cualquier litigio que surja entre las partes en relación con la interpretación o cumplimiento de este contrato, se someten, con renuncia expresa a la jurisdicción que pudiera corresponderles, a los Juzgados y Tribunales de Salamanca.",
//                     style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                 pw.SizedBox(height: 20),
//                 pw.Text(
//                     "Y para que conste, firman este contrato de compraventa de 5 páginas, por duplicado, en la fecha y lugar indicados anteriormente."),
//                 pw.SizedBox(height: 150),
//                 pw.Text(
//                   "Firma del VENDEDOR Firma de ComproDrone Firma del COMPRADOR",
//                 ),

//                 // Quiero mostrar aquí una imagen de mis activos como assets/logo.png,
//                 pw.Image(pw.MemoryImage(
//                   image,
//                 )),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//     await Printing.sharePdf(
//         bytes: await pdfFirstPage.save(), filename: 'Contract_of_Sale.pdf');

//     // 2nd page: UAS Sale Registration and Declaration
//     // final pdfSecondPage = pw.Document();

//     // await Printing.sharePdf(
//     //     bytes: await pdfSecondPage.save(), filename: 'Sale_Registration.pdf');
//   }

//   // pw.TableRow _buildTableRow(String field, String value, {bool grey = false}) {
//   //   return pw.TableRow(children: [
//   //     // First Column: Field Name (Grey Background)
//   //     pw.Container(
//   //       padding: pw.EdgeInsets.all(8),
//   //       color: grey ? PdfColors.grey300 : PdfColors.white,
//   //       child: pw.Text(field,
//   //           style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
//   //     ),
//   //     // Second Column: Value
//   //     pw.Container(
//   //       padding: pw.EdgeInsets.all(8),
//   //       child: pw.Text(value, style: pw.TextStyle(fontSize: 12)),
//   //     ),
//   //   ]);
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           TextButton(
//             child: Icon(Icons.history),
//             onPressed: () {
//               Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) {
//                   return ContractHistoryScreen();
//                 },
//               ));
//             },
//           ),
//         ],
//         title: Text('Crear Contrato'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               Text('Detalles del Comprador',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               _buildTextField(
//                   buyerNameController, 'Nombre del Comprador', Icons.person),
//               _buildTextField(
//                   buyerDNIController, 'DNI del Comprador', Icons.credit_card),
//               _buildTextField(buyerAddressController, 'Dirección del Comprador',
//                   Icons.home),
//               _buildTextField(
//                   buyerPhoneController, 'Teléfono del Comprador', Icons.phone),
//               _buildTextField(
//                   buyerEmailController, 'Email del Comprador', Icons.email),
//               _buildTextField(buyerCityController, 'Ciudad del Comprador',
//                   Icons.location_city),
//               SizedBox(height: 20),
//               Text('Detalles del Vendedor',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               _buildTextField(
//                   sellerNameController, 'Nombre del Vendedor', Icons.person),
//               _buildTextField(
//                   sellerDNIController, 'DNI del Vendedor', Icons.credit_card),
//               _buildTextField(sellerAddressController, 'Dirección del Vendedor',
//                   Icons.home),
//               _buildTextField(
//                   sellerPhoneController, 'Teléfono del Vendedor', Icons.phone),
//               _buildTextField(
//                   sellerEmailController, 'Email del Vendedor', Icons.email),
//               _buildTextField(sellerCityController, 'Ciudad del Vendedor',
//                   Icons.location_city),
//               SizedBox(height: 20),

//               Text('Detalles del Dron',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               _buildTextField(
//                   droneModelController, 'Modelo del Dron', Icons.toys),
//               _buildTextField(droneSerialController, 'Número de Serie',
//                   Icons.confirmation_number),
//               _buildTextField(
//                   dronePriceController, 'Precio del Dron', Icons.attach_money),
//               SizedBox(height: 20),
//               Text("Para el Registro",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

//               // Add these additional fields to the form:
//               _buildTextField(uasSerialNumberController,
//                   'Número de Serie de UAS', Icons.confirmation_number),
//               GestureDetector(
//                 onTap: () async {
//                   DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2101),
//                   );
//                   if (pickedDate != null) {
//                     setState(() {
//                       registrationDateController.text =
//                           DateFormat('yyyy-MM-dd').format(pickedDate);
//                     });
//                   }
//                 },
//                 child: AbsorbPointer(
//                   child: _buildTextField(
//                     registrationDateController,
//                     'Fecha de Registro',
//                     Icons.date_range,
//                   ),
//                 ),
//               ),
//               _buildTextField(
//                   buyerNationalityController, 'Nacionalidad', Icons.flag),
//               _buildTextField(
//                   birthDateCodeController, 'Fecha de Nacimiento', Icons.person),
//               _buildTextField(
//                   buyerZipCodeController, 'Código Postal', Icons.location_on),
//               _buildTextField(buyerMunicipalityController, 'Municipio',
//                   Icons.location_city),
//               _buildTextField(buyerProvinceController, 'Provincia', Icons.map),
//               _buildTextField(buyerCountryController, 'País', Icons.map),
//               _buildTextField(uasModelController, 'Modelo de UAS', Icons.toys),
//               _buildTextField(
//                   observationsController, 'Observaciones', Icons.note),
//               Row(
//                 children: [
//                   Text('Método de Notificación:'),
//                   Expanded(
//                     child: RadioListTile<String>(
//                       title: const Text('Por Email'),
//                       value: 'email',
//                       groupValue: notificationMethodController.text,
//                       onChanged: (value) {
//                         setState(() {
//                           notificationMethodController.text = value!;
//                         });
//                       },
//                     ),
//                   ),
//                   Expanded(
//                     child: RadioListTile<String>(
//                       title: const Text('Por Papel'),
//                       value: 'paper',
//                       groupValue: notificationMethodController.text,
//                       onChanged: (value) {
//                         setState(() {
//                           notificationMethodController.text = value!;
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 40),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: _submitFormAndGenerateContractPDF,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Text('Generar Contrato PDF',
//                           style: TextStyle(fontSize: 18)),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: _submitFormAndGenerateRegistryPDF,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Text('Generar Registro PDF',
//                           style: TextStyle(fontSize: 18)),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _submitFormAndGenerateContractPDF() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       await _saveDataToFirebase(); // Save to Firebase
//       await _generateContractPDF(); // Generate and share Contract PDF
//     }
//   }

//   Future<void> _submitFormAndGenerateRegistryPDF() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       await _saveDataToFirebase(); // Save to Firebase
//       await _generateRegistryPDF(); // Generate and share Registry PDF
//     }
//   }

//   // Helper method for text fields
//   Widget _buildTextField(
//       TextEditingController controller, String label, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: TextFormField(
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: label,
//           prefixIcon: Icon(icon),
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
//         ),
//         validator: (value) => value!.isEmpty ? 'This field is required' : null,
//       ),
//     );
//   }
// }
