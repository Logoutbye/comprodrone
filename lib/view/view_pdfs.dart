import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdfs extends StatefulWidget {
  ViewPdfs({super.key, required this.src});
  Uint8List src;
  @override
  State<ViewPdfs> createState() => _ViewPdfsState();
}

class _ViewPdfsState extends State<ViewPdfs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.memory(widget.src),
    );
  }
}
