import 'package:flutter/services.dart';

class PrinterManager {
  static final _platform = MethodChannel(PrinterStrings.channel);
  static List<int> bytes = [];

  static printImage(String imgPath) async {
    print(imgPath);
    _platform.invokeMethod(
      PrinterStrings.printImage,
      {
        PrinterStrings.imgPathArg: imgPath,
      },
    );
  }

  static printTable(String? imagePath) async {
    print('Table Image $imagePath');
    _platform.invokeMethod(
      PrinterStrings.printImage,
      {
        PrinterStrings.imgPathArg: imagePath,
      },
    );
  }

  static printTHead() async {
    _platform.invokeMethod(
      PrinterStrings.printTHead,
    );
  }

  static printTRows() async {
    List results = [
      ['pc1', 200, 3, 600],
      ['pc2', 100, 3, 300],
      ['printer', 500, 1, 500],
    ];

    for (var element in results) {
      _platform.invokeMethod(PrinterStrings.printRow, {
        PrinterStrings.item: element[0].toString(),
        PrinterStrings.quantity: element[1].toString(),
        PrinterStrings.price: element[2].toString(),
        PrinterStrings.total: element[3].toString(),
      });
    }
  }

  static printTabl() async {
    printTHead();
    printTRows();
  }

  static printTest() async {
    _platform.invokeMethod(
      PrinterStrings.printFullInvoice,
      {
        // PrinterStrings.imgPathArg: bytes,
        "title": "كلاودسوفت5",
        "invoiceNumber": "20",
        "companyName": "Nile",
        "address": "Cairo",
        "barCode": "01013737709",
        "qrCode": "mahmoud97atef@gmail.com"
      },
    );
  }
}

class PrinterStrings {
  //channel name
  static String channel = "android.flutter/printer";

  //commands
  static String printImage = "printImage";
  static String printFullInvoice = "printFullInvoice";
  static String printTHead = "printTHead";
  static String printRow = "printRow";
  static String imgPathArg = "img_path";
  //row Elements
  static String item = "item";
  static String quantity = "quantity";
  static String price = "price";
  static String total = "total";
}
