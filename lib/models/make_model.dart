// To parse this JSON data, do
//
//     final makeModel = makeModelFromJson(jsonString);

import 'dart:convert';

MakeModel makeModelFromJson(String str) => MakeModel.fromJson(json.decode(str));

String makeModelToJson(MakeModel data) => json.encode(data.toJson());

class MakeModel {
  MakeModel({
    this.count,
    this.message,
    this.searchCriteria,
    this.results,
  });

  int count;
  String message;
  String searchCriteria;
  List<ResultMake> results;

  factory MakeModel.fromJson(Map<String, dynamic> json) => MakeModel(
    count: json["Count"],
    message: json["Message"],
    searchCriteria: json["SearchCriteria"],
    results: List<ResultMake>.from(json["Results"].map((x) => ResultMake.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Count": count,
    "Message": message,
    "SearchCriteria": searchCriteria,
    "Results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class ResultMake {
  ResultMake({
    this.makeId,
    this.makeName,
    this.mfrId,
    this.mfrName,
  });

  int makeId;
  String makeName;
  int mfrId;
  String mfrName;

  factory ResultMake.fromJson(Map<String, dynamic> json) => ResultMake(
    makeId: json["MakeId"],
    makeName: json["MakeName"],
    mfrId: json["MfrId"],
    mfrName: json["MfrName"],
  );

  Map<String, dynamic> toJson() => {
    "MakeId": makeId,
    "MakeName": makeName,
    "MfrId": mfrId,
    "MfrName": mfrName,
  };
}
