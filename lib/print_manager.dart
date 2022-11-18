import 'package:flutter/services.dart';

class PrinterManager {
  static final _platform = MethodChannel(PrinterStrings.channel);
  static List<int> bytes = [];

  // static printImage(String imgPath) async {
  //   print(imgPath);
  //   _platform.invokeMethod(
  //     PrinterStrings.printImage,
  //     {
  //       PrinterStrings.imgPathArg: imgPath,
  //     },
  //   );
  // }

  // static printTable(String? imagePath) async {
  //   print('Table Image $imagePath');
  //   _platform.invokeMethod(
  //     PrinterStrings.printImage,
  //     {
  //       PrinterStrings.imgPathArg: imagePath,
  //     },
  //   );
  // }

  // static printTHead() async {
  //   _platform.invokeMethod(
  //     PrinterStrings.printTHead,
  //   );
  // }

  static List results = [
    ['pc1', 200, 3, 600],
    ['pc2', 100, 3, 300],
    ['printer', 500, 1, 500],
  ];

  static printTest() async {
    await _platform.invokeMethod(
      PrinterStrings.printFullInvoice,
      {
        // PrinterStrings.imgPathArg: bytes,
        PrinterStrings.title: "كلاودسوفت5",
        PrinterStrings.invoiceNumber: "20",
        PrinterStrings.companyName: "Nile",
        PrinterStrings.address: "Cairo",
        PrinterStrings.barCode: "01013737709",
        PrinterStrings.qrCode: "mahmoud97atef@gmail.com",
        PrinterStrings.list: results,
      },
    );
  }
}

class PrinterStrings {
  //channel name
  static String channel = "android.flutter/printer";

  //commands
//    static String printImage = "printImage";
  static String printFullInvoice = "printFullInvoice";
  //row Elements
  static String list = "list";

  //header elements
  static String title = "title";
  static String invoiceNumber = "invoiceNumber";
  static String companyName = "companyName";
  static String address = "address";
  static String barCode = "barCode";
  static String qrCode = "qrCode";
}
