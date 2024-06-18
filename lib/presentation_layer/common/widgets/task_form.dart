import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/data_layer/enums/task_status.dart';
import 'package:task_manager/data_layer/models/task/task_model.dart';
import 'package:task_manager/data_layer/models/time_tracking/task_time_tracking.dart';
import 'package:task_manager/presentation_layer/common/widgets/custom_form_field.dart';
import 'package:task_manager/presentation_layer/common/widgets/form_field_container.dart';
import 'package:task_manager/service_layer/services_setup.dart';

class TaskForm extends StatelessWidget {
  const TaskForm({
    this.taskModel,
    this.taskTimeTacking,
    this.formKey,
    this.contentValidator,
    this.onContentChanged,
    this.descriptionValidator,
    this.onDescriptionChanged,
    this.onStatusChanged,
    this.toggleTimeTracking,
    this.extraFormFields,
    this.childBelowForm,
    super.key,
  });

  final TaskModel? taskModel;
  final TaskTimeTacking? taskTimeTacking;
  final GlobalKey<FormState>? formKey;
  final FormFieldValidator<String>? contentValidator;
  final ValueChanged<String>? onContentChanged;
  final FormFieldValidator<String>? descriptionValidator;
  final ValueChanged<String>? onDescriptionChanged;
  final void Function(TaskStatus?)? onStatusChanged;
  final void Function({required bool startTracking})? toggleTimeTracking;
  final List<Widget>? extraFormFields;
  final Widget? childBelowForm;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: CustomScrollView(
        slivers: [
          _formFields(),
          if (childBelowForm != null) childBelowForm!,
        ],
      ),
    );
  }

  Widget _formFields() {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          FormFieldContainer(
            child: Column(
              children: [
                _formField(
                  initialValue: taskModel?.content,
                  hintText: 'Title',
                  validator: contentValidator,
                  onChanged: onContentChanged,
                ),
                const Divider(),
                _formField(
                  initialValue: taskModel?.description,
                  hintText: 'Description',
                  validator: descriptionValidator,
                  onChanged: onDescriptionChanged,
                  minLines: 5,
                ),
                _statusAndTime(),
                if (extraFormFields != null) ...extraFormFields!,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusAndTime() {
    if (taskModel != null) {
      return Column(
        children: [
          const Divider(),
          _statusDropdown(taskModel!),
          const Divider(),
          _timeTracking(),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _formField({
    String? hintText,
    String? initialValue,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
    int? minLines,
  }) {
    final field = CustomFormField(
      initialValue: initialValue,
      hintText: hintText,
      minLines: taskModel == null ? minLines : null,
      validator: validator,
      onChanged: onChanged,
    );
    if (taskModel != null && taskModel!.isCompleted) {
      return IgnorePointer(
        child: field,
      );
    } else {
      return field;
    }
  }

  Widget _statusDropdown(TaskModel taskModel) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: taskModel.isCompleted ? 8.h : 0),
      child: Row(
        children: [
          Text(
            'Status',
            style: themeService.state.primaryTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          const Spacer(),
          if (!taskModel.isCompleted)
            DropdownButton<TaskStatus>(
              dropdownColor: themeService.state.secondaryColor,
              value: TaskStatus.values.firstWhere(
                (element) => element.name == taskModel.labels.first,
              ),
              items: TaskStatus.values.map((TaskStatus status) {
                return DropdownMenuItem(
                  value: status,
                  child: _statusText(status),
                );
              }).toList(),
              underline: const SizedBox.shrink(),
              onChanged: onStatusChanged,
            )
          else
            _statusText(taskModel.status),
        ],
      ),
    );
  }

  Widget _statusText(TaskStatus status) {
    return Text(
      status.name.replaceFirst('_', ' ').toUpperCase(),
      style: themeService.state.primaryTextStyle.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
      ),
    );
  }

  Widget _timeTracking() {
    if (taskTimeTacking != null) {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: taskModel != null && taskModel!.isCompleted ? 8.h : 0,
        ),
        child: Row(
          children: [
            Text(
              'Tracked Time',
              style: themeService.state.primaryTextStyle.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            const Spacer(),
            if (taskTimeTacking!
                    .millisecondSinceEpochSinceLastTimeTrackingStarted ==
                null)
              _timeAndButton(
                onPressed: () => toggleTimeTracking?.call(startTracking: true),
                duration: taskTimeTacking!.getDuration(),
                isPlaying: false,
              )
            else
              StreamBuilder<int>(
                stream: Stream.periodic(const Duration(seconds: 1), (_) => _),
                builder: (context, snap) {
                  return _timeAndButton(
                    onPressed: () =>
                        toggleTimeTracking?.call(startTracking: false),
                    duration: taskTimeTacking!.getLiveDuration(),
                    isPlaying: true,
                  );
                },
              ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _timeAndButton({
    required String duration,
    required bool isPlaying,
    VoidCallback? onPressed,
  }) {
    return Row(
      children: [
        Text(
          duration,
          style: themeService.state.primaryTextStyle.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
          ),
        ),
        if (taskModel == null || !taskModel!.isCompleted)
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              isPlaying ? Icons.stop_circle : Icons.play_circle,
            ),
          ),
      ],
    );
  }
}
