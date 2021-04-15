// To parse this JSON data, do
//
//     final getProfileModel = getProfileModelFromJson(jsonString);

import 'dart:convert';

GetProfileModel getProfileModelFromJson(String str) => GetProfileModel.fromJson(json.decode(str));

String getProfileModelToJson(GetProfileModel data) => json.encode(data.toJson());

class GetProfileModel {
  GetProfileModel({
    this.profileresponse,
  });

  Profileresponse profileresponse;

  factory GetProfileModel.fromJson(Map<String, dynamic> json) => GetProfileModel(
    profileresponse: Profileresponse.fromJson(json["profileresponse"]),
  );

  Map<String, dynamic> toJson() => {
    "profileresponse": profileresponse.toJson(),
  };
}

class Profileresponse {
  Profileresponse({
    this.id,
    this.email,
    this.username,
    this.password,
    this.userType,
    this.storename,
    this.firstname,
    this.lastname,
    this.mobile,
    this.status,
    this.result,
  });

  String id;
  String email;
  String username;
  String password;
  String userType;
  String storename;
  String firstname;
  String lastname;
  String mobile;
  String status;
  String result;

  factory Profileresponse.fromJson(Map<String, dynamic> json) => Profileresponse(
    id: json["id"],
    email: json["email"],
    username: json["username"],
    password: json["password"],
    userType: json["user_type"],
    storename: json["storename"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    mobile: json["mobile"],
    status: json["status"],
    result: json["result"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "username": username,
    "password": password,
    "user_type": userType,
    "storename": storename,
    "firstname": firstname,
    "lastname": lastname,
    "mobile": mobile,
    "status": status,
    "result": result,
  };
}
