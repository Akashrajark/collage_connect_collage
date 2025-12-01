import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:collage_connect_collage/common_widget/custom_date_picker.dart';
import 'package:collage_connect_collage/common_widget/custom_dropdownmenu.dart';
import 'package:collage_connect_collage/common_widget/custom_text_formfield.dart';
import 'package:collage_connect_collage/common_widget/custom_time_picker.dart';
import 'package:collage_connect_collage/features/courses/courses_bloc/courses_bloc.dart';
import 'package:collage_connect_collage/features/courses/subjects_bloc/subjects_bloc.dart';
import 'package:collage_connect_collage/util/value_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'exams_bloc/exams_bloc.dart';

class AddExam extends StatefulWidget {
  final Map? examDetails;
  const AddExam({
    super.key,
    this.examDetails,
  });

  @override
  State<AddExam> createState() => _AddExamState();
}

class _AddExamState extends State<AddExam> {
  final _typeController = TextEditingController();
  final _totalMarkController = TextEditingController();
  final _descriptionController = TextEditingController();

  int? _courseId;
  int? _subjectId;
  DateTime? _examDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final CoursesBloc _coursesBloc = CoursesBloc();
  final SubjectsBloc _subjectsBloc = SubjectsBloc();

  List _courses = [];
  List _subjects = [];

  @override
  void initState() {
    getCourses();
    if (widget.examDetails != null) {
      _typeController.text = widget.examDetails!['type'];
      _totalMarkController.text = widget.examDetails!['total_mark'].toString();
      _descriptionController.text = widget.examDetails!['description'];
      _courseId = widget.examDetails!['course_id'];
      _subjectId = widget.examDetails!['subject_id'];
      if (widget.examDetails!['date'] != null) {
        _examDate = DateTime.parse(widget.examDetails!['date']);
      }
      if (widget.examDetails!['start_time'] != null) {
        final timeParts = widget.examDetails!['start_time'].split(':');
        _startTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
      }
      if (widget.examDetails!['end_time'] != null) {
        final timeParts = widget.examDetails!['end_time'].split(':');
        _endTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
      }
      if (_courseId != null) {
        getSubjects(_courseId!);
      }
    }
    super.initState();
  }

  void getCourses() {
    _coursesBloc.add(GetAllCoursesEvent(params: {}));
  }

  void getSubjects(int courseId) {
    _subjectsBloc.add(GetAllSubjectsEvent(params: {'course_id': courseId}));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _coursesBloc,
      child: BlocConsumer<CoursesBloc, CoursesState>(
        listener: (context, state) {
          if (state is CoursesFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getCourses();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is CoursesGetSuccessState) {
            _courses = state.courses;
            setState(() {});
          }
        },
        builder: (context, courseState) {
          return BlocProvider.value(
            value: _subjectsBloc,
            child: BlocConsumer<SubjectsBloc, SubjectsState>(
              listener: (context, state) {
                if (state is SubjectsFailureState) {
                  showDialog(
                    context: context,
                    builder: (context) => CustomAlertDialog(
                      title: 'Failure',
                      description: state.message,
                      primaryButton: 'Try Again',
                      onPrimaryPressed: () {
                        if (_courseId != null) {
                          getSubjects(_courseId!);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  );
                } else if (state is SubjectsGetSuccessState) {
                  _subjects = state.subjects;
                  setState(() {});
                }
              },
              builder: (context, subjectState) {
                return BlocConsumer<ExamsBloc, ExamsState>(
                  listener: (context, state) {
                    if (state is ExamsSuccessState) {
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state) {
                    return CustomAlertDialog(
                      title: widget.examDetails == null ? 'Add Exam' : 'Edit Exam',
                      isLoading: state is ExamsLoadingState,
                      content: Flexible(
                        child: Form(
                          key: _formKey,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              CustomDropDownMenu(
                                title: 'Course',
                                selectedValue: _courseId,
                                hintText: "Select Course",
                                isRequired: true,
                                dropdownMenuItems: List.generate(_courses.length, (index) {
                                  return DropdownMenuItem(
                                    value: _courses[index]['id'],
                                    child: Text(_courses[index]['name']),
                                  );
                                }),
                                onSelected: (value) {
                                  _courseId = value;
                                  _subjectId = null;
                                  if (value != null) {
                                    getSubjects(value);
                                  }
                                  setState(() {});
                                },
                              ),
                              const SizedBox(height: 20),
                              CustomDropDownMenu(
                                title: 'Subject',
                                selectedValue: _subjectId,
                                hintText: "Select Subject",
                                isRequired: true,
                                dropdownMenuItems: List.generate(_subjects.length, (index) {
                                  return DropdownMenuItem(
                                    value: _subjects[index]['id'],
                                    child: Text(_subjects[index]['name']),
                                  );
                                }),
                                onSelected: (value) {
                                  _subjectId = value;
                                  setState(() {});
                                },
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Exam Type',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 8),
                              CustomTextFormField(
                                labelText: 'Enter exam type',
                                controller: _typeController,
                                validator: notEmptyValidator,
                                isLoading: false,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Total Marks',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 8),
                              CustomTextFormField(
                                labelText: 'Enter total marks',
                                controller: _totalMarkController,
                                validator: notEmptyValidator,
                                isLoading: false,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Description',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 8),
                              CustomTextFormField(
                                labelText: 'Enter description',
                                controller: _descriptionController,
                                validator: notEmptyValidator,
                                isLoading: false,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Exam Date',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 8),
                              CustomDatePicker(
                                label: 'Select Exam Date',
                                isRequired: true,
                                selectedDate: _examDate,
                                onPick: (date) {
                                  _examDate = date;
                                  setState(() {});
                                },
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Start Time',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 8),
                              CustomTimePicker(
                                label: 'Select Start Time',
                                isRequired: true,
                                initialTime: _startTime,
                                onPick: (time) {
                                  _startTime = time;
                                  setState(() {});
                                },
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'End Time',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 8),
                              CustomTimePicker(
                                label: 'Select End Time',
                                isRequired: true,
                                initialTime: _endTime,
                                onPick: (time) {
                                  _endTime = time;
                                  setState(() {});
                                },
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                      primaryButton: 'save',
                      onPrimaryPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _courseId != null &&
                            _subjectId != null &&
                            _examDate != null &&
                            _startTime != null &&
                            _endTime != null) {
                          Map<String, dynamic> details = {
                            'subject_id': _subjectId,
                            'type': _typeController.text.trim(),
                            'total_mark': int.parse(_totalMarkController.text.trim()),
                            'description': _descriptionController.text.trim(),
                            'date': _examDate?.toIso8601String(),
                            'start_time': _startTime!.format(context),
                            'end_time': _endTime!.format(context),
                            'course_id': _courseId,
                          };

                          if (widget.examDetails != null) {
                            BlocProvider.of<ExamsBloc>(context).add(
                              EditExamEvent(
                                examId: widget.examDetails!['id'],
                                examDetails: details,
                              ),
                            );
                          } else {
                            BlocProvider.of<ExamsBloc>(context).add(
                              AddExamEvent(
                                examDetails: details,
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
        },
      ),
    );
  }
}
