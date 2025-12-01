import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:collage_connect_collage/common_widget/custom_label_with_text.dart';
import 'package:flutter/material.dart';

class SubjectDetailsDialog extends StatelessWidget {
  final Map subjectDetails;
  const SubjectDetailsDialog({super.key, required this.subjectDetails});

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      crossAxisAlignment: CrossAxisAlignment.start,
      title: 'Subject Details',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWithLabel(label: 'Name', text: subjectDetails['name']),
          SizedBox(height: 8),
          TextWithLabel(label: 'Description', text: subjectDetails['description']),
          SizedBox(height: 8),
          TextWithLabel(label: 'Syllabus', text: subjectDetails['syllabus']),
        ],
      ),
    );
  }
}
