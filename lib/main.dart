import 'dart:async';
import 'package:camera/camera.dart';
import 'package:demolight/app_utils/common_var.dart';
import 'package:demolight/pages/dahsboard.dart';
import 'package:demolight/pages/demo_vehicle.dart';
import 'package:demolight/pages/login_page.dart';
import 'package:demolight/pages/test.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
List<CameraDescription> cameras;
void main() {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  ).then((val)async {
    cameras = await availableCameras();
    runApp(new MyApp());
  });
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: CommonVar.app_theme_color,
    statusBarColor: CommonVar.app_theme_color,
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      // home: CameraHomeScreen(cameras),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goToNextPage();
  }

  void goToNextPage()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isLogin = preferences.getBool(CommonVar.IS_LOGIN_KEY);
    if(isLogin == null){
      isLogin = false;
    }
    if(isLogin){
      Timer(
          Duration(seconds: 3),
              () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => Dashboard())));
    }
    else{
      Timer(
          Duration(seconds: 3),
              () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LoginPage())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Demolight',
              style: TextStyle(
                color: CommonVar.app_theme_color,
                fontSize: 50.0,
                fontWeight: FontWeight.w700
              ),
            ),
          ],
        ),
      ),
    );
  }
}
