import 'dart:convert';

import 'package:demolight/app_utils/app_apis.dart';
import 'package:demolight/app_utils/common_methods.dart';
import 'package:demolight/app_utils/common_var.dart';
import 'package:demolight/models/login_model.dart';
import 'package:demolight/pages/dahsboard.dart';
import 'package:demolight/pages/forget_password.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget{
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailCntrl = new TextEditingController();
  TextEditingController passCntrl = new TextEditingController();
  TextEditingController emailForForgetCtrl = new TextEditingController();

  loginUser(String username, String password) async {
    if (_formKey.currentState.validate()) {
      CommonMethods.showAlertDialog(context);
      var mBody = {
        "email": username,
        "password": password,
      };
      final response =
      await http.post(AppApis.LOGIN_USER, body: mBody);
      print(response.body);
      if (response.statusCode == 200) {
        Navigator.pop(context);
        print(response.body);
        LoginModel loginModel = loginModelFromJson(response.body);
        Loginresponse loginResModel = loginModel.loginresponse;
        String result = loginResModel.result;
        if (result == 'true') {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setBool(CommonVar.IS_LOGIN_KEY, true);
          preferences.setString(CommonVar.USERID_KEY, loginResModel.id);
          preferences.setString(CommonVar.USER_EMAIL_KEY, loginResModel.email);
          preferences.setString(CommonVar.USERNAME_KEY, loginResModel.username);
          preferences.setString(CommonVar.USER_STATUS_KEY, loginResModel.status);
          preferences.setString(CommonVar.store_NAME_KEY, loginResModel.storename);
          preferences.setString(CommonVar.FIRST_NAME_KEY, loginResModel.firstname);
          preferences.setString(CommonVar.LAST_NAME_KEY, loginResModel.lastname);
          preferences.setString(CommonVar.USER_MOBILE_KEY, loginResModel.mobile);
          // Navigator.push(context, MaterialPageRoute(
          //     builder: (BuildContext context) => Dashboard()));
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Dashboard()),
                  (Route<dynamic> route) => false);
        }
        else if (result == 'false') {
          CommonMethods.showToast(
              'You have entered invalid credentials');
        }
      }
      else{
        CommonMethods.showToast(
            'Something is not right');
      }
    }
  }

  forgetPassword(String mEmail)async{
    CommonMethods.showAlertDialog(context);
    var mBody = {
      "email": mEmail,
    };
    final response =
    await http.post(AppApis.FORGET_PASSWORD, body: mBody);
    print(response.body);
    if (response.statusCode == 200) {
      Navigator.pop(context);
      print(response.body);
      Map<String, dynamic> d = json.decode(response.body.trim());
      var fullObj = d['forgot_password_response'];
      var result = fullObj['result'];
      if(result == 'true'){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
            builder: (BuildContext context) => ForgetPassword(fullObj['id'],fullObj['otp'])));
      }
      CommonMethods.showToast(fullObj['massage']);
    }
  }

  _showForgetPassDialog() async {
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
          return _SystemPadding(
            child: new AlertDialog(
              contentPadding: const EdgeInsets.all(16.0),
              content: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new TextField(
                      controller: emailForForgetCtrl,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'Enter your email', hintText: 'eg. abc@gmail.com'),
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                new FlatButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                new FlatButton(
                    child: const Text('Send OTP'),
                    onPressed: () {
                      if(emailForForgetCtrl.text == '' || emailForForgetCtrl.text == null){
                        CommonMethods.showToast('Please enter yore email');
                      }
                      else{
                        forgetPassword(emailForForgetCtrl.text);
                      }
                    })
              ],
            ),
          );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'DEMOLIGHT',
              style: TextStyle(
                  fontSize: 35.0,
                  color: CommonVar.app_theme_color
              ),
            ),
            Text(
              'The best way to test drive.',
              style: TextStyle(
                  fontSize: 17.0,
                  color: CommonVar.app_theme_color
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0,top: 50.0),
                      child: Text('User Email'),
                    ),
                    TextFormField(
                      validator: (input) {
                        if(input.isEmpty){
                          return 'Provide an email';
                        }
                      },
                      controller: emailCntrl,
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0,top: 10.0),
                      child: Text('Password'),
                    ),
                    TextFormField(
                      validator: (input) {
                        if(input.isEmpty){
                          return 'Provide an password';
                        }
                      },
                      controller: passCntrl,
                      keyboardType: TextInputType.text,
                      obscureText: true,
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
                      padding: const EdgeInsets.only(top: 15.0),
                      child: InkWell(
                        onTap: (){
                          loginUser(emailCntrl.text,passCntrl.text);
                        },
                        child: Container(
                          height: 45.0,
                          decoration: new BoxDecoration(
                            color: CommonVar.app_theme_color,
                            //border: new Border.all(color: Colors.white, width: 2.0),
                            borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: Center(child: new Text('Login', style: new TextStyle(fontSize: 18.0, color: Colors.white),),),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: InkWell(
                          onTap: (){
                            _showForgetPassDialog();
                          },
                          child: Text(
                            'Forget Password',
                            style: TextStyle(
                                fontSize: 17.0,
                                color: CommonVar.app_theme_color
                            ),
                          ),
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

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}