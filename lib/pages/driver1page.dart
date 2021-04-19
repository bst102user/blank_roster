import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:demolight/app_utils/common_var.dart';
import 'package:demolight/app_utils/global_state.dart';
import 'package:demolight/pages/camera.dart';
import 'package:demolight/pages/demo_vehicle.dart';
import 'package:demolight/pages/scan_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import 'CameraIns.dart';

class Driver1Page extends StatefulWidget{
  Driver1PageState createState() => Driver1PageState();
}
class Driver1PageState extends State<Driver1Page> with
    AutomaticKeepAliveClientMixin<Driver1Page>{
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
  SharedPreferences preferences;

  @override
  bool get wantKeepAlive => true;

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState.clear();
  }

  getPref()async{
    preferences = await SharedPreferences.getInstance();
  }

  @override
  initState(){
    super.initState();
    getPref();
    SystemChannels.lifecycle.setMessageHandler((msg){
      debugPrint('SystemChannels> $msg');
    });
  }


  Map getFullData(){
    String photoBase64Lic = "";
    String photoBase64Insu = "";
    if(licImgFile != null){
      List<int> imageBytes = licImgFile.readAsBytesSync();
      photoBase64Lic = base64Encode(imageBytes);
      preferences.setString('lic1_pref', photoBase64Lic);
    }
    if(insuImgFile != null){
      List<int> imageBytes = insuImgFile.readAsBytesSync();
      photoBase64Insu = base64Encode(imageBytes);
      preferences.setString('ins1_pref', photoBase64Lic);
    }

    Map map = {
      'd1_fname':fnameController.text==null?'':fnameController.text,
      'd1_lname':lnameController.text==null?'':lnameController.text,
      'd1_mobile':phoneController.text==null?'':phoneController.text,
      'd1_email':emailController.text==null?'':emailController.text,
      'd1_lic_img':photoBase64Lic,
      'd1_insu_img':photoBase64Insu,
      'd1_sign':'',
    };
    saveDriverName();
    return map;
  }

  saveDriverName()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(CommonVar.DRIVER1_FULL_NAME, fnameController.text + ' ' + lnameController.text);
  }

  Future<File> getSignFile() async {
    final dataTest = await signatureGlobalKey.currentState.toImage(pixelRatio: 1.0);
    ByteData data = await dataTest.toByteData(format: ui.ImageByteFormat.png);
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath = tempPath + '/file_01.tmp'; // file_01.tmp is dump file, can be anything
    return new File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  _saveMySignature()async{
    try {
      File file = await getSignFile();
      List<int> imageBytes = file.readAsBytesSync();
      String photoBase64Sign = base64Encode(imageBytes);
      preferences.setString('sign1_pref', photoBase64Sign);
      print('photoBase64Sign'+photoBase64Sign);
    } catch(e) {
      // catch errors here
    }
  }

  Future imageSelector(BuildContext context, String pickerType) async {
    File mFile = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (mFile != null) {
      print("You selected  image : " + mFile.path);
      setState(() {
        if(isLicImg) {
          List<int> imageBytes = mFile.readAsBytesSync();
          String photoBase64Lic = base64Encode(imageBytes);
          preferences.setString('lic1_pref', photoBase64Lic);
        }
        else if(isInsuImg){
          List<int> imageBytes = mFile.readAsBytesSync();
          String photoBase64Lic = base64Encode(imageBytes);
          preferences.setString('ins1_pref', photoBase64Lic);
        }
      });
    } else {
      print("You have not taken image");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            height: 80,
            color: Colors.grey[200],
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) => ScanPage('driver1')));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/scan.png',
                          height: 60.0,
                          width: 60.0,
                        ),
                        Text(
                          'SCAN',
                          style: TextStyle(
                              color: CommonVar.app_theme_color,
                              fontSize: 10.0
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      isLicImg = true;
                      isInsuImg = false;
                      // imageSelector(context, "camera");
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) => Camera('driver1')));
                      // Navigator.pushReplacement(BuildContext context, Route<T> newRoute);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/licence.png',
                          height: 60.0,
                          width: 60.0,
                        ),
                        Text(
                          'LICENSE',
                          style: TextStyle(
                              color: CommonVar.app_theme_color,
                              fontSize: 10.0
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      // isLicImg = 1;
                      // isInsuImg = true;
                      Navigator.push(context, MaterialPageRoute(
                          builder: (BuildContext context) => CameraIns('driver1')));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/insurance.png',
                          height: 60.0,
                          width: 60.0,
                        ),
                        Text(
                          'INSURANCE',
                          style: TextStyle(
                              color: CommonVar.app_theme_color,
                              fontSize: 10.0
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
            child: Column(
              children: <Widget>[
                TextFormField(
                  // validator: (input) {
                  //   if(input.isEmpty){
                  //     return 'Provide first name';
                  //   }
                  // },
                  onChanged: (context){
                    preferences.setString('fname1_pref', fnameController.text);
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
                    // validator: (input) {
                    //   if(input.isEmpty){
                    //     return 'Provide last name';
                    //   }
                    // },
                    onChanged: (context){
                      preferences.setString('lname1_pref', lnameController.text);
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
                    // validator: (input) {
                    //   if(input.isEmpty){
                    //     return 'Provide phone number';
                    //   }
                    // },
                    onChanged: (context){
                      preferences.setString('phone1_pref', phoneController.text);
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
                    // validator: (input) {
                    //   if(input.isEmpty){
                    //     return 'Provide an email';
                    //   }
                    // },
                    onChanged: (context){
                      preferences.setString('email1_pref', emailController.text);
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
                        Text(
                          'Signed below',
                          style: TextStyle(
                              color: CommonVar.app_theme_color
                          ),
                        ),
                        InkWell(onTap: _handleClearButtonPressed,
                            child: Text('Clear'))
                      ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                      Padding(
                          padding: EdgeInsets.only(top:5.0,left: 10,right: 10.0),
                          child: Container(
                              height: 150.0,
                              child: SfSignaturePad(
                                key: signatureGlobalKey,
                                backgroundColor: Colors.white,
                                strokeColor: Colors.black,
                                minimumStrokeWidth: 1.0,
                                maximumStrokeWidth: 4.0,
                                onSignEnd: (){
                                  _saveMySignature();
                                },
                              ),
                              decoration:
                              BoxDecoration(border: Border.all(color: Colors.white)))),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center),
              ],
            ),
          ),
        ],
      ),
    );
  }

}