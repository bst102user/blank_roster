import 'package:demolight/pages/driver1page.dart';
import 'package:demolight/pages/driver2page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DriverInfo extends StatefulWidget{
  DriverInfoState createState() => DriverInfoState();
}
class DriverInfoState extends State<DriverInfo>{
  @override
  Widget build(BuildContext context) {
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
            Driver1Page(),
          ],
        ),
      ),
    );
  }

}