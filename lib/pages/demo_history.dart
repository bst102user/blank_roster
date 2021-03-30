import 'dart:convert';

import 'package:demolight/app_utils/app_apis.dart';
import 'package:demolight/app_utils/common_methods.dart';
import 'package:demolight/app_utils/common_var.dart';
import 'package:demolight/models/driver_model.dart';
import 'package:demolight/pages/see_all_photos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DemoHistory extends StatefulWidget {
  DemoHistoryState createState() => DemoHistoryState();
}

class DemoHistoryState extends State<DemoHistory> {
  TextEditingController searchController = new TextEditingController();

  Future<String> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString(CommonVar.USERID_KEY);
    return userId;
  }

  Future<dynamic> getDriverInfo(String userId) async {
    var mBody = {
      "user_id": userId,
    };
    print(mBody.toString());
    final response = await http.post(AppApis.DRIVER_INFO_LIST, body: mBody);
    if (response.statusCode == 200) {
      // Navigator.pop(context);
      print(response.body);
      Map<String, dynamic> d = json.decode(response.body.trim());
      var fullObj = d['driver_list_response_true'];
      if (fullObj == null) {
        CommonMethods.showToast('No Data Found');
        return 'no_data';
      } else {
        DriversModel driversModel = driversModelFromJson(response.body);
        List<DriverListResponseTrue> driversList =
            driversModel.driverListResponseTrue;
        return driversList;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Container(
                  height: 40.0,
                  child: TextField(
                    controller: searchController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Search Customer Name',
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
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: getUserId(),
              builder: (context, userSnap) {
                if (userSnap.data == null) {
                  return Container();
                }
                else{
                  return FutureBuilder(
                    future: getDriverInfo(userSnap.data),
                    builder: (context, snapshot){
                      if(snapshot.data == null){
                        return Center(
                          child: Column(
                            children: [
                              Text('Loading...')
                            ],
                          ),
                        );
                      }
                      else if(snapshot.data == 'no_data'){
                        return Center(
                          child: Column(
                            children: [
                              Text(
                                'No Data Found',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600
                                ),)
                            ],
                          ),
                        );
                      }
                      else{
                        List<DriverListResponseTrue> sDriver = snapshot.data;
                        return Expanded(
                          flex: 9,
                          child: ListView.builder(
                            itemCount: sDriver.length,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 7.0),
                                      child: Text(
                                        sDriver[i].startDate,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      child: Column(
                                        crossAxisAlignment:CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
                                            child: Row(
                                              // crossAxisAlignment:CrossAxisAlignment.start,
                                              children: <Widget>[
                                                InkWell(
                                                  onTap:(){
                                                    List<String> allImages = [];
                                                    allImages.add(AppApis.IMAGE_BASE_URL+sDriver[i].licencePic);
                                                    allImages.add(AppApis.IMAGE_BASE_URL+sDriver[i].insurancePic);
                                                    allImages.add(AppApis.IMAGE_BASE_URL+sDriver[i].signature);
                                                    Navigator.push(context, MaterialPageRoute(
                                                        builder: (BuildContext context) => SeeAllPhotos(allImages)));
                                                  },
                                                  child: Image.network(
                                                      AppApis.IMAGE_BASE_URL+sDriver[i].licencePic,
                                                    width: deviceWidth*0.3,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        sDriver[i].firstname,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        'M: '+sDriver[i].phone,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Stk #77888',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        sDriver[i].model+' '+sDriver[i].make,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        'E: '+sDriver[i].email,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      }
                    },
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
