import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../values/strings.dart';

part 'subjects_event.dart';
part 'subjects_state.dart';

class SubjectsBloc extends Bloc<SubjectsEvent, SubjectsState> {
  SubjectsBloc() : super(SubjectsInitialState()) {
    on<SubjectsEvent>((event, emit) async {
      try {
        emit(SubjectsLoadingState());
        SupabaseClient supabaseClient = Supabase.instance.client;

        SupabaseQueryBuilder table = supabaseClient.from('subjects');
        if (event is GetAllSubjectsEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
              table.select('*').eq('course_id', event.params['course_id']);

          if (event.params['query'] != null) {
            query = query.ilike('name', '%${event.params['query']}%');
          }

          List<Map<String, dynamic>> subjects = await query.order('name', ascending: true);

          emit(SubjectsGetSuccessState(subjects: subjects));
        } else if (event is AddSubjectEvent) {
          await table.insert(event.subjectDetails);
          emit(SubjectsSuccessState());
        } else if (event is EditSubjectEvent) {
          await table.update(event.subjectDetails).eq('id', event.subjectId);
          emit(SubjectsSuccessState());
        } else if (event is DeleteSubjectEvent) {
          await table.delete().eq('id', event.subjectId);
          emit(SubjectsSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(SubjectsFailureState());
      }
    });
  }
}
