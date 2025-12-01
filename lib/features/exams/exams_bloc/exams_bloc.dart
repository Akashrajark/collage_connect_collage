import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../values/strings.dart';

part 'exams_event.dart';
part 'exams_state.dart';

class ExamsBloc extends Bloc<ExamsEvent, ExamsState> {
  ExamsBloc() : super(ExamsInitialState()) {
    on<ExamsEvent>((event, emit) async {
      try {
        emit(ExamsLoadingState());
        SupabaseClient supabaseClient = Supabase.instance.client;

        SupabaseQueryBuilder table = Supabase.instance.client.from('exams');
        if (event is GetAllExamsEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
              table.select('*,courses(name),subjects(name)').eq('collage_user_id', supabaseClient.auth.currentUser!.id);

          if (event.params['query'] != null) {
            query = query.ilike('type', '%${event.params['query']}%');
          }

          List<Map<String, dynamic>> exams = await query.order('id', ascending: true);

          emit(ExamsGetSuccessState(exams: exams));
        } else if (event is AddExamEvent) {
          event.examDetails['collage_user_id'] = supabaseClient.auth.currentUser?.id;
          await table.insert(event.examDetails);
          emit(ExamsSuccessState());
        } else if (event is EditExamEvent) {
          await table.update(event.examDetails).eq('id', event.examId);
          emit(ExamsSuccessState());
        } else if (event is DeleteExamEvent) {
          await table.delete().eq('id', event.examId);
          emit(ExamsSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(ExamsFailureState());
      }
    });
  }
}
