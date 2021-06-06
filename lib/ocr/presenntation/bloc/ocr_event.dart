part of 'ocr_bloc.dart';


@immutable
abstract class OCREvent extends Equatable {
  const OCREvent();

  @override
  List<Object> get props => [];
}

class OcrEvent extends OCREvent {
  final File file;

  OcrEvent(this.file) : super();
}
class InitializeEvent extends OCREvent {

  InitializeEvent() : super();
}

class SaveLocalOCREvent extends OCREvent {
  final SaveOcrModel model;

  SaveLocalOCREvent(this.model) : super();
}



