part of 'ocr_bloc.dart';

// ignore: must_be_immutable
abstract class GetsOCRState extends Equatable {

  GetsOCRState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class GetOCRInitial extends GetsOCRState {
  GetOCRInitial() : super();
}


class EventFormUpdated extends GetsOCRState {
  EventFormUpdated(bookingForm) : super();
}

class OCRLoading extends GetsOCRState {
  OCRLoading() : super();


  @override
  List<Object> get props => [];
}
class OCRListLoading extends GetsOCRState {
  OCRListLoading() : super();


  @override
  List<Object> get props => [];
}

class SaveLoading extends GetsOCRState {
  SaveLoading() : super();


  @override
  List<Object> get props => [];
}

class EventFormSaveFailure extends GetsOCRState {
  final String message;

  EventFormSaveFailure(this.message ) : super();

  @override
  List<Object> get props => [message];
}

class EventSuccessful extends GetsOCRState {
  final response;

  EventSuccessful( this.response) : super();

  @override
  List<Object> get props => [response];

}
class EventListSuccessful extends GetsOCRState {
  final response;

  EventListSuccessful( this.response) : super();

  @override
  List<Object> get props => [response];

}
// ignore: must_be_immutable
class EventDeletedSuccessful extends GetsOCRState {
  final response;

  EventDeletedSuccessful( this.response) : super();

  @override
  List<Object> get props => [response];

}
// ignore: must_be_immutable
class EventSavedSuccessful extends GetsOCRState {
  final response;

  EventSavedSuccessful( this.response) : super();

  @override
  List<Object> get props => [response];

}
