part of 'events_bloc.dart';

@immutable
sealed class EventsState {}

final class EventsInitialState extends EventsState {}

final class EventsLoadingState extends EventsState {}

final class EventsSuccessState extends EventsState {}

final class EventsGetSuccessState extends EventsState {
  final List<Map<String, dynamic>> events;

  EventsGetSuccessState({required this.events});
}

final class EventsFailureState extends EventsState {
  final String message;

  EventsFailureState({this.message = apiErrorMessage});
}

final class EventRegistrationsGetSuccessState extends EventsState {
  final List<Map<String, dynamic>> eventRegistrations;

  EventRegistrationsGetSuccessState({required this.eventRegistrations});
}
