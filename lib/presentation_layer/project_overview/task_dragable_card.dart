import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_manager/business_layer/project_overview/project_overview_bloc.dart';
import 'package:task_manager/data_layer/models/task/task_model.dart';
import 'package:task_manager/presentation_layer/project_overview/project_overview_screen.dart';
import 'package:task_manager/presentation_layer/project_overview/task_card.dart';

///Draggable card to show task and move around in tasks status column's
class TaskDraggableCard extends StatelessWidget {
  ///Constructor for [TaskDraggableCard]
  const TaskDraggableCard({
    required this.task,
    required this.horizontalScrollController,
    required this.index,
    super.key,
  });

  ///Task to show
  final TaskModel task;

  ///Index of card in [ProjectOverviewBloc]
  final int index;

  ///[ScrollController] for horizontal scroll for task status column's in
  ///[ProjectOverviewScreen]
  final ScrollController horizontalScrollController;

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<TaskModel>(
      axis: Axis.horizontal,
      data: task,
      feedback: TaskCard(
        task: task,
        isDragging: true,
      ),
      childWhenDragging: Opacity(
        opacity: 0,
        child: TaskCard(task: task),
      ),
      delay: const Duration(milliseconds: 200),
      onDragUpdate: (details) {
        if (details.localPosition.dx > .8.sw) {
          horizontalScrollController.animateTo(
            horizontalScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 2000),
            curve: Curves.linear,
          );
        } else if (details.localPosition.dx < .3.sw) {
          horizontalScrollController.animateTo(
            horizontalScrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 2000),
            curve: Curves.linear,
          );
        } else {
          horizontalScrollController.jumpTo(horizontalScrollController.offset);
        }
      },
      onDragEnd: (details) {
        horizontalScrollController.jumpTo(horizontalScrollController.offset);
      },
      onDraggableCanceled: (_, __) {
        horizontalScrollController.jumpTo(horizontalScrollController.offset);
      },
      child: TaskCard(task: task),
    );
  }
}
