// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.loginresponse,
  });

  Loginresponse loginresponse;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    loginresponse: Loginresponse.fromJson(json["loginresponse"]),
  );

  Map<String, dynamic> toJson() => {
    "loginresponse": loginresponse.toJson(),
  };
}

class Loginresponse {
  Loginresponse({
    this.id,
    this.email,
    this.username,
    this.password,
    this.userType,
    this.status,
    this.result,
    this.sortname,
    this.firstname,
    this.lastname,
    this.mobile,
  });

  String id;
  String email;
  String username;
  String password;
  String userType;
  String status;
  String result;
  String sortname;
  String firstname;
  String lastname;
  String mobile;

  factory Loginresponse.fromJson(Map<String, dynamic> json) => Loginresponse(
    id: json["id"],
    email: json["email"],
    username: json["username"],
    password: json["password"],
    userType: json["user_type"],
    status: json["status"],
    result: json["result"],
    sortname: json["sortname"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    mobile: json["mobile"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "username": username,
    "password": password,
    "user_type": userType,
    "status": status,
    "result": result,
    "sortname": sortname,
    "firstname": firstname,
    "lastname": lastname,
    "mobile": mobile,
  };
}
