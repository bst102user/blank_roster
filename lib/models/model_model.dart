// To parse this JSON data, do
//
//     final modelModel = modelModelFromJson(jsonString);

import 'dart:convert';

ModelModel modelModelFromJson(String str) => ModelModel.fromJson(json.decode(str));

String modelModelToJson(ModelModel data) => json.encode(data.toJson());

class ModelModel {
  ModelModel({
    this.count,
    this.message,
    this.searchCriteria,
    this.results,
  });

  int count;
  String message;
  String searchCriteria;
  List<ResultModel> results;

  factory ModelModel.fromJson(Map<String, dynamic> json) => ModelModel(
    count: json["Count"],
    message: json["Message"],
    searchCriteria: json["SearchCriteria"],
    results: List<ResultModel>.from(json["Results"].map((x) => ResultModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Count": count,
    "Message": message,
    "SearchCriteria": searchCriteria,
    "Results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class ResultModel {
  ResultModel({
    this.makeId,
    this.makeName,
    this.modelId,
    this.modelName,
  });

  int makeId;
  String makeName;
  int modelId;
  String modelName;

  factory ResultModel.fromJson(Map<String, dynamic> json) => ResultModel(
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
