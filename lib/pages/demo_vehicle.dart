import 'dart:convert';//signature

import 'package:demolight/app_utils/app_apis.dart';
import 'package:demolight/app_utils/common_methods.dart';
import 'package:demolight/app_utils/common_var.dart';
import 'package:demolight/models/make_model_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DemoVehicle extends StatefulWidget{
  final List<String> preDetailsList;
  DemoVehicle(this.preDetailsList);
  DemoVehicleState createState() => DemoVehicleState();
}

class DemoVehicleState extends State<DemoVehicle>{
  List<String> _locations = ['Walk In', 'Internet', 'Phone', 'Repeat', 'Referral', 'Be-Back'];
  List<String> _yearSelesct = ['2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2020','2021'];
  String _selectedSource;
  String _selectedYearStr;
  Result selectedMake;
  List<Result> resultList;
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
    String driver1name = preferences.getString(CommonVar.DRIVER1_FULL_NAME);
    String driver2name = preferences.getString(CommonVar.DRIVER2_FULL_NAME);
    mPrefData.add(userId);
    mPrefData.add(driver1name);
    mPrefData.add(driver2name);
    return mPrefData;
  }

  Future<dynamic> submitDriverData()async{
    if(_selectedSource == null || startDateStr == '' || endDateStr == ''){
      CommonMethods.showAlertDialogWithSingleButton(context,'Please select Source, start date and end date');
    }
    else {
      if (_formKey.currentState.validate()) {
        getPreferenceData().then((userId) async {
          CommonMethods.showAlertDialog(context);
          /*
          * $_POST['user_id']="2"
$_POST['source']="google"
$_POST['start_date']="2021-10-02"
$_POST['end_date']="2021-10-05"
$_POST['year']="2020"
$_POST['make']="Maruti"
$_POST['model']="Suzuki"
$_POST['firstname']="Test"
$_POST['lastname']="Team"
$_POST['phone']="9988776655"
$_POST['email']="testingteam2@gmail.com"
$_POST['signature']=""
$_POST['licence_pic']=""
$_POST['insurance_pic']=""
$_POST['firstname2']="Test"
$_POST['lastname2']="Team"
$_POST['phone2']="9988776655"
$_POST['email2']="testingteam2@gmail.com"
$_POST['signature2']=""
$_POST['licence_pic2']=""
$_POST['insurance_pic2']=""*/
          var mBody = {
            "user_id": userId[0],
            "source": _selectedSource,
            "start_date": startDateStrForServer,
            "end_date": endDateStrForServer,
            "year": _selectedYearStr,
            "make": selectMakeStr,
            "model": selectModelStr,
            "firstname": widget.preDetailsList[0],
            "lastname": widget.preDetailsList[1],
            "phone": widget.preDetailsList[2],
            "email": widget.preDetailsList[3],
            "licence_pic": widget.preDetailsList[4],
            "insurance_pic": widget.preDetailsList[5],
            "signature": widget.preDetailsList[6],
            "firstname2": widget.preDetailsList[0],
            "lastname2": widget.preDetailsList[1],
            "phone2": widget.preDetailsList[2],
            "email2": widget.preDetailsList[3],
            "licence_pic2": '',
            "insurance_pic2": '',
            "signature2": '',
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
              Navigator.pop(context);
            }
            CommonMethods.showToast(fullObj['massage']);
          }
        });
      }
    }
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
                      Navigator.of(ctx).pop();
                      setState(() {
                        if(_chosenDateTime == null){
                          DateTime now = new DateTime.now();
                          _chosenDateTime = new DateTime(now.year, now.month, now.day, now.hour, now.minute);
                        }
                        if(isStartDate){
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

  getMakeModels(String year)async{
    CommonMethods.showAlertDialog(context);
    String mUrl = AppApis.GET_MAKE_MODEL+year+'?format=json';
    final response = await http.get(mUrl);
    if (response.statusCode == 200) {
      Navigator.pop(context);
      setState(() {
        MakeModelModel makeModelModel = makeModelModelFromJson(response.body);
        resultList = makeModelModel.results;
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
                    children: [
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
                                  getMakeModels(_selectedYearStr);
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
                            child: new DropdownButton<Result>(
                              hint: Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Text('Please choose Make'),
                              ),
                              value: selectedMake,
                              isDense: true,
                              onChanged: (Result newValue) {
                                setState(() {
                                  selectedMake = newValue;
                                  selectModelStr = newValue.modelName;
                                  selectMakeStr = newValue.makeName;
                                });
                                print(selectedMake);
                              },
                              items: resultList.map((Result map) {
                                return new DropdownMenuItem<Result>(
                                  value: map,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: new Text(map.makeName+'-'+map.modelId.toString(),
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
                              child: selectModelStr==null?Text(
                                  'Model Name',
                                style: TextStyle(
                                  color: Colors.grey
                                ),
                              ):
                              Text(
                                  selectModelStr,
                              ),
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text('Driver1 name'),
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
                        child: Text('Driver2 name'),
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