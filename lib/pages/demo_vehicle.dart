import 'dart:convert';//signature

import 'package:demolight/app_utils/app_apis.dart';
import 'package:demolight/app_utils/common_methods.dart';
import 'package:demolight/app_utils/common_var.dart';
import 'package:demolight/models/make_model.dart';
import 'package:demolight/models/model_model.dart';
import 'package:demolight/pages/dahsboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DemoVehicle extends StatefulWidget{
  DemoVehicleState createState() => DemoVehicleState();
}

class DemoVehicleState extends State<DemoVehicle>{
  List<String> _locations = ['Walk In', 'Internet', 'Phone', 'Repeat', 'Referral', 'Be-Back'];
  List<String> _yearSelesct = ['2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2020','2021'];
  String _selectedSource;
  String _selectedYearStr;
  ResultMake selectedMake;
  List<ResultMake> resultList;

  ResultModel selectedModel;
  List<ResultModel> resultModelList;
  String selectModelStr;
  TextEditingController stockController = new TextEditingController();
  TextEditingController yearController = new TextEditingController();
  TextEditingController makeController = new TextEditingController();
  TextEditingController modelController = new TextEditingController();
  TextEditingController driver1Controller = new TextEditingController();
  TextEditingController driver2Controller = new TextEditingController();

