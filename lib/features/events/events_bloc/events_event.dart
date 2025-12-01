part of 'events_bloc.dart';

@immutable
sealed class EventsEvent {}

class GetAllEventsEvent extends EventsEvent {
  final Map<String, dynamic> params;

  GetAllEventsEvent({required this.params});
}

class AddEventEvent extends EventsEvent {
  final Map<String, dynamic> eventDetails;

  AddEventEvent({required this.eventDetails});
}

class EditEventEvent extends EventsEvent {
  final Map<String, dynamic> eventDetails;
  final int eventId;

  EditEventEvent({
    required this.eventDetails,
    required this.eventId,
  });
}

class DeleteEventEvent extends EventsEvent {
  final int eventId;

  DeleteEventEvent({required this.eventId});
}

class GetAllEventRegistrationsEvent extends EventsEvent {
  final Map<String, dynamic> params;

  GetAllEventRegistrationsEvent({required this.params});
}
