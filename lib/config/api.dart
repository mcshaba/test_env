import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:envision_test/config/http_manager.dart';
import 'package:envision_test/ocr/data/model/ocr_model.dart';

class Api {
  ///URL API
  static const String OCR = "/readDocument";

  ///OCR Generator api
  static Future<dynamic> ocrGenerator({File file}) async {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "photo": await MultipartFile.fromFile(file.path, filename: fileName),
    });
    final result = await httpManager.post(url: OCR, data: formData);

    return OcrModel.fromJson(result);
  }

  ///Singleton factory
  static final Api _instance = Api._internal();

  factory Api() {
    return _instance;
  }

  Api._internal();
}
