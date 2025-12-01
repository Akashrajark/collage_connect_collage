import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../values/strings.dart';

part 'results_event.dart';
part 'results_state.dart';

class ResultsBloc extends Bloc<ResultsEvent, ResultsState> {
  ResultsBloc() : super(ResultsInitialState()) {
    on<ResultsEvent>((event, emit) async {
      try {
        emit(ResultsLoadingState());
        SupabaseClient supabaseClient = Supabase.instance.client;

        SupabaseQueryBuilder table = supabaseClient.from('exam_results');
        if (event is GetAllResultsEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
              table.select('*,students!inner(*)').eq('exam_id', event.params['exam_id']);

          if (event.params['query'] != null) {
            query = query.ilike('students.name', '%${event.params['query']}%');
          }

          List<Map<String, dynamic>> results = await query.order('id', ascending: true);

          emit(ResultsGetSuccessState(results: results));
        } else if (event is AddResultEvent) {
          await table.insert(event.resultDetails);
          emit(ResultsSuccessState());
        } else if (event is EditResultEvent) {
          await table.update(event.resultDetails).eq('id', event.resultId);
          emit(ResultsSuccessState());
        } else if (event is DeleteResultEvent) {
          await table.delete().eq('id', event.resultId);
          emit(ResultsSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(ResultsFailureState());
      }
    });
  }
}
