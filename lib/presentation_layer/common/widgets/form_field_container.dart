import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/service_layer/services_setup.dart';

///Container for app's form fields
class FormFieldContainer extends StatelessWidget {
  ///Constructor for [FormFieldContainer]
  const FormFieldContainer({required this.child, super.key});

  ///Child for container
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: themeService.state.secondaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: themeService.state.primaryColor.withOpacity(0.75),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
