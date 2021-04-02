import 'dart:convert';//signature

import 'package:demolight/app_utils/app_apis.dart';
import 'package:demolight/app_utils/common_methods.dart';
import 'package:demolight/app_utils/common_var.dart';
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
  String _selectedSource;
  TextEditingController stockController = new TextEditingController();
  TextEditingController yearController = new TextEditingController();
  TextEditingController makeController = new TextEditingController();
  TextEditingController modelController = new TextEditingController();
  TextEditingController driver1Controller = new TextEditingController();
  TextEditingController driver2Controller = new TextEditingController();

  DateTime _chosenDateTime;
  String startDateStr = '';
  String endDateStr = '';
  bool isStartDate;
  bool isEndDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<String> getUserId()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = preferences.getString(CommonVar.USERID_KEY);
    return userId;
  }

  Future<dynamic> submitDriverData()async{
    if(_selectedSource == null || startDateStr == '' || endDateStr == ''){
      CommonMethods.showAlertDialogWithSingleButton(context,'Please select Source, start date and end date');
    }
    else {
      if (_formKey.currentState.validate()) {
        getUserId().then((userId) async {
          CommonMethods.showAlertDialog(context);
          var mBody = {
            "user_id": userId,
            "firstname": widget.preDetailsList[0],
            "lastname": widget.preDetailsList[1],
            "phone": widget.preDetailsList[2],
            "email": widget.preDetailsList[3],
            "source": _selectedSource,
            "start_date": startDateStr,
            "end_date": endDateStr,
            "year": yearController.text,
            "make": makeController.text,
            "model": modelController.text,
            "driver1_name": driver1Controller.text,
            "driver2_name": driver2Controller.text,
            "licence_pic": widget.preDetailsList[4],
            "insurance_pic": widget.preDetailsList[5],
            "signature": widget.preDetailsList[6],
          };
          print(mBody.toString());
          final response = await http.post(AppApis.SAVE_DRIVER_INFO, body: mBody);
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
                          String parseDate = new DateFormat("MMM dd, yyyy HH:mm a").format(_chosenDateTime);
                          startDateStr = parseDate;
                          print(parseDate);
                        }
                        else if(isEndDate){
                          String parseDate = new DateFormat("MMM dd, yyyy HH:mm a").format(_chosenDateTime);
                          endDateStr = parseDate;
                          print(parseDate);
                        }
                      });
                    },
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(child: Text(
              'Demo Vehicle',
              style: TextStyle(
                  color: CommonVar.app_theme_color
              ),)),
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
                        child: TextFormField(
                          validator: (input) {
                            if(input.isEmpty){
                              return 'Provide year';
                            }
                          },
                          controller: yearController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Enter year',
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          validator: (input) {
                            if(input.isEmpty){
                              return 'Provide make';
                            }
                          },
                          controller: makeController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Enter Make',
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          validator: (input) {
                            if(input.isEmpty){
                              return 'Provide model';
                            }
                          },
                          controller: modelController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Enter Model',
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          validator: (input) {
                            if(input.isEmpty){
                              return 'Provide driver1 name';
                            }
                          },
                          controller: driver1Controller,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Enter Driver1 name',
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
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          validator: (input) {
                            if(input.isEmpty){
                              return 'Provide driver2 name';
                            }
                          },
                          controller: driver2Controller,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: 'Enter Driver2 name',
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
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: InkWell(
                    onTap: (){
                      submitDriverData();
                      // Navigator.push(context, MaterialPageRoute(
                      //     builder: (BuildContext context) => DemoVehicle()));
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