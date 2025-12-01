part of 'exams_bloc.dart';

@immutable
sealed class ExamsState {}

final class ExamsInitialState extends ExamsState {}

final class ExamsLoadingState extends ExamsState {}

final class ExamsSuccessState extends ExamsState {}

final class ExamsGetSuccessState extends ExamsState {
  final List<Map<String, dynamic>> exams;

  ExamsGetSuccessState({required this.exams});
}

final class ExamsFailureState extends ExamsState {
  final String message;

  ExamsFailureState({this.message = apiErrorMessage});
}
