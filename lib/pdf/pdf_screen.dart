import 'package:flutter/material.dart';
import 'package:pos_test/pdf/simple_pdf.dart';

class PdfScreen extends StatefulWidget {
  const PdfScreen({super.key});

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printing'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(
            width: double.infinity,
          ),
          ElevatedButton(
            onPressed: PdfInvoiceSimpleAPI.createAndPrint,
            child: Text('Create & Print'),
          ),
          // const SizedBox(height: 20),
          // ElevatedButton(
          //   onPressed: () {},
          //   child: Text('Create & Print'),
          // ),
          // const SizedBox(height: 20),
          // ElevatedButton(
          //   onPressed: () {},
          //   child: Text('Create & Print'),
          // ),
          // const SizedBox(height: 20),
        ],
      ),
    );
  }
}
