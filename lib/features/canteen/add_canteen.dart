import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:collage_connect_collage/common_widget/custom_button.dart';
import 'package:collage_connect_collage/common_widget/custom_text_formfield.dart';
import 'package:collage_connect_collage/util/value_validator.dart';
import 'package:flutter/material.dart';

class AddCanteen extends StatelessWidget {
  AddCanteen({
    super.key,
  });
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: 'Add Student',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Canteen Name',
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
              labelText: 'Enter canteen Name',
              controller: _nameController,
              validator: notEmptyValidator,
              isLoading: false),
          const Text(
            'Canteen Email ID',
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
              labelText: 'Enter canteen email id',
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
            'Phone Number',
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
              labelText: 'Enter phone number',
              controller: _phoneController,
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
