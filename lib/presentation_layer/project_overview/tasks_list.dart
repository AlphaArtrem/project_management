import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/business_layer/project_overview/project_overview_bloc.dart';
import 'package:task_manager/data_layer/enums/task_status.dart';
import 'package:task_manager/data_layer/models/task/task_model.dart';
import 'package:task_manager/presentation_layer/create_update_task/create_update_task_screen.dart';
import 'package:task_manager/presentation_layer/project_overview/task_dragable_card.dart';
import 'package:task_manager/service_layer/services_setup.dart';

class TasksList extends StatefulWidget {
  const TasksList({
    required this.horizontalScrollController,
    required this.bloc,
    Key? key,
  }) : super(key: key);

  ///[ScrollController] for tasks list sections
  final ScrollController horizontalScrollController;

  ///[ProjectOverviewBloc] for updating tasks
  final ProjectOverviewBloc bloc;

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        TaskStatus.values.length,
        (index) => _stageAndTaskList(TaskStatus.values[index], context),
      ),
    );
  }

  Widget _stageAndTaskList(TaskStatus status, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 2.w),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: themeService.state.primaryColor.withOpacity(0.1),
      ),
      child: Column(
        children: [
          _taskStatusName(status),
          SizedBox(
            height: 20.h,
          ),
          _taskList(status),
        ],
      ),
    );
  }

  Widget _taskStatusName(TaskStatus status) {
    return Text(
      status.name.toUpperCase().replaceFirst('_', ' '),
      style: themeService.state.primaryTitleStyle,
    );
  }

  Widget _taskList(TaskStatus status) {
    final currentStatusTasks = (widget.bloc.state as LoadedProjectOverviewState)
        .tasks
        .where((element) => element.status == status);

    return Expanded(
      child: DragTarget<TaskModel>(
        builder: (context, candidateTasks, rejectedTasks) {
          return Container(
            width: 200.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: currentStatusTasks.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => navigationService.pushScreen(
                    CreateUpdateTaskScreen.route,
                    extra: currentStatusTasks.elementAt(index),
                  ),
                  child: TaskDragableCard(
                    task: currentStatusTasks.elementAt(index),
                    horizontalScrollController:
                        widget.horizontalScrollController,
                    index: index,
                  ),
                );
              },
            ),
          );
        },
        onAcceptWithDetails: (details) {
          widget.bloc.add(
            UpdateTaskStatusProjectOverviewEvent(
              newStatus: status,
              oldTask: details.data,
              onError: (error) => navigationService.showSnackBar(
                'Could not update ${details.data.content} with error $error',
              ),
            ),
          );
        },
      ),
    );
  }
}
