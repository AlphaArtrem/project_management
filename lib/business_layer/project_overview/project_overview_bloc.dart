import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/data_layer/enums/task_status.dart';
import 'package:task_manager/data_layer/models/project/project_model.dart';
import 'package:task_manager/data_layer/models/task/task_model.dart';
import 'package:task_manager/presentation_layer/project_overview/project_overview_screen.dart';
import 'package:task_manager/repositories/project/project_repository_interface.dart';

part 'project_overview_events.dart';
part 'project_overview_state.dart';

///[Bloc] for [ProjectOverviewScreen]
class ProjectOverviewBloc
    extends Bloc<ProjectOverviewEvents, ProjectOverviewState> {
  ///[ProjectOverviewBloc] default constructor which takes
  ///in [ProjectOverviewState] as a required parameter
  ProjectOverviewBloc(this.projectRepository)
      : super(const InitialProjectOverviewState()) {
    on<LoadProjectOverviewEvent>(_loadProjects);
    on<AddTaskProjectOverviewEvent>(_addTask);
    on<UpdateTaskStatusProjectOverviewEvent>(_updateTaskStatus);
    on<UpdateTaskProjectOverviewEvent>(_updateTaskLocally);
  }

  ///Implementation of [IProjectRepository] to fetch and update tasks
  final IProjectRepository projectRepository;

  Future<void> _loadProjects(
    LoadProjectOverviewEvent event,
    Emitter<ProjectOverviewState> emit,
  ) async {
    if (state is LoadedProjectOverviewState &&
        (state as LoadedProjectOverviewState).projectID == event.id) {
      return;
    }
    emit(const InitialProjectOverviewState());
    try {
      final tasks = await projectRepository.getTasks(event.id);
      emit(LoadedProjectOverviewState(tasks: tasks, projectID: event.id));
    } catch (e) {
      emit(
        state.copyWith(
          error: e.toString().replaceFirst('Exception: ', ''),
          isLoading: false,
        ),
      );
    }
  }

  void _addTask(
    AddTaskProjectOverviewEvent event,
    Emitter<ProjectOverviewState> emit,
  ) {
    if (state is LoadedProjectOverviewState) {
      final state = this.state as LoadedProjectOverviewState;
      final tasks = List<TaskModel>.from(state.tasks)..add(event.task);
      emit(state.copyWith(tasks: tasks));
    }
  }

  Future<void> _updateTaskStatus(
    UpdateTaskStatusProjectOverviewEvent event,
    Emitter<ProjectOverviewState> emit,
  ) async {
    emit(
      state.copyWith(
        error: '',
        isLoading: true,
      ),
    );
    if (state is LoadedProjectOverviewState) {
      final state = this.state as LoadedProjectOverviewState;
      final tasks = List<TaskModel>.from(state.tasks);
      final index = tasks.indexOf(event.oldTask);
      if (index > -1) {
        tasks[index] = event.oldTask.copyWith(labels: [event.newStatus.name]);
        emit(state.copyWith(tasks: tasks));
        try {
          await projectRepository.updateTask(tasks[index]);
        } catch (e) {
          emit(
            state.copyWith(
              error: e.toString().replaceFirst('Exception: ', ''),
              isLoading: false,
            ),
          );
          event.onError?.call(state.error);
        }
      } else {
        event.onError?.call('Unable to update task');
      }
    }
  }

  Future<void> _updateTaskLocally(
    UpdateTaskProjectOverviewEvent event,
    Emitter<ProjectOverviewState> emit,
  ) async {
    emit(
      state.copyWith(
        error: '',
        isLoading: true,
      ),
    );
    if (state is LoadedProjectOverviewState) {
      final state = this.state as LoadedProjectOverviewState;
      final tasks = List<TaskModel>.from(state.tasks);
      final index = tasks.indexWhere((task) => task.id == event.taskModel.id);
      if (index > -1) {
        if (event.taskModel.isCompleted) {
          tasks.removeAt(index);
        } else {
          tasks[index] = event.taskModel;
        }
        emit(state.copyWith(tasks: tasks));
      }
    }
  }
}
