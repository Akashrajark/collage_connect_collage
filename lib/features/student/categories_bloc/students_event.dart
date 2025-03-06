part of 'students_bloc.dart';

@immutable
sealed class StudentsEvent {}

class GetAllStudentsEvent extends StudentsEvent {
  final Map<String, dynamic> params;

  GetAllStudentsEvent({required this.params});
}

class AddStudentEvent extends StudentsEvent {
  final Map<String, dynamic> studentDetails;

  AddStudentEvent({required this.studentDetails});
}

class EditStudentEvent extends StudentsEvent {
  final Map<String, dynamic> studentDetails;
  final int studentId;

  EditStudentEvent({
    required this.studentDetails,
    required this.studentId,
  });
}

class DeleteStudentEvent extends StudentsEvent {
  final int studentId;

  DeleteStudentEvent({required this.studentId});
}
