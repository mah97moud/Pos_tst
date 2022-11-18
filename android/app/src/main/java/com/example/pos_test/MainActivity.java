package com.example.pos_test;


import android.app.AlertDialog;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.ThumbnailUtils;
import android.os.Handler;
import android.os.Message;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.telpo.tps550.api.InternalErrorException;
import com.telpo.tps550.api.TelpoException;
import com.telpo.tps550.api.printer.UsbThermalPrinter;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = PrinterStrings.channel;
    UsbThermalPrinter usbThermalPrinter = new UsbThermalPrinter(MainActivity.this);

    private final int NOPAPER = 3;
    private final int LOWBATTERY = 4;
    private final int OVERHEAT = 12;

    MyHandler handler;
    private String Result;
    private final boolean LowBattery = false;



    private  class MyHandler extends Handler {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case NOPAPER:
                    AlertDialog.Builder dlg = new AlertDialog.Builder(MainActivity.this);
                    dlg.setTitle("No paper");
                    dlg.setMessage("No paper, please put paper in and retry");
                    dlg.setCancelable(false);
                    dlg.setPositiveButton("Sure", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                        }
                    });
                    dlg.show();
                    break;
                case LOWBATTERY:
                    AlertDialog.Builder alertDialog = new AlertDialog.Builder(MainActivity.this);
                    alertDialog.setTitle("No paper");
                    alertDialog.setMessage("Low battery, please connect the charger!");
                    alertDialog.setPositiveButton("Confirm", (dialogInterface, i) -> {
                    });
                    alertDialog.show();
                    break;

                case OVERHEAT:
                    AlertDialog.Builder overHeatDialog = new AlertDialog.Builder(MainActivity.this);
                    overHeatDialog.setTitle("Result");
                    overHeatDialog.setMessage("over temp !");
                    overHeatDialog.setPositiveButton("Confirm", (dialogInterface, i) -> {
                    });
                    overHeatDialog.show();
                    break;
                default:
                    Toast.makeText(MainActivity.this, "Print Error!", Toast.LENGTH_LONG).show();
                    break;
            }
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // This method is invoked on the main thread.
                            if(call.method.equals(PrinterStrings.printFullInvoice)){
                                result.success("Success");
                                try {
                                    usbThermalPrinter.start(1);
                                } catch (TelpoException e) {
                                    e.printStackTrace();
                                }
                                String title = call.argument(PrinterStrings.title);
                                String invoiceNumber = call.argument(PrinterStrings.invoiceNumber);
                                String date = "";
                                String companyName = call.argument(PrinterStrings.companyName);
                                String address = call.argument(PrinterStrings.address);
                                String space = "  ";
                                String barcode = call.argument(PrinterStrings.barCode);
                                String qrcode = call.argument(PrinterStrings.qrCode);
                                final List list = call.argument(PrinterStrings.list);
                                assert list != null;
//                                for (int row = 0; row < list.size(); row++) {
//                                    List f =(List) list.get(row);
//                                    System.out.println(f.get(0));
//                                    System.out.println(f.get(1));
//                                    System.out.println(f.get(2));
//                                    System.out.println(f.get(3));
//                                }
                                new Thread(() -> {
                                    if (LowBattery) {
                                        handler.sendMessage(handler.obtainMessage(LOWBATTERY, 1, 0, null));
                                    } else {
                                        try {
                                            usbThermalPrinter.reset();
                                            usbThermalPrinter.setMonoSpace(true);
                                            usbThermalPrinter.setGray(7);
                                            usbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);
//                                            Bitmap bitmap1= BitmapFactory.decodeResource(MainActivity.this.getResources(),R.mipmap.telpoe);
//                                            Bitmap bitmap2 = ThumbnailUtils.extractThumbnail(bitmap1, 244, 116);
//                                            usbThermalPrinter.printLogo(bitmap2,true);
                                            usbThermalPrinter.setTextSize(30);
                                            usbThermalPrinter.addString(title +"\n");
                                            usbThermalPrinter.setTextSize(24);
                                            usbThermalPrinter.addString( invoiceNumber);
                                            usbThermalPrinter.addString( companyName);
                                            usbThermalPrinter.addString(address);
                                            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                            Date curDate = new Date(System.currentTimeMillis());//获取当前时间
                                            String str = formatter.format(curDate);
                                            usbThermalPrinter.addString(str);
                                            int i1 = usbThermalPrinter.measureText(" ");
                                            int SpaceNumber=((384)/i1);
                                            StringBuilder spaceString = new StringBuilder();
                                            for (int j=0;j<SpaceNumber;j++){
                                                spaceString.append("_");
                                            }
                                            usbThermalPrinter.addString(String.valueOf(spaceString));
                                            usbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);
                                            tableHead();
                                            usbThermalPrinter.walkPaper(10);
                                            usbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);
                                            for (int row = 0; row < list.size(); row++) {
                                                List f =(List) list.get(row);
                                                int i = usbThermalPrinter.measureText((String) f.get(0) + f.get(1) + f.get(2) + f.get(3));

                                                int SpaceInRow = ((384 - i) / i1) / 4;
                                                StringBuilder spaceInRow = new StringBuilder();
                                                for (int j = 0; j < SpaceInRow; j++) {
                                                    spaceInRow.append(" ");
                                                }

                                                usbThermalPrinter.addString((String)f.get(0) + spaceInRow + f.get(1) + spaceInRow + f.get(2) + spaceInRow + f.get(3));

                                                usbThermalPrinter.addString(String.valueOf(spaceInRow));
                                            }
                                            usbThermalPrinter.addString(String.valueOf(spaceString));
                                            qrCode(qrcode);
                                            usbThermalPrinter.printString();
                                            usbThermalPrinter.walkPaper(10);
                                        } catch (TelpoException e) {
                                            e.printStackTrace();
                                            Result = e.toString();
                                            if (Result.equals("com.telpo.tps550.api.printer.NoPaperException")) {
                                                handler.sendMessage(handler.obtainMessage(NOPAPER, 1, 0, null));
                                            } else if (Result.equals("com.telpo.tps550.api.printer.OverHeatException")) {
                                                handler.sendMessage(handler.obtainMessage(OVERHEAT, 1, 0, null));
                                            }
                                        }
                                    }
                                }).start();
                            }else {
                                result.notImplemented();
                            }
                        }
                );
    }



    public  void printImg(String path) {

        new Thread(() -> {
            if (LowBattery) {
                handler.sendMessage(handler.obtainMessage(LOWBATTERY, 1, 0, null));
            } else {
                try {
                    usbThermalPrinter.reset();
                    usbThermalPrinter.setGray(7);
                    usbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);

//                  Bitmap logo = BitmapFactory.decodeResource(MainActivity.this.getResources(),R.mipmap.ic_launcher);
                    Bitmap logo= BitmapFactory.decodeFile(path);
                    int height = logo.getHeight();
                    int width = logo.getWidth();
                    usbThermalPrinter.printLogo(ThumbnailUtils.extractThumbnail(logo, width, height),false);
                    usbThermalPrinter.walkPaper(10);
                } catch (TelpoException e) {
                    e.printStackTrace();
                    Result = e.toString();
                    if (Result.equals("com.telpo.tps550.api.printer.NoPaperException")) {
                        handler.sendMessage(handler.obtainMessage(NOPAPER, 1, 0, null));
                    } else if (Result.equals("com.telpo.tps550.api.printer.OverHeatException")) {
                        handler.sendMessage(handler.obtainMessage(OVERHEAT, 1, 0, null));
                    }
                }
            }
        }).start();
    }

    public  void printInvoice(String title, String invoiceNumber,
                              String companyName, String address, String qrcode,List listOfItem){
        new Thread(() -> {
            if (LowBattery) {
                handler.sendMessage(handler.obtainMessage(LOWBATTERY, 1, 0, null));
            } else {
                try {
                    usbThermalPrinter.reset();
                    usbThermalPrinter.setMonoSpace(true);
                    usbThermalPrinter.setGray(7);
                    usbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);
//                                            Bitmap bitmap1= BitmapFactory.decodeResource(MainActivity.this.getResources(),R.mipmap.telpoe);
//                                            Bitmap bitmap2 = ThumbnailUtils.extractThumbnail(bitmap1, 244, 116);
//                                            usbThermalPrinter.printLogo(bitmap2,true);
                    usbThermalPrinter.setTextSize(30);
                    usbThermalPrinter.addString(title +"\n");
                    usbThermalPrinter.setTextSize(24);
                    usbThermalPrinter.addString( invoiceNumber);
                    usbThermalPrinter.addString( companyName);
                    usbThermalPrinter.addString(address);
                    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    Date curDate = new Date(System.currentTimeMillis());//获取当前时间
                    String str = formatter.format(curDate);
                    usbThermalPrinter.addString(str);
                    int i1 = usbThermalPrinter.measureText(" ");
                    int SpaceNumber=((384)/i1);
                    StringBuilder spaceString = new StringBuilder();
                    for (int j=0;j<SpaceNumber;j++){
                        spaceString.append("_");
                    }
                    usbThermalPrinter.addString(String.valueOf(spaceString));
                    usbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_LEFT);
                    tableHead();
                    usbThermalPrinter.walkPaper(10);
                    usbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);
                    for (Object list : listOfItem) {
                        System.out.println(list);
                       final List l =  (List) list;
                        this.printRow((String) l.get(0),(String) l.get(1),(String) l.get(2),(String) l.get(3));
                        usbThermalPrinter.addString(String.valueOf(spaceString));
                        System.out.println(l.get(0).getClass().getName());
                    }
//                    iterateUsingForEach(listOfItem,usbThermalPrinter,spaceString);
                    usbThermalPrinter.addString(String.valueOf(spaceString));
                    qrCode(qrcode);
                    usbThermalPrinter.printString();
                    usbThermalPrinter.walkPaper(10);
                } catch (TelpoException e) {
                    e.printStackTrace();
                    Result = e.toString();
                    if (Result.equals("com.telpo.tps550.api.printer.NoPaperException")) {
                        handler.sendMessage(handler.obtainMessage(NOPAPER, 1, 0, null));
                    } else if (Result.equals("com.telpo.tps550.api.printer.OverHeatException")) {
                        handler.sendMessage(handler.obtainMessage(OVERHEAT, 1, 0, null));
                    }
                }
            }
        }).start();
    }


    public void barCode(String barCode) {
        new Thread(() -> {
            if (LowBattery) {
                handler.sendMessage(handler.obtainMessage(LOWBATTERY, 1, 0, null));
            } else {

                try {
                    Bitmap bitmap = CreateCode(barCode, BarcodeFormat.CODE_128, 320, 120);
                    usbThermalPrinter.reset();
                    usbThermalPrinter.setMonoSpace(true);
                    usbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);
                    usbThermalPrinter.printLogo(bitmap,false);
                    usbThermalPrinter.walkPaper(10);
                } catch (TelpoException e) {
                    e.printStackTrace();
                    Result = e.toString();
                    if (Result.equals("com.telpo.tps550.api.printer.NoPaperException")) {
                        handler.sendMessage(handler.obtainMessage(NOPAPER, 1, 0, null));
                    } else if (Result.equals("com.telpo.tps550.api.printer.OverHeatException")) {
                        handler.sendMessage(handler.obtainMessage(OVERHEAT, 1, 0, null));
                    }
                }
            }
        }).start();
    }

    public void qrCode(String qrCode) {
        new Thread(() -> {
            if (LowBattery) {
                handler.sendMessage(handler.obtainMessage(LOWBATTERY, 1, 0, null));
            } else {

                try {
                    Bitmap bitmap = CreateCode(qrCode, BarcodeFormat.QR_CODE, 400, 400);
                    usbThermalPrinter.reset();
                    usbThermalPrinter.setGray(7);
                    usbThermalPrinter.setAlgin(UsbThermalPrinter.ALGIN_MIDDLE);
                    usbThermalPrinter.printLogo(bitmap,false);
                    usbThermalPrinter.walkPaper(10);
                } catch (TelpoException e) {
                    e.printStackTrace();
                    Result = e.toString();
                    if (Result.equals("com.telpo.tps550.api.printer.NoPaperException")) {
                        handler.sendMessage(handler.obtainMessage(NOPAPER, 1, 0, null));
                    } else if (Result.equals("com.telpo.tps550.api.printer.OverHeatException")) {
                        handler.sendMessage(handler.obtainMessage(OVERHEAT, 1, 0, null));
                    }
                }
            }
        }).start();
    }


    private static Bitmap CreateCode(String str, BarcodeFormat type, int bmpWidth, int bmpHeight) throws InternalErrorException {
        BitMatrix matrix = null;

        try {
            matrix = (new MultiFormatWriter()).encode(str, type, bmpWidth, bmpHeight);
        } catch (WriterException var10) {
            var10.printStackTrace();
            throw new InternalErrorException("Failed to encode bitmap");
        }

        int width = matrix.getWidth();
        int height = matrix.getHeight();
        int[] pixels = new int[width * height];

        for(int y = 0; y < height; ++y) {
            for(int x = 0; x < width; ++x) {
                if (matrix.get(x, y)) {
                    pixels[y * width + x] = -16777216;
                } else {
                    pixels[y * width + x] = -1;
                }
            }
        }

        Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        bitmap.setPixels(pixels, 0, width, 0, 0, width, height);
        return bitmap;
    }

    public void printRow(String item,String quantity , String price, String total) {
        new Thread(() -> {
            if (LowBattery) {
                handler.sendMessage(handler.obtainMessage(LOWBATTERY, 1, 0, null));
            } else {
                try {
                    int i = usbThermalPrinter.measureText(item + quantity + price + total);
                    int i1 = usbThermalPrinter.measureText(" ");
                    int SpaceNumber=((384-i)/i1)/4;
                    StringBuilder spaceString = new StringBuilder();
                    for (int j=0;j<SpaceNumber;j++){
                        spaceString.append(" ");
                    }

                    usbThermalPrinter.addString(item+spaceString+quantity+spaceString+price+spaceString+total);

                } catch (TelpoException e) {
                    e.printStackTrace();
                    Result = e.toString();
                    if (Result.equals("com.telpo.tps550.api.printer.NoPaperException")) {
                        handler.sendMessage(handler.obtainMessage(NOPAPER, 1, 0, null));
                    } else if (Result.equals("com.telpo.tps550.api.printer.OverHeatException")) {
                        handler.sendMessage(handler.obtainMessage(OVERHEAT, 1, 0, null));
                    }
                }
            }
        }).start();
    }

    public void tableHead() {

        new Thread(() -> {
            if (LowBattery) {
                handler.sendMessage(handler.obtainMessage(LOWBATTERY, 1, 0, null));
            } else {
                try {
                    int i = usbThermalPrinter.measureText("Item     " + "Quantity" + "Price" + "Total");
                    int i1 = usbThermalPrinter.measureText(" ");
                    int SpaceNumber=((384-i)/i1)/4;
                    StringBuilder spaceString = new StringBuilder();
                    for (int j=0;j<SpaceNumber;j++){
                        spaceString.append(" ");
                    }

                    usbThermalPrinter.addString("Item"+spaceString+"Quantity"+spaceString+"Price"+spaceString+"Total");
                } catch (TelpoException e) {
                    e.printStackTrace();
                    Result = e.toString();
                    if (Result.equals("com.telpo.tps550.api.printer.NoPaperException")) {
                        handler.sendMessage(handler.obtainMessage(NOPAPER, 1, 0, null));
                    } else if (Result.equals("com.telpo.tps550.api.printer.OverHeatException")) {
                        handler.sendMessage(handler.obtainMessage(OVERHEAT, 1, 0, null));
                    }
                }
            }
        }).start();



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

