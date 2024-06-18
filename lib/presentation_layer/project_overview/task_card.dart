import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/data_layer/models/task/task_model.dart';
import 'package:task_manager/service_layer/services_setup.dart';

///Card to show task info
class TaskCard extends StatelessWidget {
  ///Constructor for [TaskCard]
  const TaskCard({
    required this.task,
    this.isDragging = false,
    this.width = 200,
    super.key,
  });

  ///If the card is dragging show border around card
  final bool isDragging;

  ///Task to show in card
  final TaskModel task;

  ///Width of card
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isDragging ? EdgeInsets.zero : const EdgeInsets.only(bottom: 10),
      child: Material(
        elevation: isDragging ? 10.0 : 0,
        borderRadius: BorderRadius.circular(20),
        color: themeService.state.secondaryColor,
        child: Container(
          width: width.w,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDragging
                  ? themeService.state.primaryColor
                  : Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ..._titleAndDescription(context),
              _commentCount(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _titleAndDescription(BuildContext context) {
    return [
      Text(
        task.content,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: themeService.state.primaryTitleStyle.copyWith(fontSize: 16.sp),
      ),
      SizedBox(height: 5.h),
      Text(
        task.description,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        style: themeService.state.secondaryTextStyle,
      ),
      SizedBox(height: 5.h),
    ];
  }

  Widget _commentCount() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Icon(
            Icons.comment,
            color: themeService.state.primaryColor,
            size: 20.r,
          ),
          Text(
            ' ${task.commentCount}',
            style: themeService.state.primaryTextStyle.copyWith(
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}
