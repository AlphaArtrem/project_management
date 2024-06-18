part of 'project_overview_bloc.dart';

///Events for [ProjectOverviewBloc]
abstract class ProjectOverviewEvents extends Equatable {
  const ProjectOverviewEvents();
}

class LoadProjectOverviewEvent extends ProjectOverviewEvents {
  const LoadProjectOverviewEvent(this.id);

  ///Id of project for which tasks are to be loaded
  final String id;

  @override
  List<Object?> get props => [id];
}

class AddTaskProjectOverviewEvent extends ProjectOverviewEvents {
  const AddTaskProjectOverviewEvent(this.task);

  ///Task to be added
  final TaskModel task;

  @override
  List<Object?> get props => [task];
}

class UpdateTaskStatusProjectOverviewEvent extends ProjectOverviewEvents {
  const UpdateTaskStatusProjectOverviewEvent({
    required this.newStatus,
    required this.oldTask,
    this.onError,
  });

  ///Task's old status
  final TaskStatus newStatus;

  ///Index of task
  final TaskModel oldTask;

  ///Callback when error is encountered
  final void Function(String error)? onError;

  @override
  List<Object?> get props => [
        newStatus,
        oldTask,
        onError,
      ];
}

class UpdateTaskProjectOverviewEvent extends ProjectOverviewEvents {
  const UpdateTaskProjectOverviewEvent({
    required this.taskModel,
  });

  ///Task status
  final TaskModel taskModel;

  @override
  List<Object?> get props => [taskModel];
}
