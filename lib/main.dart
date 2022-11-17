import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_test/print_manager.dart';
import 'package:path_provider/path_provider.dart';

import 'pdf/simple_pdf.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const Pos(),
  );
}

class Pos extends StatelessWidget {
  const Pos({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Title',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? imgFile;
  Uint8List? imgbuffer;
  File? pdfFile;
  @override
  void initState() {
    super.initState();
    _initImg();
  }

  _initImg() async {
    try {
      ByteData byteData = await rootBundle.load("assets/rabbit_black.jpg");
      Uint8List buffer = byteData.buffer.asUint8List();
      imgbuffer = buffer;
      String path = (await getTemporaryDirectory()).path;
      imgFile = File("$path/img.png");
      imgFile?.writeAsBytes(buffer);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                PrinterManager.printTest();
              },
              child: const Icon(Icons.print_rounded),
            ),
            // ElevatedButton(
            //   onPressed: () async {
            //     imgbuffer = await PdfInvoiceSimpleAPI.pdfFile();
            //     // PdfInvoiceSimpleAPI.createAndPrint();
            //     print(pdfFile);
            //   },
            //   child: const Text('Create Pdf'),
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     PrinterManager.printTest();
            //   },
            //   child: const Text("test"),
            // ),
            // ElevatedButton(
            //   onPressed: () async {
            //     // imgFile = await PdfInvoiceSimpleAPI.pdfFile();
            //     _initImg();
            //     setState(() {});
            //   },
            //   child: const Text("Show Image"),
            // ),
            // if (imgFile != null) Image.file(imgFile!),
            // ElevatedButton(
            //   onPressed: () async {
            //     PrinterManager.printTable(imgFile?.path);
            //   },
            //   child: const Text("print table image"),
            // ),
            // ElevatedButton(
            //   onPressed: () async {
            //     PrinterManager.printTHead();
            //   },
            //   child: const Text("print table head "),
            // ),
            // ElevatedButton(
            //   onPressed: () async {
            //     PrinterManager.printTRows();
            //   },
            //   child: const Text("print table Rows"),
            // ),
            // ElevatedButton(
            //   onPressed: () async {
            //     PrinterManager.printTabl();
            //   },
            //   child: const Text("print table"),
            // ),
          ],
        ),
      ),
    );
  }
}
