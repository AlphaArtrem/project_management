import 'package:flutter/material.dart';
import 'package:task_manager/service_layer/services_setup.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    this.hintText,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.minLines,
    this.controller,
    super.key,
  });

  final String? hintText;
  final String? initialValue;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final int? minLines;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      decoration: InputDecoration(
        fillColor: themeService.state.secondaryColor,
        filled: true,
        border: InputBorder.none,
        hintText: hintText,
        contentPadding: EdgeInsets.zero,
      ),
      maxLines: null,
      minLines: minLines,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
