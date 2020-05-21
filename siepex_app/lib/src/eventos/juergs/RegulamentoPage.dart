import 'package:flutter/material.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class RegulamentoPage extends StatefulWidget {
  @override
  _RegulamentoPageState createState() => _RegulamentoPageState();
}

class _RegulamentoPageState extends State<RegulamentoPage> {
  String pdfasset = "assets/img/regulamento.pdf";
  PDFDocument _doc;
  bool _loading;

  void initState(){
    super.initState();  
    _initPdf();
  }

  _initPdf() async {
    setState((){
      _loading = true;
    });
    final doc = await PDFDocument.fromAsset(pdfasset);
    setState(() {
      _doc = doc;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Regulamento'),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xffA1D2E7), Color(0xffB5FDF8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: _loading ? Center(child: CircularProgressIndicator(),) : 
        PDFViewer(document: _doc,
          showPicker: false,
        ),
      ),
    );
  }

}
