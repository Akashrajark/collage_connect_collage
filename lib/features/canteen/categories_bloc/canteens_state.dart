part of 'canteens_bloc.dart';

@immutable
sealed class CanteensState {}

final class CanteensInitialState extends CanteensState {}

final class CanteensLoadingState extends CanteensState {}

final class CanteensSuccessState extends CanteensState {}

final class CanteensGetSuccessState extends CanteensState {
  final List<Map<String, dynamic>> canteens;

  CanteensGetSuccessState({required this.canteens});
}

final class CanteensFailureState extends CanteensState {
  final String message;

  CanteensFailureState({this.message = apiErrorMessage});
}
