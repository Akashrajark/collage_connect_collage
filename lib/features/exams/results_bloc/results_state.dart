part of 'results_bloc.dart';

@immutable
sealed class ResultsState {}

final class ResultsInitialState extends ResultsState {}

final class ResultsLoadingState extends ResultsState {}

final class ResultsSuccessState extends ResultsState {}

final class ResultsGetSuccessState extends ResultsState {
  final List<Map<String, dynamic>> results;

  ResultsGetSuccessState({required this.results});
}

final class ResultsFailureState extends ResultsState {
  final String message;

  ResultsFailureState({this.message = apiErrorMessage});
}
