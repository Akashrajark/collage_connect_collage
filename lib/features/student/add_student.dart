import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:collage_connect_collage/common_widget/custom_image_picker_button.dart';
import 'package:collage_connect_collage/common_widget/custom_text_formfield.dart';
import 'package:collage_connect_collage/util/value_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'categories_bloc/students_bloc.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PlatformFile? coverImage;

  @override
  void initState() {
    if (widget.studentDetails != null) {
      _nameController.text = widget.studentDetails!['name'];
      _emailController.text = widget.studentDetails!['email'];
      _regNoController.text = widget.studentDetails!['reg_no'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentsBloc, StudentsState>(
      listener: (context, state) {
        if (state is StudentsSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return CustomAlertDialog(
          title: 'Add Student',
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
                  if (widget.studentDetails == null)
                    const Text(
                      'Student Email ID',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  if (widget.studentDetails == null)
                    const SizedBox(
                      height: 8,
                    ),
                  if (widget.studentDetails == null)
                    CustomTextFormField(
                        labelText: 'Enter student email id',
                        controller: _emailController,
                        validator: notEmptyValidator,
                        isLoading: false),
                  if (widget.studentDetails == null)
                    const SizedBox(
                      height: 8,
                    ),
                  if (widget.studentDetails == null)
                    const Text(
                      'Password',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  if (widget.studentDetails == null)
                    const SizedBox(
                      height: 8,
                    ),
                  if (widget.studentDetails == null)
                    CustomTextFormField(
                        labelText: 'Enter password',
                        controller: _passwordController,
                        validator: passwordValidator,
                        isLoading: false),
                  if (widget.studentDetails == null)
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
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
          primaryButton: 'save',
          onPrimaryPressed: () {
            if (_formKey.currentState!.validate() &&
                ((coverImage != null) || widget.studentDetails != null)) {
              Map<String, dynamic> details = {
                'name': _nameController.text.trim(),
                'email': _emailController.text.trim(),
                'password': _passwordController.text.trim(),
                'reg_no': _regNoController.text.trim(),
              };

              if (coverImage != null) {
                details['image'] = coverImage!.bytes;
                details['image_name'] = coverImage!.name;
              }

              if (widget.studentDetails != null) {
                BlocProvider.of<StudentsBloc>(context).add(
                  EditStudentEvent(
                    studentId: widget.studentDetails!['id'],
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
  }
}
