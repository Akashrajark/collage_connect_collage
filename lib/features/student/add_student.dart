import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:collage_connect_collage/common_widget/custom_date_picker.dart';
import 'package:collage_connect_collage/common_widget/custom_dropdownmenu.dart';
import 'package:collage_connect_collage/common_widget/custom_image_picker_button.dart';
import 'package:collage_connect_collage/common_widget/custom_text_formfield.dart';
import 'package:collage_connect_collage/features/courses/courses_bloc/courses_bloc.dart';
import 'package:collage_connect_collage/util/value_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';

import 'students_bloc/students_bloc.dart';

class AddStudent extends StatefulWidget {
  final Map? studentDetails;
  const AddStudent({
    super.key,
    this.studentDetails,
  });

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _nameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _regNoController = TextEditingController();

  String? _gender;

  DateTime? _dobDate;
  int? _course;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PlatformFile? coverImage;
  final CoursesBloc _coursesBloc = CoursesBloc();
  List _courses = [];

  @override
  void initState() {
    getCourses();
    if (widget.studentDetails != null) {
      _nameController.text = widget.studentDetails!['name'];
      _emailController.text = widget.studentDetails!['email'];
      _regNoController.text = widget.studentDetails!['reg_no'];
      _gender = widget.studentDetails!['gender'];
      if (widget.studentDetails!['dob'] != null) {
        _dobDate = DateTime.parse(widget.studentDetails!['dob']);
      }
      _course = widget.studentDetails!['course_id'];
    }
    super.initState();
  }

  void getCourses() {
    _coursesBloc.add(GetAllCoursesEvent(params: {}));
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
            Logger().w(_courses);
            setState(() {});
          } else if (state is CoursesSuccessState) {
            getCourses();
          }
        },
        builder: (context, state) {
          return BlocConsumer<StudentsBloc, StudentsState>(
            listener: (context, state) {
              if (state is StudentsSuccessState) {
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              return CustomAlertDialog(
                title: widget.studentDetails == null ? 'Add Student' : 'Edit Student',
                isLoading: state is StudentsLoadingState,
                content: Flexible(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        CustomImagePickerButton(
                          selectedImage: widget.studentDetails?['image_url'],
                          onPick: (file) {
                            coverImage = file;
                            setState(() {});
                          },
                          width: 200,
                          height: 200,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Student Name',
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
                          labelText: 'Enter Student Name',
                          controller: _nameController,
                          validator: notEmptyValidator,
                          isLoading: false,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          'Student Email ID',
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
                            labelText: 'Enter student email id',
                            controller: _emailController,
                            validator: notEmptyValidator,
                            isLoading: false),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          'Password',
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
                            labelText: 'Enter password',
                            controller: _passwordController,
                            validator: passwordValidator,
                            isLoading: false),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          'Register number',
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
                            labelText: 'Enter Register no. number',
                            controller: _regNoController,
                            validator: notEmptyValidator,
                            isLoading: false),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomDropDownMenu(
                            title: 'Gender',
                            selectedValue: _gender,
                            hintText: "Select Gender",
                            dropdownMenuItems: [
                              DropdownMenuItem(value: 'Male', child: Text("Male")),
                              DropdownMenuItem(value: 'Female', child: Text("Female")),
                              DropdownMenuItem(value: 'Other', child: Text("Other")),
                            ],
                            onSelected: (value) {
                              _gender = value;
                              setState(() {});
                            }),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          'Date of Birth',
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
                        CustomDatePicker(
                          label: 'Select Date of Birth',
                          isRequired: true,
                          selectedDate: _dobDate,
                          onPick: (date) {
                            _dobDate = date;
                            setState(() {});
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomDropDownMenu(
                            title: 'Course',
                            selectedValue: _course,
                            hintText: "Select Course",
                            dropdownMenuItems: List.generate(_courses.length, (index) {
                              return DropdownMenuItem(
                                  value: _courses[index]['id'], child: Text(_courses[index]['name']));
                            }),
                            onSelected: (value) {
                              _course = value;
                              setState(() {});
                            }),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                primaryButton: 'save',
                onPrimaryPressed: () {
                  if (_formKey.currentState!.validate() &&
                      ((coverImage != null) || widget.studentDetails != null) &&
                      _gender != null) {
                    Map<String, dynamic> details = {
                      'name': _nameController.text.trim(),
                      'email': _emailController.text.trim(),
                      'password': _passwordController.text.trim(),
                      'reg_no': _regNoController.text.trim(),
                      'gender': _gender,
                      'dob': _dobDate?.toIso8601String(),
                      'course_id': _course,
                    };

                    if (coverImage != null) {
                      details['image'] = coverImage!.bytes;
                      details['image_name'] = coverImage!.name;
                    }

                    if (widget.studentDetails != null) {
                      BlocProvider.of<StudentsBloc>(context).add(
                        EditStudentEvent(
                          studentUserId: widget.studentDetails!['user_id'],
                          studentDetails: details,
                        ),
                      );
                    } else {
                      BlocProvider.of<StudentsBloc>(context).add(
                        AddStudentEvent(
                          studentDetails: details,
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
