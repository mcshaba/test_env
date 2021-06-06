// To parse this JSON data, do
//
//     final saveOcrModel = saveOcrModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

SaveOcrModel saveOcrModelFromJson(Map<String,dynamic> str) => SaveOcrModel.fromJson(str);

String saveOcrModelToJson(SaveOcrModel data) => json.encode(data.toJson());

class SaveOcrModel {
  SaveOcrModel({
    @required this.message,
    @required this.timestamp,
    @required this.id,
  });

  final String message;
  final DateTime timestamp;
  int id;



  factory SaveOcrModel.fromJson(Map<String, dynamic> json) => SaveOcrModel(
    message: json["message"] == null ? null : json["message"],
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "timestamp": timestamp == null ? null : timestamp.toIso8601String(),
  };
}
