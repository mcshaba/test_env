
import 'dart:io';

import 'package:envision_test/config/api.dart';
import 'package:envision_test/ocr/data/database.dart';
import 'package:envision_test/ocr/data/model/save_ocr.dart';

class OCRRepository {



  ///Get all saved event
  static Future<dynamic> getEvent() async {
    final result = await db.getEventFromDb();
    return result;
  }
  ///Get all saved event
  static Future<dynamic> cCRGenerator({File file}) async {
    return Api.ocrGenerator(file: file);
  }

  ///Save Draft Event to Local device
  static Future<dynamic> saveDraftLocalDBEvent({SaveOcrModel model}) async {
    final result = await db.addEventsToDb(model);
    return result;
  }

  ///Delete saved Draft event
  static Future<dynamic> deleteEvent({SaveOcrModel model}) async {
    final result = await db.deleteEvent(model);
    return result;
  }
}