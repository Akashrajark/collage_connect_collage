import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:collage_connect_collage/common_widget/custom_dropdownmenu.dart';
import 'package:collage_connect_collage/common_widget/custom_text_formfield.dart';
import 'package:collage_connect_collage/util/value_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';
import '../student/students_bloc/students_bloc.dart';
import 'results_bloc/results_bloc.dart';

class AddResult extends StatefulWidget {
  final Map? resultDetails;
  final int examId, courseId;
  const AddResult({
    super.key,
    this.resultDetails,
    required this.examId,
    required this.courseId,
  });

  @override
  State<AddResult> createState() => _AddResultState();
}

class _AddResultState extends State<AddResult> {
  final _noteController = TextEditingController();
  final _markController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getStudents();
    if (widget.resultDetails != null) {
      _noteController.text = widget.resultDetails!['note'] ?? '';
      _markController.text = widget.resultDetails!['mark']?.toString() ?? '';
      studentID = widget.resultDetails!['student_user_id'];
    }
    super.initState();
  }

  final StudentsBloc _studentsBloc = StudentsBloc();

  List<Map> _students = [];

  String? studentID;

  void getStudents() {
    _studentsBloc.add(GetStudentByCourseId(courseId: widget.courseId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _studentsBloc,
      child: BlocConsumer<StudentsBloc, StudentsState>(
        listener: (context, state) {
          if (state is StudentsFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getStudents();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is CourseStudentGetSuccessState) {
            _students = state.students;
            Logger().w(_students);
            setState(() {});
          } else if (state is StudentsSuccessState) {
            getStudents();
          }
        },
        builder: (context, state) {
          return BlocConsumer<ResultsBloc, ResultsState>(
            listener: (context, state) {
              if (state is ResultsSuccessState) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              return CustomAlertDialog(
                title: widget.resultDetails == null ? 'Add Result' : 'Edit Result',
                isLoading: state is ResultsLoadingState,
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropDownMenu(
                        selectedValue: studentID,
                        hintText: "Select Student",
                        title: "Student",
                        dropdownMenuItems: List.generate(
                            _students.length,
                            (index) => DropdownMenuItem(
                                  value: _students[index]['user_id'],
                                  child: Text(_students[index]['name'] ?? 'No Name'),
                                )),
                        onSelected: (value) {
                          studentID = value;
                          setState(() {});
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Mark',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        labelText: 'Enter mark',
                        controller: _markController,
                        validator: notEmptyValidator,
                        isLoading: false,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Note',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      CustomTextFormField(
                        labelText: 'Enter note',
                        minLines: 3,
                        maxLines: 3,
                        controller: _noteController,
                        validator: notEmptyValidator,
                        isLoading: false,
                      ),
                    ],
                  ),
                ),
                primaryButton: 'save',
                onPrimaryPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> details = {
                      'mark': int.parse(_markController.text.trim()),
                      'note': _noteController.text.trim(),
                      'exam_id': widget.examId,
                      'student_user_id': studentID,
                    };

                    if (widget.resultDetails != null) {
                      BlocProvider.of<ResultsBloc>(context).add(
                        EditResultEvent(
                          resultId: widget.resultDetails!['id'],
                          resultDetails: details,
                        ),
                      );
                    } else {
                      BlocProvider.of<ResultsBloc>(context).add(
                        AddResultEvent(
                          resultDetails: details,
                        ),
                      );
                    }
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
