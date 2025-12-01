part of 'results_bloc.dart';

@immutable
sealed class ResultsEvent {}

class GetAllResultsEvent extends ResultsEvent {
  final Map<String, dynamic> params;

  GetAllResultsEvent({required this.params});
}

class AddResultEvent extends ResultsEvent {
  final Map<String, dynamic> resultDetails;

  AddResultEvent({required this.resultDetails});
}

class EditResultEvent extends ResultsEvent {
  final Map<String, dynamic> resultDetails;
  final int resultId;

  EditResultEvent({
    required this.resultDetails,
    required this.resultId,
  });
}

class DeleteResultEvent extends ResultsEvent {
  final int resultId;

  DeleteResultEvent({required this.resultId});
}
