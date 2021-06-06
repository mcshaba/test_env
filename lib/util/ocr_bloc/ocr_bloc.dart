import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:envision_test/ocr/data/model/save_ocr.dart';
import 'package:envision_test/ocr/data/model/ocr_model.dart';
import 'package:envision_test/ocr/domain/repository/ocr_repository.dart';
import 'package:equatable/equatable.dart';

import 'package:meta/meta.dart';

part 'ocr_event.dart';

part 'ocr_state.dart';

class GetOCRBloc extends Bloc<GetsOCREvent, GetsOCRState> {
  OcrModel bookingForm;

  GetOCRBloc(GetsOCRState initial) : super(initial);

  @override
  Stream<GetsOCRState> mapEventToState(
      GetsOCREvent event,
  ) async* {
    ///Delete Event Bloc
    if (event is DeleteEvent) {
      yield* _mapDeleteEventToState(event.model);
    } else if (event is GetSavedEvent) {
      yield* _mapGetSaveEventToState();
    }
  }

  Stream<GetsOCRState> _mapDeleteEventToState(SaveOcrModel bookingForm) async* {
    yield OCRLoading();

    ///Fetch API
    final result = await OCRRepository.deleteEvent(model: bookingForm);

    ///Case API fail but not have token
    if (result is num) {
      yield EventDeletedSuccessful(result);
    } else {
      ///Notify loading to UI
      yield EventFormSaveFailure(result.message);
    }
  }

  Stream<GetsOCRState> _mapGetSaveEventToState() async* {
    yield OCRListLoading();

    ///Fetch API
    final List<SaveOcrModel> result = await OCRRepository.getEvent();

    ///Case API fail but not have token
    if (result != null) {
      yield EventListSuccessful(result);
    } else {
      ///Notify loading to UI
      yield EventFormSaveFailure("Failed to retrieve date from database");
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
