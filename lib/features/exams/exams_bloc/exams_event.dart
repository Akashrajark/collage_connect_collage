part of 'exams_bloc.dart';

@immutable
sealed class ExamsEvent {}

class GetAllExamsEvent extends ExamsEvent {
  final Map<String, dynamic> params;

  GetAllExamsEvent({required this.params});
}

class AddExamEvent extends ExamsEvent {
  final Map<String, dynamic> examDetails;

  AddExamEvent({required this.examDetails});
}

class EditExamEvent extends ExamsEvent {
  final Map<String, dynamic> examDetails;
  final int examId;

  EditExamEvent({
    required this.examDetails,
    required this.examId,
  });
}

class DeleteExamEvent extends ExamsEvent {
  final int examId;

  DeleteExamEvent({required this.examId});
}
