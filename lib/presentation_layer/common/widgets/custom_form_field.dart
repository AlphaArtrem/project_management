import 'package:flutter/material.dart';
import 'package:task_manager/service_layer/services_setup.dart';

///Custom form field for app's input boxes
class CustomFormField extends StatelessWidget {
  ///[CustomFormField] constructor
  const CustomFormField({
    this.hintText,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.minLines,
    this.controller,
    super.key,
  });

  ///Hint text for filed
  final String? hintText;

  ///Initial value for field must be null if [controller] is passes
  final String? initialValue;

  ///Validator for field
  final FormFieldValidator<String>? validator;

  ///On field value changed callback
  final ValueChanged<String>? onChanged;

  ///Minimum line to show for filed, makes the filed expand
  final int? minLines;

  ///[TextEditingController] for field must be null if [initialValue] is passes
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
