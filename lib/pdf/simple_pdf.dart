// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

class PdfInvoiceSimpleAPI {
  static createAndPrint(
      //   {
      //   List<InvoicesModel>? invoice,
      //   InvoiceModel? invoiceModel,
      //   required int index,
      // }
      ) async {
    final doc = pw.Document();
    final font =
        await rootBundle.load("assets/font/Cairo-VariableFont_wght.ttf");
    var myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(font),
      bold: pw.Font.ttf(font),
      italic: pw.Font.ttf(font),
      boldItalic: pw.Font.ttf(font),
    );

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        textDirection: pw.TextDirection.rtl,
        theme: myTheme,

        // textDirection: pw.TextDirection.rtl,
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            buildTitle(),
            pw.SizedBox(height: 15.0),
            buildInvoiceInfo(
                // invoice: invoice!, invoiceModel: invoiceModel!, index: index
                ),
            pw.SizedBox(height: 15.0),
            buildLine(),
            buildInvoice(
                // invoiceModel: invoiceModel, invoice: invoice
                ),
            pw.SizedBox(height: 15.0),
            buildFooter(
                // invoice: invoice,
                // invoiceModel: invoiceModel,
                // index: index,
                ),
            buildLine(),
            pw.SizedBox(
              height: 15.0,
            ),
            buildQrCode(
                // invoiceModel,
                // invoice,
                // index,
                ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => doc.save(),
    );
  }

  static Future<File?> pdfFile(
      //   {
      //   List<InvoicesModel>? invoice,
      //   InvoiceModel? invoiceModel,
      //   required int index,
      // }
      ) async {
    final doc = pw.Document();
    final font =
        await rootBundle.load("assets/font/Cairo-VariableFont_wght.ttf");
    var myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(font),
      bold: pw.Font.ttf(font),
      italic: pw.Font.ttf(font),
      boldItalic: pw.Font.ttf(font),
    );

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        textDirection: pw.TextDirection.rtl,
        theme: myTheme,

        // textDirection: pw.TextDirection.rtl,
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            buildInvoice(
                // invoiceModel: invoiceModel, invoice: invoice
                ),
          ],
        ),
      ),
    );

    // await Printing.layoutPdf(
    //   onLayout: (PdfPageFormat format) async => doc.save(),
    // );

    await for (var page in Printing.raster(await doc.save(), dpi: 72)) {
      final image = await page.toPng(); // ...or page.toPng()
      final output = await getTemporaryDirectory();
      final File file = File('${output.path}/image.png');
      await file.writeAsBytes(image);
      print('ImageFile: $file');
      return file;
    }
    // final output = await getTemporaryDirectory();
    // final File file = File('${output.path}/example.pdf');
    // await file.writeAsBytes(await doc.save());
    // print('ImageFile: $file');
    // return file;
    return null;
  }

  static buildTitle() => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.SizedBox(
            width: double.infinity,
          ),
          pw.Text(
            'طباعه',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      );

  static buildInvoiceInfo(
          // {
          // required List<InvoicesModel> invoice,
          // required int index,

          //   required InvoiceModel invoiceModel,
          // }
          ) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Invoice Number: ${112}',
            // textDirection: pw.TextDirection.rtl,
          ),
          pw.SizedBox(height: 5.0),
          pw.Text(
              'Invoice Date: ${DateTime.now().toString().split('T').first.replaceAll('-', '/')}'),
          pw.SizedBox(height: 5.0),
          pw.Row(
            children: [
              pw.Text(
                'Company Name:',
              ),
              pw.Expanded(
                child: pw.Text(
                  ' cloudsoft5',
                  // textDirection: checkChar(invoiceModel.company!.name)
                  //     ? pw.TextDirection.rtl
                  //     : pw.TextDirection.ltr,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 5.0),
          pw.Row(
            children: [
              pw.Text(
                'Address:',
              ),
              pw.Expanded(
                child: pw.Text(
                  ' Maadi',
                  // textDirection: checkChar(invoiceModel.customer!.address)
                  //     ? pw.TextDirection.rtl
                  //     : pw.TextDirection.ltr,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 5.0),
          pw.Text('VAT Number: '),
        ],
      );

  static buildLine() => pw.Container(
        width: double.infinity,
        height: 2.0,
        decoration: const pw.BoxDecoration(
          color: PdfColors.black,
        ),
      );

  static buildFooter(
      //   {
      //   required List<InvoicesModel> invoice,
      //   required InvoiceModel invoiceModel,
      //   required int index,
      // }
      ) {
    double total = 200;
    // for (var element in invoiceModel.result!) {
    //   total += element.unitPrice! * element.quantity!;
    // }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          height: 5.0,
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(' ${'Total'.toUpperCase()} '),
            pw.Text('${total.toStringAsFixed(2)} EGP'),
          ],
        ),
        pw.SizedBox(
          height: 5.0,
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Discount'.toUpperCase()),
            pw.Text('${50.toStringAsFixed(2)} EGP'),
          ],
        ),
        pw.SizedBox(
          height: 5.0,
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('vat'.toUpperCase()),
            pw.Text('${10.toStringAsFixed(2)} EGP'),
          ],
        ),
        pw.SizedBox(
          height: 5.0,
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('subtotal'.toUpperCase()),
            pw.Text('${140.toStringAsFixed(2)} EGP'),
          ],
        ),
        pw.SizedBox(
          height: 5.0,
        ),
      ],
    );
  }

  static buildQrCode(
      // InvoiceModel invoiceModel, List<InvoicesModel> invoice, index
      ) {
    // String qrData =
    // 'Supplier: ${invoiceModel.company!.nameEN}\nDate: ${invoice[index].invoiceDate!.split('T')[0]}\nTime: ${invoice[index].invoiceDate!.split('T')[1]}\nVAT Number:${invoice[index].vATRegistrationNumber}\nTotal VAT:${invoice[index].taxValue} ${invoice[index].currency}\nTotal:${invoice[index].invoiceTotal} ${invoice[index].currency}';

    String qrData = 'CloudSoft5';
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      mainAxisSize: pw.MainAxisSize.max,
      children: [
        pw.Container(
          width: double.infinity,
          height: 5.0 * PdfPageFormat.cm,
          child: pw.BarcodeWidget(
            data: qrData,
            barcode: pw.Barcode.qrCode(),
          ),
        ),
      ],
    );
  }

  static List results = [
    ['pc1', 200, 3, 600],
    ['pc2', 100, 3, 300],
    ['printer', 500, 1, 500],
  ];

  static buildInvoice(
      //   {
      //   required InvoiceModel invoiceModel,
      //   required List<InvoicesModel> invoice,
      // }
      ) {
    final headers = ['ITEM', 'PRICE', 'QTY', 'TOTAL'];
    final data = results.map((item) {
      final total = item[3];
      return [item[0], item[1], item[2], '$total'];
      // final total = item.total;
      // return [item.itemName, item.total, item.quantity, '$total'];
    }).toList();

    return pw.Table.fromTextArray(
        data: data,
        headers: headers,
        headerStyle: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
        ),
        columnWidths: {
          0: const pw.IntrinsicColumnWidth(flex: 3),
          1: const pw.IntrinsicColumnWidth(flex: 2),
          2: const pw.IntrinsicColumnWidth(flex: 2),
          3: const pw.IntrinsicColumnWidth(flex: 2.1),
        },
        headerDecoration: const pw.BoxDecoration(
          color: PdfColors.grey300,
        ),
        cellHeight: 30.0,
        cellStyle: const pw.TextStyle(fontSize: 10.0),
        cellAlignments: {
          0: pw.Alignment.center,
          1: pw.Alignment.center,
          2: pw.Alignment.center,
          3: pw.Alignment.center,
        });
  }

  static bool checkChar(String? st) {
    // RegExp exp = RegExp(
    //     r'^[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa]+[\u0600-\u065F\u066A-\u06EF\u06FA-\u06FFa_-]" "{0,10}$');
    RegExp exp = RegExp(
        r'^[\u0621-\u064A\u0660-\u0669{1-9}\-\[(?:(.+?):"(.+?)"\s*)+\] ]+$');

    if (st == null) {
      return false;
    }
    if (st.contains(exp)) {
      log('Arabic Char');

      return true;
    }

    log('Not Arabic Char');

    return false;
  }

  Future<List<int>> testTicket() async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    bytes += generator.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    // bytes += generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
    //     styles: PosStyles(codeTable: PosCodeTable.westEur));
    // bytes += generator.text('Special 2: blåbærgrød',
    //     styles: PosStyles(codeTable: PosCodeTable.westEur));

    bytes += generator.text('Bold text', styles: const PosStyles(bold: true));
    bytes +=
        generator.text('Reverse text', styles: const PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: const PosStyles(underline: true), linesAfter: 1);
    bytes += generator.text('Align left',
        styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',
        styles: const PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.text('Text size 200%',
        styles: const PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }
}
