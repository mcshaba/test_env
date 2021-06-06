// To parse this JSON data, do
//
//     final ocrModel = ocrModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

OcrModel ocrModelFromJson(Map<String,dynamic> str) => OcrModel.fromJson(str);

String ocrModelToJson(OcrModel data) => json.encode(data.toJson());

class OcrModel {
  OcrModel({
    @required this.response, this.id, this.date,this.message,
  });

  Response response;
  int id;
  DateTime date;
  String message;


  factory OcrModel.fromJson(Map<String, dynamic> json) => OcrModel(
    response: json["response"] == null ? null : Response.fromJson(json["response"]),
    message: json["message"] == null ? null : json["message"],

  );

  Map<String, dynamic> toJson() => {
    "response": response == null ? null : response.toJson(),
    "message": message == null ? null : message,

  };

  @override
  String toString() {
    return 'OcrModel{response: $response}';
  }
}

class Response {
  Response({
    @required this.paragraphs, this.id
  });

  final List<Paragraph> paragraphs;
  final int id;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    paragraphs: json["paragraphs"] == null ? null : List<Paragraph>.from(json["paragraphs"].map((x) => Paragraph.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "paragraphs": paragraphs == null ? null : List<dynamic>.from(paragraphs.map((x) => x.toJson())),
  };
}

class Paragraph {
  Paragraph({
    @required this.paragraph,
    @required this.language,
  });

  final String paragraph;
  final String language;

  factory Paragraph.fromJson(Map<String, dynamic> json) => Paragraph(
    paragraph: json["paragraph"] == null ? null : json["paragraph"],
    language: json["language"] == null ? null : json["language"],
  );

  Map<String, dynamic> toJson() => {
    "paragraph": paragraph == null ? null : paragraph,
    "language": language == null ? null : language,
  };
}
