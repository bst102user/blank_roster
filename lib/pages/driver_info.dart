import 'package:demolight/app_utils/common_var.dart';
import 'package:demolight/pages/driver1page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'driver2page.dart';

class DriverInfo extends StatefulWidget{
  DriverInfoState createState() => DriverInfoState();
}
class DriverInfoState extends State<DriverInfo>{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    savePrefData();
  }

  savePrefData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(CommonVar.DRIVER1_FULL_NAME, '');
    preferences.setString(CommonVar.DRIVER2_FULL_NAME, '');
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new AppBar(
          flexibleSpace: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              new TabBar(
                tabs: [
                  Tab(icon: new Text('Driver 1')),
                  Tab(icon: new Text('Driver 2')),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Driver1Page(),
            Driver2Page(),
          ],
        ),
      ),
    );
  }

}