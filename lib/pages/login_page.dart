import 'package:demolight/app_utils/app_apis.dart';
import 'package:demolight/app_utils/common_methods.dart';
import 'package:demolight/app_utils/common_var.dart';
import 'package:demolight/models/login_model.dart';
import 'package:demolight/pages/dahsboard.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:demolight/app_utils/common_var.dart';

class LoginPage extends StatefulWidget{
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailCntrl = new TextEditingController();
  TextEditingController passCntrl = new TextEditingController();

  // Future<void> signin() async {
  //   CommonMethods.showAlertDialog(context);
  //   final formState = _formKey.currentState;
  //   await Firebase.initializeApp();
  //   if (formState.validate()) {
  //     setState(() {
  //       // loading = true;
  //     });
  //     formState.save();
  //     try {
  //       final User user = (await FirebaseAuth.instance
  //           .signInWithEmailAndPassword(email: emailCntrl.text, password: passCntrl.text))
  //           .user;
  //       print(user);
  //       if(user.email == emailCntrl.text){
  //         Navigator.pop(context);
  //         SharedPreferences preferences = await SharedPreferences.getInstance();
  //         preferences.setBool('is_login', true);
  //         Navigator.push(context,MaterialPageRoute(
  //             builder: (BuildContext context) => Dashboard()));
  //       }
  //     } catch (e) {
  //       print(e.message);
  //       setState(() {
  //         print(e);
  //         Navigator.pop(context);
  //         CommonMethods.showToast('Email or password is incorrect');
  //         // loading = false;
  //       });
  //     }
  //   }
  // }

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
        // Profileresponse loginResModel = loginModel.profileresponse;
        String result = loginResModel.result;
        if (result == 'true') {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setBool(CommonVar.IS_LOGIN_KEY, true);
          preferences.setString(CommonVar.USERID_KEY, loginResModel.id);
          preferences.setString(CommonVar.USER_EMAIL_KEY, loginResModel.email);
          preferences.setString(CommonVar.USERNAME_KEY, loginResModel.username);
          preferences.setString(CommonVar.USER_STATUS_KEY, loginResModel.status);
          preferences.setString(CommonVar.SORT_NAME_KEY, loginResModel.sortname);
          preferences.setString(CommonVar.FIRST_NAME_KEY, loginResModel.firstname);
          preferences.setString(CommonVar.LAST_NAME_KEY, loginResModel.lastname);
          preferences.setString(CommonVar.USER_MOBILE_KEY, loginResModel.mobile);
          Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) => Dashboard()));
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
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
                          child: Text(
                              'Forget Password',
                            style: TextStyle(
                              fontSize: 17.0,
                              color: CommonVar.app_theme_color
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
      ),
    );
  }

}