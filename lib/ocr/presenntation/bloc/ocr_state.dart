part of 'ocr_bloc.dart';

// ignore: must_be_immutable
abstract class OCRState extends Equatable {

  OCRState();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class OCRInitial extends OCRState {
  OCRInitial() : super();
}

class EventFormUpdated extends OCRState {
  EventFormUpdated(bookingForm) : super();
}

class OCRLoading extends OCRState {
  OCRLoading() : super();


  @override
  List<Object> get props => [];
}
class OCRListLoading extends OCRState {
  OCRListLoading() : super();


  @override
  List<Object> get props => [];
}

class SaveLoading extends OCRState {
  SaveLoading() : super();


  @override
  List<Object> get props => [];
}

class EventFormSaveFailure extends OCRState {
  final String message;

  EventFormSaveFailure(this.message ) : super();

  @override
  List<Object> get props => [message];
}

class EventSuccessful extends OCRState {
  final response;

  EventSuccessful( this.response) : super();

  @override
  List<Object> get props => [response];

}
class EventListSuccessful extends OCRState {
  final response;

  EventListSuccessful( this.response) : super();

  @override
  List<Object> get props => [response];

}
// ignore: must_be_immutable
class EventDeletedSuccessful extends OCRState {
  final response;

  EventDeletedSuccessful( this.response) : super();

  @override
  List<Object> get props => [response];

}
// ignore: must_be_immutable
class EventSavedSuccessful extends OCRState {
  final response;

  EventSavedSuccessful( this.response) : super();

  @override
  List<Object> get props => [response];

}
