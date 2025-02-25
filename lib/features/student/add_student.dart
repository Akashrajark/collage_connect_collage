import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:collage_connect_collage/common_widget/custom_button.dart';
import 'package:collage_connect_collage/common_widget/custom_image_picker_button.dart';
import 'package:collage_connect_collage/common_widget/custom_text_formfield.dart';
import 'package:collage_connect_collage/util/value_validator.dart';
import 'package:flutter/material.dart';

class AddStudent extends StatelessWidget {
  AddStudent({
    super.key,
  });
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _regNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: 'Add Student',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImagePickerButton(
            onPick: (file) {},
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
              isLoading: false),
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
