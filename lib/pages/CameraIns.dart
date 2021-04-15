import 'dart:convert';
import 'dart:io';

import 'package:demolight/app_utils/common_var.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraIns extends StatefulWidget {
  const CameraIns({Key key}) : super(key: key);

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

  //********************** IMAGE PICKER
  Future imageSelector(BuildContext context, String pickerType) async {
    switch (pickerType) {
      case "gallery":

      /// GALLERY IMAGE PICKER
        imageFile = await ImagePicker.pickImage(
            source: ImageSource.gallery, imageQuality: 90);
        break;

      case "camera": // CAMERA CAPTURE CODE
        imageFile = await ImagePicker.pickImage(source: ImageSource.camera, imageQuality: 50);
        List<int> imageBytes = imageFile.readAsBytesSync();
        String photoBase64Lic = base64Encode(imageBytes);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('ins1_pref', photoBase64Lic);
        print(photoBase64Lic);
        break;
    }

    if (imageFile != null) {
      print("You selected  image : " + imageFile.path);
      setState(() {
        debugPrint("SELECTED IMAGE PICK   $imageFile");
      });
    } else {
      print("You have not taken image");
    }
  }

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
                    Navigator.pop(context);
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