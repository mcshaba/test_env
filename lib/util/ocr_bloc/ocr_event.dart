part of 'ocr_bloc.dart';


@immutable
abstract class GetsOCREvent extends Equatable {
  const GetsOCREvent();

  @override
  List<Object> get props => [];
}


class DeleteEvent extends GetsOCREvent {
  final SaveOcrModel model;

  DeleteEvent(this.model) : super();
}


class GetSavedEvent extends GetsOCREvent {

  GetSavedEvent() : super();
}


