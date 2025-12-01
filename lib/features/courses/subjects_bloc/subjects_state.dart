part of 'subjects_bloc.dart';

@immutable
sealed class SubjectsState {}

final class SubjectsInitialState extends SubjectsState {}

final class SubjectsLoadingState extends SubjectsState {}

final class SubjectsSuccessState extends SubjectsState {}

final class SubjectsGetSuccessState extends SubjectsState {
  final List<Map<String, dynamic>> subjects;

  SubjectsGetSuccessState({required this.subjects});
}

final class SubjectsFailureState extends SubjectsState {
  final String message;

  SubjectsFailureState({this.message = apiErrorMessage});
}
