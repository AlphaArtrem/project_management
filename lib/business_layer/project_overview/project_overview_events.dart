part of 'project_overview_bloc.dart';

///Events for [ProjectOverviewBloc]
abstract class ProjectOverviewEvents extends Equatable {
  ///Default constructor for [ProjectOverviewEvents]
  const ProjectOverviewEvents();
}

///Event to load projects
class LoadProjectOverviewEvent extends ProjectOverviewEvents {
  ///Default constructor for [LoadProjectOverviewEvent]
  const LoadProjectOverviewEvent(this.id);

  ///Id of project for which tasks are to be loaded
  final String id;

  @override
  List<Object?> get props => [id];
}

///Event to add tasks
class AddTaskProjectOverviewEvent extends ProjectOverviewEvents {
  ///Default constructor for [AddTaskProjectOverviewEvent]
  const AddTaskProjectOverviewEvent(this.task);

  ///Task to be added
  final TaskModel task;

  @override
  List<Object?> get props => [task];
}

///Event to update task status
class UpdateTaskStatusProjectOverviewEvent extends ProjectOverviewEvents {
  ///Default constructor for [UpdateTaskStatusProjectOverviewEvent]
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

///Event to update task
class UpdateTaskProjectOverviewEvent extends ProjectOverviewEvents {
  ///Default constructor for [UpdateTaskProjectOverviewEvent]
  const UpdateTaskProjectOverviewEvent({
    required this.taskModel,
  });

  ///Task status
  final TaskModel taskModel;

  @override
  List<Object?> get props => [taskModel];
}
