import 'package:demolight/app_utils/common_var.dart';
import 'package:demolight/pages/demo_history.dart';
import 'package:demolight/pages/driver_info.dart';
import 'package:demolight/pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget{
  DashboardPage createState() => DashboardPage();
}
class DashboardPage extends State<Dashboard>{
  Widget currentWidget;
  int navIndex = 0;
  String mAppBar = 'History';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentWidget = new DemoHistory();
    // logout();
  }

  void logout()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('is_login', false);
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: navIndex == 2?null:AppBar(
          title: Center(child: Text(
              mAppBar,
          style: TextStyle(
            color: CommonVar.app_theme_color
          ),)),
          backgroundColor: Colors.white,
        ),
        body: currentWidget,
        bottomNavigationBar: new BottomNavigationBar(
          currentIndex: navIndex,
          onTap: (int index) {
            setState((){
              this.navIndex = index;
              mAppBar = 'History';
              if(navIndex == 0){
                currentWidget = new DemoHistory();
              }
              else if(navIndex == 1){
                currentWidget = new DriverInfo();
                mAppBar = 'Driver Info';
              }
              else if(navIndex == 2){
                currentWidget = new ProfilePage();
                mAppBar = 'Profile';
              }
            });
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset(
                  'assets/images/history_icn.png',
                height: 30.0,
                width: 30.0,
                color: navIndex == 0?CommonVar.app_theme_color:Colors.grey,
              ),
              title: new Text("History"),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/new_demo_icn.png',
                height: 30.0,
                width: 30.0,
                color: navIndex == 1?CommonVar.app_theme_color:Colors.grey,
              ),
              title: new Text("New Demo"),
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/profile_icn.png',
                height: 30.0,
                width: 30.0,
                color: navIndex == 2?CommonVar.app_theme_color:Colors.grey,
              ),
              title: new Text("Profile"),
            ),
          ],
        ),
      ),
    );
  }

}