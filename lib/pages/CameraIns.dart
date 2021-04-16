import 'dart:convert';
import 'dart:io';

import 'package:demolight/app_utils/common_methods.dart';
import 'package:demolight/app_utils/common_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class CameraIns extends StatefulWidget {
  final String lastPage;
  CameraIns(this.lastPage);

  @override
  CameraScreenState createState() => CameraScreenState();
}
class CameraScreenState extends State<CameraIns> {
  File imageFile = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 60,
        rotate: 0,
        minWidth: 512,
        minHeight: 250
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  Future imageSelector(BuildContext context, String pickerType) async {
    File imageFilel = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
    final dir = await path_provider.getTemporaryDirectory();
    String mTime = DateTime.now().millisecondsSinceEpoch.toString();
    final targetPath = dir.absolute.path + "/$mTime.jpg";
    testCompressAndGetFile(imageFilel, targetPath).then((value)async{
      imageFile = value;
      List<int> imageBytes = imageFile.readAsBytesSync();
      String photoBase64Lic = base64Encode(imageBytes);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      if(widget.lastPage == 'driver1') {
        preferences.setString('ins1_pref', photoBase64Lic);
      }
      else{
        preferences.setString('ins2_pref', photoBase64Lic);
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

  //********************** IMAGE PICKER

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Insurance'
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
                      fit: BoxFit.cover)
              )
          ),
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
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Done',
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