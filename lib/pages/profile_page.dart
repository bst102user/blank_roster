import 'dart:convert';

import 'package:demolight/app_utils/app_apis.dart';
import 'package:demolight/app_utils/common_methods.dart';
import 'package:demolight/app_utils/common_var.dart';
import 'package:demolight/models/get_profile_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget{
  ProfilePageState pps = new ProfilePageState();
  void xxx(){
    pps.getUserId().then((userId){
      pps.saveProfileData(userId);
    });
  }
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>{
  TextEditingController storeTec = new TextEditingController();
  TextEditingController usernameTec = new TextEditingController();
  TextEditingController fnameTec = new TextEditingController();
  TextEditingController lnameTec = new TextEditingController();
  TextEditingController mobileTec = new TextEditingController();
  TextEditingController newPassTec = new TextEditingController();
  TextEditingController confirmPassTec = new TextEditingController();

  Future<String> getUserId()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString(CommonVar.USERID_KEY);
    return userId;
  }

  void saveww(){
    print('ggfgf');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId().then((userId){
      getProfileData(userId);
    });
  }

  Future<dynamic> getProfileData(String userId)async{
    CommonMethods.showAlertDialog(context);
    var mBody = {
      "id": userId,
    };
    final response = await http.post(AppApis.GET_PROFILE, body: mBody);
    print(response.body);
    if (response.statusCode == 200) {
      Navigator.pop(context);
      GetProfileModel profileModel = getProfileModelFromJson(response.body);
      Profileresponse profileresponse = profileModel.profileresponse;
      storeTec.text = profileresponse.storename;
      usernameTec.text = profileresponse.username;
      fnameTec.text = profileresponse.firstname;
      lnameTec.text = profileresponse.lastname;
      mobileTec.text = profileresponse.mobile;
    }
    else{
      CommonMethods.showToast('Something is not right');
    }
  }

  Future<dynamic> saveProfileData(String userId)async{
    CommonMethods.showAlertDialog(context);
    var mBody = {
      "id": userId,
      "username": usernameTec.text,
      "sortname": storeTec.text,
      "firstname": fnameTec.text,
      "lastname": lnameTec.text,
      "mobile": mobileTec.text,
      "password": newPassTec.text,
    };
    final response = await http.post(AppApis.UPDATE_PROFILE, body: mBody);
    if (response.statusCode == 200) {
      Navigator.pop(context);
      print(response.body);
      Map<String, dynamic> d = json.decode(response.body.trim());
      var fullObj = d["profileresponse"];
      // print(fullObj);
      CommonMethods.showToast(fullObj['massage']);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(
          'Profile',
          style: TextStyle(
              color: CommonVar.app_theme_color
          ),)),
        backgroundColor: Colors.white,
        actions: <Widget>[
          InkWell(
            onTap: (){
              getUserId().then((userId){
                saveProfileData(userId);
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Center(
                child: Text(
                  'Update',
                  style: TextStyle(
                      color: CommonVar.app_theme_color
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0,top: 20.0),
              child: Text(
                'Store Name',
                style: TextStyle(
                    fontWeight: FontWeight.w800
                ),),
            ),
            TextFormField(
              validator: (input) {
                if(input.isEmpty){
                  return 'Provide an store name';
                }
              },
              controller: storeTec,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Enter store name',
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
              padding: const EdgeInsets.only(bottom: 5.0,top: 20.0),
              child: Text(
                'Username',
                style: TextStyle(
                    fontWeight: FontWeight.w800
                ),
              ),
            ),
            TextFormField(
              validator: (input) {
                if(input.isEmpty){
                  return 'Provide an username';
                }
              },
              controller: usernameTec,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Enter username',
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
              padding: const EdgeInsets.only(bottom: 5.0,top: 20.0),
              child: Text(
                'First Name',
                style: TextStyle(
                    fontWeight: FontWeight.w800
                ),),
            ),
            TextFormField(
              validator: (input) {
                if(input.isEmpty){
                  return 'Provide first name';
                }
              },
              controller: fnameTec,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Enter first name',
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
              padding: const EdgeInsets.only(bottom: 5.0,top: 20.0),
              child: Text(
                'Last Name',
                style: TextStyle(
                    fontWeight: FontWeight.w800
                ),),
            ),
            TextFormField(
              validator: (input) {
                if(input.isEmpty){
                  return 'Provide last name';
                }
              },
              controller: lnameTec,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Enter last name',
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
              padding: const EdgeInsets.only(bottom: 5.0,top: 20.0),
              child: Text(
                'Mobile #',
                style: TextStyle(
                    fontWeight: FontWeight.w800
                ),),
            ),
            TextFormField(
              validator: (input) {
                if(input.isEmpty){
                  return 'Provide mobile number';
                }
              },
              controller: mobileTec,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter mobile number',
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
            InkWell(
              onTap: (){
                print(storeTec.text+'yyyy');
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5.0,top: 30.0),
                  child: Text(
                    'Update Password',
                    style: TextStyle(
                        color: CommonVar.app_theme_color,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0,top: 20.0),
              child: Text(
                'New Password',
                style: TextStyle(
                    fontWeight: FontWeight.w800
                ),),
            ),
            TextFormField(
              validator: (input) {
                if(input.isEmpty){
                  return 'Provide password';
                }
              },
              controller: newPassTec,
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Enter password',
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
              padding: const EdgeInsets.only(bottom: 5.0,top: 20.0),
              child: Text(
                'Confirm Password',
                style: TextStyle(
                    fontWeight: FontWeight.w800
                ),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: TextFormField(
                validator: (input) {
                  if(input.isEmpty){
                    return 'Provide confirm password';
                  }
                },
                controller: confirmPassTec,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter confirm password',
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
          ],
        ),
      ),
    );
  }

}