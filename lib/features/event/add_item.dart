import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:collage_connect_collage/common_widget/custom_button.dart';
import 'package:collage_connect_collage/common_widget/custom_text_formfield.dart';
import 'package:collage_connect_collage/util/value_validator.dart';
import 'package:flutter/material.dart';

class AddItem extends StatelessWidget {
  AddItem({
    super.key,
  });
  final TextEditingController _itemNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: 'Add Item',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              labelText: 'Enter Item name',
              controller: _itemNameController,
              validator: notEmptyValidator,
              isLoading: false),
          const SizedBox(
            height: 30,
          ),
          CustomButton(
            inverse: true,
            onPressed: () {},
            label: 'Add Canteen',
          )
        ],
      ),
    );
  }
}
