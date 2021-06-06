import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:envision_test/ocr/data/model/save_ocr.dart';
import 'package:envision_test/ocr/data/model/ocr_model.dart';
import 'package:envision_test/ocr/domain/repository/ocr_repository.dart';
import 'package:equatable/equatable.dart';

import 'dart:io';

import 'package:meta/meta.dart';

part 'ocr_event.dart';

part 'ocr_state.dart';

class OCRBloc extends Bloc<OCREvent, OCRState> {
  OcrModel bookingForm;

  OCRBloc(OCRState initial) : super(initial);

  @override
  Stream<OCRState> mapEventToState(
    OCREvent event,
  ) async* {
    if (event is OcrEvent) {
      yield* _mapOCRToState(event.file);
    }

    ///Initialize the Event Bloc
    else if (event is InitializeEvent) {
      yield OCRInitial();
    }

    ///Saving Event Bloc
    else if (event is SaveLocalOCREvent) {
      yield* _mapSaveLocalEventToState(event.model);
    }


  }

  Stream<OCRState> _mapSaveLocalEventToState(SaveOcrModel bookingForm) async* {
    yield SaveLoading();

    ///Fetch API
    final result =
        await OCRRepository.saveDraftLocalDBEvent(model: bookingForm);

    ///Case API fail but not have token
    if (result is num) {
      yield EventSavedSuccessful(result);
    } else {
      ///Notify loading to UI
      yield EventFormSaveFailure(result.message);
    }
  }

  Stream<OCRState> _mapOCRToState(File filePath) async* {
    yield OCRLoading();

    ///Fetch API
    final OcrModel result = await OCRRepository.cCRGenerator(file: filePath);

    ///Case API fail but not have token
    if (result != null) {
      String ocrString = stringify(result);
      yield EventSuccessful(ocrString);

    } else {
      ///Notify loading to UI
      yield EventFormSaveFailure(
        "Failed to retrieve date from database",
      );
    }
  }

  String stringify(OcrModel result) {
    String data = "";
    for (Paragraph paragraph in result.response.paragraphs) {
      data += "${paragraph.paragraph} ";
    }
    return data;
  }
}