  DateTime _chosenDateTime;
  String startDateStr = '';
  String startDateStrForServer = '';
  String endDateStr = '';
  String endDateStrForServer = '';
  bool isStartDate;
  bool isEndDate;
  String selectMakeStr;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<List<String>> getPreferenceData()async{
    List<String> mPrefData = [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString(CommonVar.USERID_KEY);
    String driver1name = preferences.getString('fname1_pref')+' '+preferences.getString('lname1_pref');
    String driver2name = preferences.getString('fname2_pref')+' '+preferences.getString('lname2_pref');
    mPrefData.add(userId);
    mPrefData.add(driver1name);
    mPrefData.add(driver2name);
    return mPrefData;
  }

  Future<dynamic> submitDriverData()async{
    getPreferenceData().then((userId) async {
      CommonMethods.showAlertDialog(context);
      SharedPreferences pref = await SharedPreferences.getInstance();
      var mBody = {
        "user_id": userId[0],
        "source": _selectedSource==null?'':_selectedSource,
        "start_date": startDateStrForServer,
        "end_date": endDateStrForServer,
        "stock": stockController.text,
        "year": _selectedYearStr==null?'':_selectedYearStr,
        "make": selectMakeStr==null?'':selectMakeStr,
        "model": selectModelStr==null?'':selectModelStr,
        "firstname": pref.get('fname1_pref'),
        "lastname": pref.get('lname1_pref'),
        "phone": pref.get('phone1_pref'),
        "email": pref.get('email1_pref'),
        "licence_pic": pref.get('lic1_pref'),
        "insurance_pic": pref.get('ins1_pref'),
        "signature": pref.get('sign1_pref')==null?'':pref.get('sign1_pref'),
        "firstname2": pref.get('fname2_pref'),
        "lastname2": pref.get('lname2_pref'),
        "phone2": pref.get('phone2_pref'),
        "email2": pref.get('email2_pref'),
        "licence_pic2": pref.get('lic2_pref'),
        "insurance_pic2": pref.get('ins2_pref'),
        "signature2": pref.get('sign2_pref')==null?'':pref.get('sign2_pref'),
      };
      print(mBody.toString());
      final response = await http.post(AppApis.SAVE_DRIVER_INFO, body: mBody);
      print('response.statusCode: '+response.statusCode.toString());
      if (response.statusCode == 200) {
        Navigator.pop(context);
        print(response.body);
        Map<String, dynamic> d = json.decode(response.body.trim());
        var fullObj = d["driverinforesponse"];
        var result = fullObj['result'];
        if (result == 'true') {
          _removePrefData();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              Dashboard()), (Route<dynamic> route) => false);
        }
        CommonMethods.showToast(fullObj['massage']);
      }
    });
  }
  _removePrefData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('fname1_pref', '');
    preferences.setString('lname1_pref', '');
    preferences.setString('phone1_pref', '');
    preferences.setString('email1_pref', '');
    preferences.setString('lic1_pref', '');
    preferences.setString('ins1_pref', '');
    preferences.setString('sign1_pref', '');
    preferences.setString('fname2_pref', '');
    preferences.setString('lname2_pref', '');
    preferences.setString('phone2_pref', '');
    preferences.setString('email2_pref', '');
    preferences.setString('lic2_pref', '');
    preferences.setString('ins2_pref', '');
    preferences.setString('sign2_pref', '');
  }
  DateTime startSelectedDateTime;
  // Show the modal that contains the CupertinoDatePicker
  void _showDatePicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) =>
            Container(
              height: 500,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 400,
                    child: CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (val) {
                          setState(() {
                            _chosenDateTime = val;
                          });
                        }),
                  ),

                  // Close the modal
                  CupertinoButton(
                    child: Text('OK'),
                    onPressed: (){
                      _chosenDateTime = null;
                      Navigator.of(ctx).pop();
                      setState(() {
                        if(_chosenDateTime == null){
                          DateTime now = new DateTime.now();
                          _chosenDateTime = new DateTime(now.year, now.month, now.day, now.hour, now.minute);
                        }
                        if(isStartDate){
                          // DateTime now = new DateTime.now();
                          // _chosenDateTime = new DateTime(now.year, now.month, now.day, now.hour, now.minute);
                          String parseDate = new DateFormat("MMM dd, yyyy hh:mm a").format(_chosenDateTime);
                          startDateStr = parseDate;
                          startDateStrForServer = new DateFormat("yyyy-MM-dd").format(_chosenDateTime);
                          startSelectedDateTime = new DateFormat("MMM dd, yyyy hh:mm a").parse(startDateStr);
                          _chosenDateTime = new DateTime(startSelectedDateTime.year, startSelectedDateTime.month, startSelectedDateTime.day, startSelectedDateTime.hour, startSelectedDateTime.minute+15);
                          String parseDateEndDate = new DateFormat("MMM dd, yyyy hh:mm a").format(_chosenDateTime);
                          endDateStrForServer = new DateFormat("yyyy-MM-dd").format(_chosenDateTime);
                          endDateStr = parseDateEndDate;
                        }
                        else if(isEndDate){
                          String parseDate = new DateFormat("MMM dd, yyyy hh:mm a").format(_chosenDateTime);
                          endDateStr = parseDate;
                          DateTime endSelectedDateTime = new DateFormat("MMM dd, yyyy hh:mm a").parse(endDateStr);
                          int diff = endSelectedDateTime.difference(startSelectedDateTime).inMinutes;
                          if(diff<15){
                            CommonMethods.showAlertDialogWithSingleButton(context, 'End date should b greater then 15 minutes from start date');
                          }
                          else{
                            endDateStr = parseDate;
                            endDateStrForServer = new DateFormat("yyyy-MM-dd").format(endSelectedDateTime);
                          }
                        }
                      });
                    },
                  )
                ],
              ),
            ));
  }

  getMakeData(String year)async{
    selectedMake = null;
    CommonMethods.showAlertDialog(context);
    String mUrl = AppApis.GET_MAKE+year+'&format=json';
    print(mUrl);
    final response = await http.get(mUrl);
    if (response.statusCode == 200) {
      Navigator.pop(context);
      setState(() {
        MakeModel makeModelModel = makeModelFromJson(response.body);
        resultList = makeModelModel.results;
      });
    }
  }

  getModelsData(String makeNameStr, String year)async{
    selectedModel = null;
    CommonMethods.showAlertDialog(context);
    String mUrl = AppApis.GET_MODEL+makeNameStr+'/modelyear/'+year+'?format=json';
    print(mUrl);
    final response = await http.get(mUrl);
    if (response.statusCode == 200) {
      Navigator.pop(context);
      setState(() {
        // ModelModel modelModel = modelModelFromJson(response.body);
        // resultList = makeModelModel.results;
        ModelModel modelModel = modelModelFromJson(response.body);
        resultModelList = modelModel.results;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: CommonVar.app_theme_color, //change your color here
            ),
            title: Text(
              'Demo Vehicle',
              style: TextStyle(
                  color: CommonVar.app_theme_color
              ),
            ),
            backgroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                Container(
                  height: 40.0,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[200],
                        ),
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text('Please choose a Source'),
                      ), // Not necessary for Option 1
                      value: _selectedSource,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedSource = newValue;
                        });
                      },
                      items: _locations.map((location) {
                        return DropdownMenuItem(
                          child: Padding(
                            padding: const EdgeInsets.only(left:8.0),
                            child: new Text(location),
                          ),
                          value: location,
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: InkWell(
                    onTap: (){
                      isStartDate = true;
                      isEndDate = false;
                      _showDatePicker(context);
                    },
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[200],
                          ),
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      child: startDateStr == ''?Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Start Date'
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Icon(Icons.add_circle),
                          )
                        ],
                      ):Center(
                          child: Text(
                              startDateStr,
                            style: TextStyle(
                              fontWeight: FontWeight.w800
                            ),
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: InkWell(
                    onTap: (){
                      isStartDate = false;
                      isEndDate = true;
                      _showDatePicker(context);
                    },
                    child: Container(
                      height: 40.0,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[200],
                          ),
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      child: endDateStr == ''?Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'End Date'
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Icon(Icons.add_circle),
                          )
                        ],
                      ):
                      Center(
                          child: Text(
                            endDateStr,
                            style: TextStyle(
                                fontWeight: FontWeight.w800
                            ),
                          )),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0,top: 20.0),
                        child: Text(
                          'Stock #',
                          style: TextStyle(
                              fontWeight: FontWeight.w800
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: stockController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Enter Stock',
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
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          height: 40.0,
                          width: 400.0 ,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[200],
                              ),
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              hint: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text('Please choose year'),
                              ), // Not necessary for Option 1
                              value: _selectedYearStr,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedYearStr = newValue;
                                  getMakeData(_selectedYearStr);
                                });
                              },
                              items: _yearSelesct.map((yearSelect) {
                                return DropdownMenuItem(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:8.0),
                                    child: new Text(yearSelect),
                                  ),
                                  value: yearSelect,
                                );
                              }).toList(),
                            ),
                          ),
                        )
                        ,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:10.0),
                        child: Container(
                          height: 40.0,
                          width: 400.0,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[200],
                              ),
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                          child: resultList==null?Padding(
                            padding: const EdgeInsets.only(top: 10.0,left: 5.0),
                            child: Text(
                              'Select Make',
                              style: TextStyle(
                                  color: Colors.grey
                              ),
                            ),
                          ):DropdownButtonHideUnderline(
                            child: DropdownButton<ResultMake>(
                              hint: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text('Please choose Make'),
                              ),
                              value: selectedMake,
                              isDense: true,
                              onChanged: (ResultMake newValue) {
                                setState(() {
                                  selectedMake = newValue;
                                  selectMakeStr = newValue.makeName;
                                  getModelsData(newValue.makeName, _selectedYearStr);
                                });
                                print(selectedMake);
                              },
                              items: resultList.map((ResultMake map) {
                                return new DropdownMenuItem<ResultMake>(
                                  value: map,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: new Text(map.makeName,
                                        style: new TextStyle(color: Colors.black)),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:10.0),
                        child: Container(
                          height: 40.0,
                          width: 400.0,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[200],
                              ),
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.all(Radius.circular(15))
                          ),
                          child: resultModelList==null?Padding(
                            padding: const EdgeInsets.only(top: 10.0,left: 5.0),
                            child: Text(
                              'Select Model',
                              style: TextStyle(
                                  color: Colors.grey
                              ),
                            ),
                          ):DropdownButtonHideUnderline(
                            child: new DropdownButton<ResultModel>(
                              hint: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text('Please choose Model'),
                              ),
                              value: selectedModel,
                              isDense: true,
                              onChanged: (ResultModel newValue) {
                                setState(() {
                                  selectedModel = newValue;
                                  selectModelStr = newValue.modelName;
                                });
                                print(selectedMake);
                              },
                              items: resultModelList.map((ResultModel map) {
                                return new DropdownMenuItem<ResultModel>(
                                  value: map,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: new Text(map.modelName,
                                        style: new TextStyle(color: Colors.black)),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                            'Driver1 name',
                          style: TextStyle(
                              fontWeight: FontWeight.w800
                          ),
                        ),
                      ),
                      FutureBuilder(
                        future: getPreferenceData(),
                        builder: (context, snapshot){
                          if(snapshot.data[1] == null){
                            return Text('no name');
                          }
                          else{
                            return Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Container(
                                  height: 40.0,
                                  width: 400.0,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey[200],
                                      ),
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.all(Radius.circular(15))
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0,top: 10.0),
                                    child: Text(
                                      snapshot.data[1],
                                    ),
                                  )
                              ),
                            );
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                            'Driver2 name',
                          style: TextStyle(
                              fontWeight: FontWeight.w800
                          ),
                        ),
                      ),
                      FutureBuilder(
                        future: getPreferenceData(),
                        builder: (context, snapshot){
                          if(snapshot.data[2] == null){
                            return Text('no name');
                          }
                          else{
                            return Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Container(
                                  height: 40.0,
                                  width: 400.0,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey[200],
                                      ),
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.all(Radius.circular(15))
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0,top: 10.0),
                                    child: Text(
                                      snapshot.data[2],
                                    ),
                                  )
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: InkWell(
                    onTap: (){
                      submitDriverData();
                    },
                    child: Container(
                      height: 45.0,
                      decoration: new BoxDecoration(
                        color: CommonVar.app_theme_color,
                        //border: new Border.all(color: Colors.white, width: 2.0),
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: Center(child: new Text('Submit', style: new TextStyle(fontSize: 18.0, color: Colors.white),),),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

}