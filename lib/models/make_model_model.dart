// To parse this JSON data, do
//
//     final makeModelModel = makeModelModelFromJson(jsonString);

import 'dart:convert';

MakeModelModel makeModelModelFromJson(String str) => MakeModelModel.fromJson(json.decode(str));

String makeModelModelToJson(MakeModelModel data) => json.encode(data.toJson());

class MakeModelModel {
  MakeModelModel({
    this.count,
    this.message,
    this.searchCriteria,
    this.results,
  });

  int count;
  String message;
  String searchCriteria;
  List<Result> results;

  factory MakeModelModel.fromJson(Map<String, dynamic> json) => MakeModelModel(
    count: json["Count"],
    message: json["Message"],
    searchCriteria: json["SearchCriteria"],
    results: List<Result>.from(json["Results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Count": count,
    "Message": message,
    "SearchCriteria": searchCriteria,
    "Results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Result {
  Result({
    this.makeId,
    this.makeName,
    this.modelId,
    this.modelName,
  });

  int makeId;
  String makeName;
  int modelId;
  String modelName;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    makeId: json["Make_ID"],
    makeName: json["Make_Name"],
    modelId: json["Model_ID"],
    modelName: json["Model_Name"],
  );

  Map<String, dynamic> toJson() => {
    "Make_ID": makeId,
    "Make_Name": makeName,
    "Model_ID": modelId,
    "Model_Name": modelName,
  };
}
