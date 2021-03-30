// To parse this JSON data, do
//
//     final driversModel = driversModelFromJson(jsonString);

import 'dart:convert';

DriversModel driversModelFromJson(String str) => DriversModel.fromJson(json.decode(str));

String driversModelToJson(DriversModel data) => json.encode(data.toJson());

class DriversModel {
  DriversModel({
    this.driverListResponseTrue,
  });

  List<DriverListResponseTrue> driverListResponseTrue;

  factory DriversModel.fromJson(Map<String, dynamic> json) => DriversModel(
    driverListResponseTrue: List<DriverListResponseTrue>.from(json["driver_list_response_true"].map((x) => DriverListResponseTrue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "driver_list_response_true": List<dynamic>.from(driverListResponseTrue.map((x) => x.toJson())),
  };
}

class DriverListResponseTrue {
  DriverListResponseTrue({
    this.id,
    this.userId,
    this.firstname,
    this.lastname,
    this.phone,
    this.email,
    this.signature,
    this.licencePic,
    this.insurancePic,
    this.source,
    this.startDate,
    this.endDate,
    this.year,
    this.make,
    this.model,
    this.driver1Name,
    this.driver2Name,
  });

  String id;
  String userId;
  String firstname;
  String lastname;
  String phone;
  String email;
  String signature;
  String licencePic;
  String insurancePic;
  String source;
  String startDate;
  String endDate;
  String year;
  String make;
  String model;
  String driver1Name;
  String driver2Name;

  factory DriverListResponseTrue.fromJson(Map<String, dynamic> json) => DriverListResponseTrue(
    id: json["id"],
    userId: json["user_id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    phone: json["phone"],
    email: json["email"],
    signature: json["signature"],
    licencePic: json["licence_pic"],
    insurancePic: json["insurance_pic"],
    source: json["source"],
    startDate: json["start_date"],
    endDate: json["end_date"],
    year: json["year"],
    make: json["make"],
    model: json["model"],
    driver1Name: json["driver1_name"],
    driver2Name: json["driver2_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "firstname": firstname,
    "lastname": lastname,
    "phone": phone,
    "email": email,
    "signature": signature,
    "licence_pic": licencePic,
    "insurance_pic": insurancePic,
    "source": source,
    "start_date": startDate,
    "end_date": endDate,
    "year": year,
    "make": make,
    "model": model,
    "driver1_name": driver1Name,
    "driver2_name": driver2Name,
  };
}
