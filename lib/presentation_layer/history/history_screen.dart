import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/data_layer/models/route/route_details.dart';
import 'package:task_manager/data_layer/models/task_history_model/task_history_model.dart';
import 'package:task_manager/presentation_layer/common/widgets/task_form.dart';
import 'package:task_manager/presentation_layer/create_update_task/comments_list.dart';
import 'package:task_manager/presentation_layer/project_overview/task_card.dart';
import 'package:task_manager/repositories/history_repository/task_history_repository.dart';
import 'package:task_manager/service_layer/services_setup.dart';

///History screen for archived tasks
class HistoryScreen extends StatelessWidget {
  ///Default constructor for [HistoryScreen]
  const HistoryScreen({super.key});

  ///[RouteDetails]  for [HistoryScreen]
  static final RouteDetails route =
      RouteDetails('historyScreen', '/historyScreen');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeService.state.secondaryColor,
      appBar: AppBar(
        elevation: 4,
        shadowColor: themeService.state.primaryColor,
        backgroundColor: themeService.state.primaryColor,
        title: Text(
          'History',
          style: themeService.state.appBarTitleStyle,
        ),
        iconTheme: IconThemeData(color: themeService.state.secondaryColor),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    final history = serviceLocator
        .get<TaskHistoryRepository>()
        .getAllTaskFromHistory()
        .reversed;
    return ListView.builder(
      padding: EdgeInsets.only(
        top: 20.h,
        left: 20.w,
        right: 20.w,
      ),
      itemBuilder: (context, index) {
        final task = history.elementAt(index);
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: InkWell(
            onTap: () {
              showCupertinoModalPopup<void>(
                context: context,
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                builder: (context) {
                  return _detailsBottomSheet(task);
                },
              );
            },
            child: TaskCard(
              task: task.taskModel,
              width: double.infinity,
              isDragging: true,
            ),
          ),
        );
      },
      itemCount: history.length,
    );
  }

  Widget _detailsBottomSheet(TaskHistoryModel task) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: SizedBox(
        height: 0.85.sh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 15.w, top: 10.h),
              child: InkWell(
                onTap: navigationService.pop,
                child: CircleAvatar(
                  radius: 12.r,
                  backgroundColor: themeService.state.primaryColor,
                  foregroundColor: themeService.state.primaryColor,
                  child: Icon(
                    Icons.close_outlined,
                    color: themeService.state.secondaryColor,
                    size: 20.r,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TaskForm(
                taskModel: task.taskModel,
                taskTimeTacking: task.taskTimeTacking,
                childBelowForm: CommentsList(
                  comments: task.comments,
                ),
                extraFormFields: [
                  const Divider(),
                  _completionDate(task.timeStamp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _completionDate(DateTime dateTime) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Text(
            'Completed On',
            style: themeService.state.primaryTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          const Spacer(),
          Text(
            dateTime.toString().split('.').first,
            style: themeService.state.primaryTextStyle.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}
