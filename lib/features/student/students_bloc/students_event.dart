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
  final String studentUserId;

  EditStudentEvent({
    required this.studentDetails,
    required this.studentUserId,
  });
}

class DeleteStudentEvent extends StudentsEvent {
  final String userId;

  DeleteStudentEvent({
    required this.userId,
  });
}

class GetStudentByCourseId extends StudentsEvent {
  final int courseId;

  GetStudentByCourseId({required this.courseId});
}
