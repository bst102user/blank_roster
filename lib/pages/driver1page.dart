import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:demolight/app_utils/common_var.dart';
import 'package:demolight/pages/demo_vehicle.dart';
import 'package:demolight/pages/scan_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class Driver1Page extends StatefulWidget{
  Driver1PageState createState() => Driver1PageState();
}
class Driver1PageState extends State<Driver1Page>{
  TextEditingController fnameController = new TextEditingController();
  TextEditingController lnameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();
  File licImgFile = null;
  File insuImgFile = null;
  bool isLicImg;
  bool isInsuImg;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState.clear();
  }

  gggg(){
    String photoBase64Lic = "";
    String photoBase64Insu = "";
    if(licImgFile != null){
      List<int> imageBytes = licImgFile.readAsBytesSync();
      photoBase64Lic = base64Encode(imageBytes);
      print('photoBase64: '+photoBase64Lic);
    }
    if(insuImgFile != null){
      List<int> imageBytes = insuImgFile.readAsBytesSync();
      photoBase64Insu = base64Encode(imageBytes);
      print('photoBase64: '+photoBase64Insu);
    }
    _saveMySignature().then((signBase64){
      List<String> mData = [];
      mData.add(fnameController.text);
      mData.add(lnameController.text);
      mData.add(phoneController.text);
      mData.add(emailController.text);
      mData.add(photoBase64Lic);
      mData.add(photoBase64Insu);
      mData.add(signBase64);
      fnameController.text = '';
      lnameController.text = '';
      phoneController.text = '';
      emailController.text = '';
      _handleClearButtonPressed();

      Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) => DemoVehicle(mData)));
    });
  }

  Future<String> _saveMySignature() async {
    if (_formKey.currentState.validate()){
      final data = await signatureGlobalKey.currentState.toImage(pixelRatio: 1.0);
      ByteData bytes = await data.toByteData(format: ui.ImageByteFormat.png);
      Uint8List tempImg = await bytes.buffer.asUint8List();
      if (tempImg != null) {
        final tempDir = await getTemporaryDirectory();
        String timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
        final file = await new File('${tempDir.path}/image.jpg').create();
        List<int> imageBytes = file.readAsBytesSync();
        String photoBase64Sign = base64Encode(imageBytes);
        return photoBase64Sign;
      }
      else {
        return '';
      }
    }
  }

  Future imageSelector(BuildContext context, String pickerType) async {

    File mFile = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (mFile != null) {
      print("You selected  image : " + mFile.path);
      setState(() {
        if(isLicImg) {
          debugPrint("SELECTED IMAGE PICK   $mFile");
          licImgFile = mFile;
        }
        else if(isInsuImg){
          debugPrint("SELECTED IMAGE PICK   $mFile");
          insuImgFile = mFile;
        }
      });
    } else {
      print("You have not taken image");
    }
  }

  List<String> addDataForSend(){
    String photoBase64Lic = "";
    String photoBase64Insu = "";
    if(licImgFile != null){
      List<int> imageBytes = licImgFile.readAsBytesSync();
      photoBase64Lic = base64Encode(imageBytes);
      print('photoBase64: '+photoBase64Lic);
    }
    if(insuImgFile != null){
      List<int> imageBytes = insuImgFile.readAsBytesSync();
      photoBase64Insu = base64Encode(imageBytes);
      print('photoBase64: '+photoBase64Insu);
    }
    List<String> mData = [];
    _saveMySignature().then((signImgStr){
      mData.add(fnameController.text);
      mData.add(lnameController.text);
      mData.add(phoneController.text);
      mData.add(emailController.text);
      mData.add(photoBase64Lic);
      mData.add(photoBase64Insu);
      mData.add(signImgStr);
      fnameController.text = '';
      lnameController.text = '';
      phoneController.text = '';
      emailController.text = '';
      _handleClearButtonPressed();
    });
    return mData;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
          body: ListView(
            children: <Widget>[
              Container(
                height: 100,
                color: Colors.grey[200],
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InkWell(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(
                              builder: (BuildContext context) => ScanPage(0)));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                                'assets/images/scan.png',
                              height: 40.0,
                              width: 40.0,
                            ),
                            Text(
                                'SCAN',
                              style: TextStyle(
                                color: CommonVar.app_theme_color
                              ),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          isLicImg = true;
                          isInsuImg = false;
                          imageSelector(context, "camera");
                          // _settingModalBottomSheet(context);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/licence.png',
                              height: 40.0,
                              width: 40.0,
                            ),
                            Text(
                              'LICENSE',
                              style: TextStyle(
                                  color: CommonVar.app_theme_color
                              ),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          isLicImg = false;
                          isInsuImg = true;
                          imageSelector(context, "camera");
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/insurance.png',
                              height: 40.0,
                              width: 40.0,
                            ),
                            Text(
                              'INSURANCE',
                              style: TextStyle(
                                  color: CommonVar.app_theme_color
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (input) {
                          if(input.isEmpty){
                            return 'Provide first name';
                          }
                        },
                        controller: fnameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'First Name',
                          hintStyle: TextStyle(fontSize: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          filled: true,
                          contentPadding: EdgeInsets.all(10),
                          // fillColor: colorSearchBg,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:10.0),
                        child: TextFormField(
                          validator: (input) {
                            if(input.isEmpty){
                              return 'Provide last name';
                            }
                          },
                          controller: lnameController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Last Name',
                            hintStyle: TextStyle(fontSize: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.all(10),
                            // fillColor: colorSearchBg,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:10.0),
                        child: TextFormField(
                          validator: (input) {
                            if(input.isEmpty){
                              return 'Provide phone number';
                            }
                          },
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Phone #',
                            hintStyle: TextStyle(fontSize: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.all(10),
                            // fillColor: colorSearchBg,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:10.0),
                        child: TextFormField(
                          validator: (input) {
                            if(input.isEmpty){
                              return 'Provide an email';
                            }
                          },
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(fontSize: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            filled: true,
                            contentPadding: EdgeInsets.all(10),
                            // fillColor: colorSearchBg,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      Column(
                          children: [
                            Row(children: <Widget>[
                              FlatButton(
                                child: Text(
                                    'Signed below',
                                  style: TextStyle(
                                    color: CommonVar.app_theme_color
                                  ),
                                ),
                                onPressed: null,
                              ),
                              FlatButton(
                                child: Text('Clear'),
                                onPressed: _handleClearButtonPressed,
                              )
                            ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                    child: SfSignaturePad(
                                        key: signatureGlobalKey,
                                        backgroundColor: Colors.white,
                                        strokeColor: Colors.black,
                                        minimumStrokeWidth: 1.0,
                                        maximumStrokeWidth: 4.0),
                                    decoration:
                                    BoxDecoration(border: Border.all(color: Colors.white)))),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: InkWell(
                          onTap: (){
                            gggg();
                            // _saveMySignature();
                            // List<String> preDetailList = addDataForSend();
                            // Navigator.push(context, MaterialPageRoute(
                            //     builder: (BuildContext context) => DemoVehicle(preDetailList)));
                          },
                          child: Container(
                            height: 45.0,
                            decoration: new BoxDecoration(
                              color: CommonVar.app_theme_color,
                              //border: new Border.all(color: Colors.white, width: 2.0),
                              borderRadius: new BorderRadius.circular(10.0),
                            ),
                            child: Center(child: new Text('Vehicle', style: new TextStyle(fontSize: 18.0, color: Colors.white),),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }

}