import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../util/file_upload.dart';
import '../../../values/strings.dart';

part 'students_event.dart';
part 'students_state.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  StudentsBloc() : super(StudentsInitialState()) {
    on<StudentsEvent>((event, emit) async {
      try {
        emit(StudentsLoadingState());
        SupabaseClient supabaseClient = Supabase.instance.client;

        SupabaseQueryBuilder table = Supabase.instance.client.from('customers');

        if (event is GetAllStudentsEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query =
              table.select('*');

          if (event.params['query'] != null) {
            query = query.ilike('name', '%${event.params['query']}%');
          }

          List<Map<String, dynamic>> students =
              await query.order('name', ascending: true);

          emit(StudentsGetSuccessState(students: students));
        } else if (event is AddStudentEvent) {
          final response = await supabaseClient.auth.admin.createUser(
            AdminUserAttributes(
              email: event.studentDetails['email'],
              password: event.studentDetails['password'],
              emailConfirm: true,
              appMetadata: {"role": "student"},
            ),
          );
          event.studentDetails['user_id'] = response.user!.id;
          event.studentDetails.remove('password');

          event.studentDetails['image_url'] = await uploadFile(
            'students/image',
            event.studentDetails['image'],
            event.studentDetails['image_name'],
          );
          event.studentDetails.remove('image');
          event.studentDetails.remove('image_name');

          await table.insert(event.studentDetails);

          emit(StudentsSuccessState());
        } else if (event is EditStudentEvent) {
          event.studentDetails.remove('password');
          event.studentDetails.remove('email');

          if (event.studentDetails['image'] != null) {
            event.studentDetails['image_url'] = await uploadFile(
              'students/image',
              event.studentDetails['image'],
              event.studentDetails['image_name'],
            );
            event.studentDetails.remove('image');
            event.studentDetails.remove('image_name');
          }
          await table.update(event.studentDetails).eq('id', event.studentId);

          emit(StudentsSuccessState());
        } else if (event is DeleteStudentEvent) {
          await table.delete().eq('id', event.studentId);
          emit(StudentsSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(StudentsFailureState());
      }
    });
  }
}
