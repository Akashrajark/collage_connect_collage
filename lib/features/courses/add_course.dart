import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:collage_connect_collage/common_widget/custom_text_formfield.dart';
import 'package:collage_connect_collage/util/value_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'courses_bloc/courses_bloc.dart';

class AddCourse extends StatefulWidget {
  final Map? courseDetails;
  const AddCourse({
    super.key,
    this.courseDetails,
  });

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.courseDetails != null) {
      _nameController.text = widget.courseDetails!['name'];
      _descriptionController.text = widget.courseDetails!['description'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoursesBloc, CoursesState>(
      listener: (context, state) {
        if (state is CoursesSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return CustomAlertDialog(
          title: widget.courseDetails == null ? 'Add Course' : 'Edit Course',
          isLoading: state is CoursesLoadingState,
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Course Name',
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
                    labelText: 'Enter course Name',
                    controller: _nameController,
                    validator: notEmptyValidator,
                    isLoading: false),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Description',
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
                  labelText: 'Enter description',
                  controller: _descriptionController,
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
                'name': _nameController.text.trim(),
                'description': _descriptionController.text.trim(),
              };

              if (widget.courseDetails != null) {
                BlocProvider.of<CoursesBloc>(context).add(
                  EditCourseEvent(
                    courseId: widget.courseDetails!['id'],
                    courseDetails: details,
                  ),
                );
              } else {
                BlocProvider.of<CoursesBloc>(context).add(
                  AddCourseEvent(
                    courseDetails: details,
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
