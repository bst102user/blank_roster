import 'package:demolight/app_utils/common_var.dart';
import 'package:demolight/app_utils/global_state.dart';
import 'package:demolight/pages/driver1page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'demo_vehicle.dart';
import 'driver2page.dart';

class DriverInfo extends StatefulWidget{
  DriverInfoState createState() => DriverInfoState();
}
class DriverInfoState extends State<DriverInfo>{
  final GlobalState store = GlobalState.instance;
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
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: height*0.6,
              child: TabBarView(
                children: [
                  Driver1Page(),
                  Driver2Page(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),
              child: InkWell(
                onTap: ()async{
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  String ss = pref.get('fname_key');
                  print(ss);
                  // Driver1Page dp = new Driver1Page();
                  // dp.hh();
                  // Driver2Page dp2 = new Driver2Page();
                  // Map map1 = dp.pickDataForSend();
                  // Map map2 = dp2.pickDataForSend();
                  Navigator.push(context, MaterialPageRoute(
                      builder: (BuildContext context) => DemoVehicle()));
                },
                child: Container(
                  height: 45.0,
                  decoration: new BoxDecoration(
                    color: CommonVar.app_theme_color,
                    //border: new Border.all(color: Colors.white, width: 2.0),
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
                  child: Center(child: new Text('Vehicle', style: new TextStyle(fontSize: 18.0, color: Colors.white),),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}