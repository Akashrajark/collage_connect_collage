import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:collage_connect_collage/common_widget/custom_text_formfield.dart';
import 'package:collage_connect_collage/util/value_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'subjects_bloc/subjects_bloc.dart';

class AddSubject extends StatefulWidget {
  final Map? subjectDetails;
  final int courseId;
  const AddSubject({
    super.key,
    this.subjectDetails,
    required this.courseId,
  });

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _syllabusController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.subjectDetails != null) {
      _nameController.text = widget.subjectDetails!['name'];
      _descriptionController.text = widget.subjectDetails!['description'];
      _syllabusController.text = widget.subjectDetails!['syllabus'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubjectsBloc, SubjectsState>(
      listener: (context, state) {
        if (state is SubjectsSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return CustomAlertDialog(
          title: widget.subjectDetails == null ? 'Add Subject' : 'Edit Subject',
          isLoading: state is SubjectsLoadingState,
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Subject Name',
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
                    labelText: 'Enter subject Name',
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
                  minLines: 3,
                  maxLines: 3,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Syllabus',
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
                  labelText: 'Enter syllabus',
                  minLines: 5,
                  maxLines: 5,
                  controller: _syllabusController,
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
                'syllabus': _syllabusController.text.trim(),
                'course_id': widget.courseId,
              };

              if (widget.subjectDetails != null) {
                BlocProvider.of<SubjectsBloc>(context).add(
                  EditSubjectEvent(
                    subjectId: widget.subjectDetails!['id'],
                    subjectDetails: details,
                  ),
                );
              } else {
                BlocProvider.of<SubjectsBloc>(context).add(
                  AddSubjectEvent(
                    subjectDetails: details,
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
