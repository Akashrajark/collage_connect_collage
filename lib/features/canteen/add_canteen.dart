import 'package:collage_connect_collage/common_widget/custom_alert_dialog.dart';
import 'package:collage_connect_collage/common_widget/custom_text_formfield.dart';
import 'package:collage_connect_collage/features/canteen/categories_bloc/canteens_bloc.dart';
import 'package:collage_connect_collage/util/value_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_widget/custom_image_picker_button.dart';

class AddCanteen extends StatefulWidget {
  final Map? canteenDetails;
  AddCanteen({
    super.key,
    this.canteenDetails,
  });

  @override
  State<AddCanteen> createState() => _AddCanteenState();
}

class _AddCanteenState extends State<AddCanteen> {
  final _nameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PlatformFile? coverImage;

  @override
  void initState() {
    if (widget.canteenDetails != null) {
      _nameController.text = widget.canteenDetails!['name'];
      _emailController.text = widget.canteenDetails!['email'];
      _phoneController.text = widget.canteenDetails!['phone'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CanteensBloc, CanteensState>(
      listener: (context, state) {
        if (state is CanteensSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return CustomAlertDialog(
          title: 'Add Student',
          isLoading: state is CanteensLoadingState,
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomImagePickerButton(
                  width: double.infinity,
                  height: 200,
                  selectedImage: widget.canteenDetails?['image_url'],
                  onPick: (pick) {
                    coverImage = pick;
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 10,
                ),
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
                if (widget.canteenDetails == null)
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
                if (widget.canteenDetails == null)
                  CustomTextFormField(
                    labelText: 'Enter canteen email id',
                    controller: _emailController,
                    validator: notEmptyValidator,
                    isLoading: false,
                  ),
                if (widget.canteenDetails == null)
                  const SizedBox(
                    height: 8,
                  ),
                if (widget.canteenDetails == null)
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                if (widget.canteenDetails == null)
                  const SizedBox(
                    height: 8,
                  ),
                if (widget.canteenDetails == null)
                  CustomTextFormField(
                      labelText: 'Enter password',
                      controller: _passwordController,
                      validator: passwordValidator,
                      isLoading: false),
                if (widget.canteenDetails == null)
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
                  isLoading: false,
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          primaryButton: 'save',
          onPrimaryPressed: () {
            if (_formKey.currentState!.validate() &&
                ((coverImage != null) || widget.canteenDetails != null)) {
              Map<String, dynamic> details = {
                'name': _nameController.text.trim(),
                'email': _emailController.text.trim(),
                'password': _passwordController.text.trim(),
                'phone': _phoneController.text.trim(),
              };
              if (coverImage != null) {
                details['image'] = coverImage!.bytes;
                details['image_name'] = coverImage!.name;
              }

              if (widget.canteenDetails != null) {
                BlocProvider.of<CanteensBloc>(context).add(
                  EditCanteenEvent(
                    canteenId: widget.canteenDetails!['id'],
                    canteenDetails: details,
                  ),
                );
              } else {
                BlocProvider.of<CanteensBloc>(context).add(
                  AddCanteenEvent(
                    canteenDetails: details,
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
