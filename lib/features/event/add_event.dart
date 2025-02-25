import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:collage_connect_collage/common_widget/custom_button.dart';
import 'package:collage_connect_collage/common_widget/custom_image_picker.dart';
import 'package:collage_connect_collage/common_widget/custom_image_picker_button.dart';
import 'package:collage_connect_collage/common_widget/custom_text_formfield.dart';
import 'package:collage_connect_collage/util/value_validator.dart';
import 'package:flutter/material.dart';

class AddEvent extends StatelessWidget {
  AddEvent({
    super.key,
  });
  final _eventNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: 'Add event',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImagePickerButton(
            onPick: (file) {},
            height: 150,
            width: 150,
          ),
          SizedBox(
            height: 20,
          ),
          const Text(
            'Event Name',
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
              labelText: 'Enter Event Name',
              controller: _eventNameController,
              validator: notEmptyValidator,
              isLoading: false),
          SizedBox(
            height: 20,
          ),
          const Text(
            'Event Date',
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
            onPick: (p0) {},
          ),
          const SizedBox(
            height: 30,
          ),
          CustomButton(
            color: Colors.white,
            onPressed: () {},
            label: 'Add Canteen',
          )
        ],
      ),
    );
  }
}
