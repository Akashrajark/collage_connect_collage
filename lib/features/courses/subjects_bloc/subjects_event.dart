part of 'subjects_bloc.dart';

@immutable
sealed class SubjectsEvent {}

class GetAllSubjectsEvent extends SubjectsEvent {
  final Map<String, dynamic> params;

  GetAllSubjectsEvent({required this.params});
}

class AddSubjectEvent extends SubjectsEvent {
  final Map<String, dynamic> subjectDetails;

  AddSubjectEvent({required this.subjectDetails});
}

class EditSubjectEvent extends SubjectsEvent {
  final Map<String, dynamic> subjectDetails;
  final int subjectId;

  EditSubjectEvent({
    required this.subjectDetails,
    required this.subjectId,
  });
}

class DeleteSubjectEvent extends SubjectsEvent {
  final int subjectId;

  DeleteSubjectEvent({required this.subjectId});
}
