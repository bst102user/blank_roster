import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:demolight/app_utils/common_var.dart';
import 'dart:io';

import 'camera.dart';

class ScanPage extends StatefulWidget{
  final String lastPage;
  ScanPage(this.lastPage);
  ScanPageState createState() => ScanPageState();
}

class ScanPageState extends State<ScanPage>{
  // Barcode result;
  // QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String messageText = 'Back of licence';

  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller.pauseCamera();
  //   }
  //   controller.resumeCamera();
  // }
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   String lSData = '@'
  //       ''
  //       'ANSI 6360050101DL00300203DLDAQ3265188'
  //       'DAALOTT,ERIC,B,'
  //       'DAG763 TEST STREET'
  //       'DAINEW YORK CITY'
  //       'DAJSC'
  //       'DAK10005'
  //       'DARD';
  //   // const str = "the quick brown fox jumps over the lazy dog";
  //   String start = "DAA";
  //   String end = "DAG";
  //
  //   int startIndex = lSData.indexOf(start);
  //   int endIndex = lSData.indexOf(end, startIndex + start.length);
  //
  //   print(lSData.substring(startIndex + start.length, endIndex));
  //   String fullname = lSData.substring(startIndex + start.length, endIndex);
  //   int idx = fullname.indexOf(",");
  //   List parts = [fullname.substring(0,idx).trim(), fullname.substring(idx+1).trim()];
  //   print(parts);
  //   Navigator.pop(context, parts);
  // }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: CommonVar.app_theme_color, //change your color here
        ),
        title: Text(
          'Scan Barcode',
          style: TextStyle(
              color: CommonVar.app_theme_color
          ),
        ),
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          // Expanded(flex: 2, child: _buildQrView(context)),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Card(
                  child: Container(
                    height: 150.0,
                    width: deviceWidth*0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          messageText,
                          style: TextStyle(
                            fontSize: 17.0
                          ),
                        ),
                        Image.asset(
                            'assets/images/bat_test.png',
                          height: 40.0,
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              color: CommonVar.app_theme_color
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(
                              builder: (BuildContext context) => Camera(widget.lastPage)));
                        },
                        child: Text(
                          'NEXT',
                          style: TextStyle(
                              color: CommonVar.app_theme_color
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Widget _buildQrView(BuildContext context) {
  //   // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
  //   var scanArea = (MediaQuery
  //       .of(context)
  //       .size
  //       .width < 400 ||
  //       MediaQuery
  //           .of(context)
  //           .size
  //           .height < 400)
  //       ? 150.0
  //       : 300.0;
  //   // To ensure the Scanner view is properly sizes after rotation
  //   // we need to listen for Flutter SizeChanged notification and update controller
  //   return QRView(
  //     key: qrKey,
  //     onQRViewCreated: _onQRViewCreated,
  //     overlay: QrScannerOverlayShape(
  //         borderColor: Colors.red,
  //         borderRadius: 10,
  //         borderLength: 30,
  //         borderWidth: 10,
  //         cutOutSize: scanArea),
  //   );
  // }

  bool isgoaway = true;

  // void _onQRViewCreated(QRViewController controller) {
  //   setState(() {
  //     this.controller = controller;
  //   });
  //   controller.scannedDataStream.listen((scanData) {
  //     setState(() {
  //       result = scanData;
  //       String lSData = scanData.code;
  //       String start = "DAA";
  //       String end = "DAG";
  //       int startIndex = lSData.indexOf(start);
  //       int endIndex = lSData.indexOf(end, startIndex + start.length);
  //       print(lSData.substring(startIndex + start.length, endIndex));
  //       String fullname = lSData.substring(startIndex + start.length, endIndex);
  //       int idx = fullname.indexOf(",");
  //       List parts = [fullname.substring(0,idx).trim(), fullname.substring(idx+1).trim()];
  //       print(parts);
  //       messageText = 'licence info not valid';
  //       print('result: '+result.toString());
  //       if(isgoaway){
  //         Navigator.pop(context, parts);
  //         isgoaway = false;
  //       }
  //       // Navigator.pop(context, scanData);
  //     });
  //   });
  // }

  @override
  void dispose() {
    // controller?.dispose();
    super.dispose();
  }
}