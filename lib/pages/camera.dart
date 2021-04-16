import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:demolight/app_utils/common_methods.dart';
import 'package:demolight/app_utils/common_var.dart';
import 'package:demolight/pages/CameraIns.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:thumbnails/thumbnails.dart';
import 'package:flutter/services.dart' show rootServices;
import 'package:path_provider/path_provider.dart' as path_provider;

class Camera extends StatefulWidget {
  final String lastPage;
  Camera(this.lastPage);

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<Camera> {
  File imageFile = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, targetPath,
      quality: 80,
      rotate: 0,
      minWidth: 512,
      minHeight: 250
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  //********************** IMAGE PICKER
  Future imageSelector(BuildContext context, String pickerType) async {
    File imageFilel = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = dir.absolute.path + "/temp.jpg";
    testCompressAndGetFile(imageFilel, targetPath).then((value)async{
      imageFile = value;
      List<int> imageBytes = imageFile.readAsBytesSync();
      String photoBase64Lic = base64Encode(imageBytes);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      if(widget.lastPage == 'driver1') {
        preferences.setString('lic1_pref', photoBase64Lic);
      }
      else{
        preferences.setString('lic2_pref', photoBase64Lic);
      }
      print(photoBase64Lic);
      if (imageFile != null) {
        print("You selected  image : " + imageFile.path);
        setState(() {
          debugPrint("SELECTED IMAGE PICK   $imageFile");
        });
      } else {
        print("You have not taken image");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Licence'
        ),
      ),
      body: Column(
        children: [
      Container(
      width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.4,
        margin: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.rectangle,
            image: DecorationImage(
                image: imageFile == null
                    ? AssetImage('assets/images/picture.png')
                    : FileImage(imageFile),
                fit: BoxFit.cover))),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                InkWell(
                  onTap: (){
                    imageSelector(context, "camera");
                  },
                  child: Icon(
                      Icons.camera_alt,
                    size: 50.0,
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (BuildContext context) => CameraIns(widget.lastPage)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'NEXT',
                      style: TextStyle(
                        color: CommonVar.app_theme_color,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}

