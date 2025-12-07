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

        SupabaseQueryBuilder table = Supabase.instance.client.from('canteens');

        if (event is GetAllCanteensEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
              table.select('*').eq('collage_user_id', supabaseClient.auth.currentUser!.id);

          if (event.params['query'] != null) {
            query = query.ilike('name', '%${event.params['query']}%');
          }

          List<Map<String, dynamic>> canteens = await query.order('name', ascending: true);

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
          event.canteenDetails['collage_user_id'] = supabaseClient.auth.currentUser?.id;
          event.canteenDetails.remove('password');

          event.canteenDetails['user_id'] = response.user?.id;
          event.canteenDetails['image_url'] = await uploadFile(
            'petstores/image',
            event.canteenDetails['image'],
            event.canteenDetails['image_name'],
          );
          event.canteenDetails.remove('image');
          event.canteenDetails.remove('image_name');

          await table.insert(event.canteenDetails);

          emit(CanteensSuccessState());
        } else if (event is EditCanteenEvent) {
          await supabaseClient.auth.admin.updateUserById(event.canteenUserId,
              attributes: AdminUserAttributes(
                email: event.canteenDetails['email'],
                password: event.canteenDetails['password'],
                emailConfirm: true,
                appMetadata: {"role": "canteen"},
              ));
          event.canteenDetails.remove('password');
          if (event.canteenDetails['image'] != null) {
            event.canteenDetails['image_url'] = await uploadFile(
              'petstores/image',
              event.canteenDetails['image'],
              event.canteenDetails['image_name'],
            );
            event.canteenDetails.remove('image');
            event.canteenDetails.remove('image_name');
          }

          await table.update(event.canteenDetails).eq('user_id', event.canteenUserId);

          emit(CanteensSuccessState());
        } else if (event is DeleteCanteenEvent) {
          await supabaseClient.auth.admin.deleteUser(event.userId);
          emit(CanteensSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(CanteensFailureState());
      }
    });
  }
}
