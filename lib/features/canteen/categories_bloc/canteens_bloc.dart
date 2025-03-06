import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../util/file_upload.dart';
import '../../../values/strings.dart';

part 'canteens_event.dart';
part 'canteens_state.dart';

class CanteensBloc extends Bloc<CanteensEvent, CanteensState> {
  CanteensBloc() : super(CanteensInitialState()) {
    on<CanteensEvent>((event, emit) async {
      try {
        emit(CanteensLoadingState());
        SupabaseClient supabaseClient = Supabase.instance.client;

        SupabaseQueryBuilder table = Supabase.instance.client.from('shops');

        if (event is GetAllCanteensEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
              table.select('*');

          if (event.params['query'] != null) {
            query = query.ilike('name', '%${event.params['query']}%');
          }

          List<Map<String, dynamic>> canteens =
              await query.order('name', ascending: true);

          emit(CanteensGetSuccessState(canteens: canteens));
        } else if (event is AddCanteenEvent) {
          final response = await supabaseClient.auth.admin.createUser(
            AdminUserAttributes(
              email: event.canteenDetails['email'],
              password: event.canteenDetails['password'],
              emailConfirm: true,
              appMetadata: {"role": "canteen"},
            ),
          );
          event.canteenDetails['user_id'] = response.user!.id;
          event.canteenDetails.remove('password');

          await table.insert(event.canteenDetails);

          emit(CanteensSuccessState());
        } else if (event is EditCanteenEvent) {
          event.canteenDetails.remove('password');
          event.canteenDetails.remove('email');

          await table.update(event.canteenDetails).eq('id', event.canteenId);

          emit(CanteensSuccessState());
        } else if (event is DeleteCanteenEvent) {
          await table.delete().eq('id', event.canteenId);
          emit(CanteensSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(CanteensFailureState());
      }
    });
  }
}
