import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/data_layer/models/comment/comment_model.dart';
import 'package:task_manager/data_layer/models/task/task_model.dart';
import 'package:task_manager/data_layer/models/time_tracking/task_time_tracking.dart';

part 'task_history_model.g.dart';

///Model for tasks moved to history
@HiveType(typeId: 3)
class TaskHistoryModel extends Equatable {
  ///Default constructor for [TaskHistoryModel]
  const TaskHistoryModel({
    required this.taskModel,
    required this.taskTimeTacking,
    required this.comments,
    required this.completionTimeStamp,
  });

  ///[TaskModel] to access task details
  @HiveField(0)
  final TaskModel taskModel;

  ///[TaskTimeTacking] to access time spent on task
  @HiveField(1)
  final TaskTimeTacking taskTimeTacking;

  ///[List] of [CommentModel] to access task comments
  @HiveField(2)
  final List<CommentModel> comments;

  ///Timestamp for completion of task
  @HiveField(3)
  final String completionTimeStamp;

  ///Convert timestamp String to [DateTime]
  DateTime get timeStamp => DateTime.parse(completionTimeStamp);

  @override
  List<Object?> get props => [
        taskModel,
        taskTimeTacking,
        comments,
        completionTimeStamp,
      ];
}
