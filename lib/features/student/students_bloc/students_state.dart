part of 'students_bloc.dart';

@immutable
sealed class StudentsState {}

final class StudentsInitialState extends StudentsState {}

final class StudentsLoadingState extends StudentsState {}

final class StudentsSuccessState extends StudentsState {}

final class StudentsGetSuccessState extends StudentsState {
  final List<Map<String, dynamic>> students;

  StudentsGetSuccessState({required this.students});
}

final class StudentsFailureState extends StudentsState {
  final String message;

  StudentsFailureState({this.message = apiErrorMessage});
}
