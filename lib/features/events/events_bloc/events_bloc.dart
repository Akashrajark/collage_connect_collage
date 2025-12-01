import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../util/file_upload.dart';
import '../../../values/strings.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc() : super(EventsInitialState()) {
    on<EventsEvent>((event, emit) async {
      try {
        emit(EventsLoadingState());
        SupabaseClient supabaseClient = Supabase.instance.client;

        SupabaseQueryBuilder table = Supabase.instance.client.from('events');
        SupabaseQueryBuilder registrationsTable = Supabase.instance.client.from('event_registrations');

        if (event is GetAllEventsEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
              table.select('*').eq('collage_user_id', supabaseClient.auth.currentUser!.id);

          if (event.params['query'] != null) {
            query = query.ilike('title', '%${event.params['query']}%');
          }

          List<Map<String, dynamic>> events = await query.order('title', ascending: true);

          emit(EventsGetSuccessState(events: events));
        } else if (event is AddEventEvent) {
          event.eventDetails['collage_user_id'] = supabaseClient.auth.currentUser?.id;
          event.eventDetails['image_url'] = await uploadFile(
            'events/image',
            event.eventDetails['image'],
            event.eventDetails['image_name'],
          );
          event.eventDetails.remove('image');
          event.eventDetails.remove('image_name');
          await table.insert(event.eventDetails);
          emit(EventsSuccessState());
        } else if (event is EditEventEvent) {
          if (event.eventDetails['image'] != null) {
            event.eventDetails['image_url'] = await uploadFile(
              'events/image',
              event.eventDetails['image'],
              event.eventDetails['image_name'],
            );
            event.eventDetails.remove('image');
            event.eventDetails.remove('image_name');
          }
          await table.update(event.eventDetails).eq('id', event.eventId);
          emit(EventsSuccessState());
        } else if (event is DeleteEventEvent) {
          await table.delete().eq('id', event.eventId);
          emit(EventsSuccessState());
        } else if (event is GetAllEventRegistrationsEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
              registrationsTable.select('*,students!inner(*)').eq('event_id', event.params['event_id']);

          if (event.params['query'] != null) {
            query = query.ilike(
              'students.name',
              '%${event.params['query']}%',
            );
          }

          List<Map<String, dynamic>> eventRegistrations = await query.order('id', ascending: true);

          emit(EventRegistrationsGetSuccessState(eventRegistrations: eventRegistrations));
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(EventsFailureState());
      }
    });
  }
}
