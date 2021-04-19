import 'dart:convert';

import 'package:demolight/app_utils/app_apis.dart';
import 'package:demolight/app_utils/common_methods.dart';
import 'package:demolight/app_utils/common_var.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgetPassword extends StatefulWidget{
  final String userId;
  final int otpStr;
  ForgetPassword(this.userId,this.otpStr);
  ForgetPasswordState createState() => ForgetPasswordState();
}

class ForgetPasswordState extends State<ForgetPassword>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController passwordCtrl = new TextEditingController();
  TextEditingController conPassCtrl = new TextEditingController();
  TextEditingController otpCtrl = new TextEditingController();

  updatePassword()async{
    if(_formKey.currentState.validate()){
      if(int.parse(otpCtrl.text) == widget.otpStr){
        if(passwordCtrl.text == conPassCtrl.text){
          CommonMethods.showAlertDialog(context);
          var mBody = {
            "id": widget.userId,
            "password": passwordCtrl.text,
          };
          final response =
          await http.post(AppApis.UPDATE_PASSWORD, body: mBody);
          print(response.body);
          if (response.statusCode == 200) {
            Navigator.pop(context);
            print(response.body);
            Map<String, dynamic> d = json.decode(response.body.trim());
            var fullObj = d['updatepasswordresponse'];
            var result = fullObj['result'];
            if(result == 'true'){
              Navigator.pop(context);
            }
            CommonMethods.showToast(fullObj['massage']);
          }
        }
        else{
          CommonMethods.showToast('Password and Confirm password is mismatch');
        }
      }
      else{
        CommonMethods.showToast('OTP does not match');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: CommonVar.app_theme_color, //change your color here
        ),
        title:  Text(
          'Forget Password',
          style: TextStyle(
              color: CommonVar.app_theme_color
          ),),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0,top: 50.0),
                      child: Text('OTP'),
                    ),
                    TextFormField(
                      validator: (input) {
                        if(input.isEmpty){
                          return 'Provide an OTP';
                        }
                      },
                      controller: otpCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter OTP',
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
                      padding: const EdgeInsets.only(bottom: 5.0,top: 10.0),
                      child: Text('Password'),
                    ),
                    TextFormField(
                      obscureText: true,
                      validator: (input) {
                        if(input.isEmpty){
                          return 'Provide an password';
                        }
                      },
                      controller: passwordCtrl,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: 'Password',
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
                      padding: const EdgeInsets.only(bottom: 5.0,top: 10.0),
                      child: Text('Confirm Password'),
                    ),
                    TextFormField(
                      validator: (input) {
                        if(input.isEmpty){
                          return 'Provide Confirm Password';
                        }
                      },
                      controller: conPassCtrl,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
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
                      padding: const EdgeInsets.only(top: 15.0),
                      child: InkWell(
                        onTap: (){
                          updatePassword();
                        },
                        child: Container(
                          height: 45.0,
                          decoration: new BoxDecoration(
                            color: CommonVar.app_theme_color,
                            //border: new Border.all(color: Colors.white, width: 2.0),
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: Center(child: new Text('Update Password', style: new TextStyle(fontSize: 18.0, color: Colors.white),),),
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