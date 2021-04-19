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
  List<DriverListResponseTrue> _searchResult = [];
  List<DriverListResponseTrue> _userDetails = [];

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _userDetails.forEach((userDetail) {
      if (userDetail.email.contains(text) || userDetail.firstname.contains(text) || userDetail.phone.contains(text))
        _searchResult.add(userDetail);
    });
    setState(() {});
  }

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
        _userDetails = driversList;
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
                    onChanged: onSearchTextChanged,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          searchController.clear();
                          onSearchTextChanged('');
                        },
                        icon: Icon(Icons.clear),
                      ),
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
                          child:  _searchResult.length != 0 || searchController.text.isNotEmpty
                              ?ListView.builder(
                            itemCount: _searchResult.length,
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
                                        CommonMethods.convertDateTimeDisplay(_searchResult[i].startDate),
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
                                                    if(_searchResult[i].licencePic==''&&_searchResult[i].insurancePic==''&&_searchResult[i].signature==''){
                                                      CommonMethods.showToast('No Image found');
                                                    }
                                                    else{
                                                      List<String> allImages = [];
                                                      allImages.add(AppApis.IMAGE_BASE_URL+_searchResult[i].licencePic);
                                                      allImages.add(AppApis.IMAGE_BASE_URL+_searchResult[i].insurancePic);
                                                      allImages.add(AppApis.IMAGE_BASE_URL+_searchResult[i].signature);
                                                      Navigator.push(context, MaterialPageRoute(
                                                          builder: (BuildContext context) => SeeAllPhotos(allImages)));
                                                    }
                                                    },
                                                  child: _searchResult[i].licencePic != ''?
                                                  Image.network(
                                                      AppApis.IMAGE_BASE_URL+_searchResult[i].licencePic,
                                                    width: deviceWidth*0.4,
                                                    height: deviceWidth*0.15,
                                                      fit:BoxFit.fill
                                                  ):
                                                  Icon(Icons.not_interested,
                                                    color: Colors.grey,
                                                    size: 100,),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 10.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        _searchResult[i].firstname,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        'M: '+_searchResult[i].phone,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        'Year #'+_searchResult[i].year,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        _searchResult[i].model+' '+_searchResult[i].make,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        'E: '+_searchResult[i].email,
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
                          ):
                          ListView.builder(
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
                                        CommonMethods.convertDateTimeDisplay(sDriver[i].startDate),
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
                                                    if(sDriver[i].licencePic==''&&sDriver[i].licencePic==''&&sDriver[i].licencePic==''){
                                                      CommonMethods.showToast('No Image found');
                                                    }
                                                    else{
                                                      List<String> allImages = [];
                                                      allImages.add(AppApis.IMAGE_BASE_URL+sDriver[i].licencePic);
                                                      allImages.add(AppApis.IMAGE_BASE_URL+sDriver[i].insurancePic);
                                                      allImages.add(AppApis.IMAGE_BASE_URL+sDriver[i].signature);
                                                      Navigator.push(context, MaterialPageRoute(
                                                          builder: (BuildContext context) => SeeAllPhotos(allImages)));

                                                    }
                                                    },
                                                  child: sDriver[i].licencePic != ''?Image.network(
                                                    AppApis.IMAGE_BASE_URL+sDriver[i].licencePic,
                                                    width: deviceWidth*0.3,
                                                    height: deviceWidth*0.2,
                                                      fit:BoxFit.fill
                                                  ):Icon(
                                                      Icons.not_interested,
                                                    color: Colors.grey,
                                                    size: 100,
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
                                                        'Year #'+sDriver[i].year,
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
