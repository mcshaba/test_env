// To parse this JSON data, do
//
//     final errorResponse = errorResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ErrorResponse errorResponseFromJson(Map<String,dynamic> str) => ErrorResponse.fromJson(str);

String errorResponseToJson(ErrorResponse data) => json.encode(data.toJson());

class ErrorResponse {
  ErrorResponse({
    @required this.message,
  });

  final String message;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
  };
}
