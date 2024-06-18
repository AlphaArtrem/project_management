import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/data_layer/enums/task_status.dart';
import 'package:task_manager/data_layer/models/comment/comment_model.dart';
import 'package:task_manager/data_layer/models/project/project_model.dart';
import 'package:task_manager/data_layer/models/task/task_model.dart';
import 'package:task_manager/data_layer/models/task_history_model/task_history_model.dart';
import 'package:task_manager/data_layer/models/time_tracking/task_time_tracking.dart';
import 'package:task_manager/repositories/history_repository/task_history_repository_interface.dart';
import 'package:task_manager/repositories/project/project_repository_interface.dart';
import 'package:task_manager/repositories/time_tracking/time_tracking_repository_interface.dart';

part 'create_update_task_state.dart';

///Cubit to create new tasks
class CreateUpdateTaskCubit extends Cubit<CreateUpdateTaskState> {
  ///[CreateUpdateTaskCubit] default constructor
  CreateUpdateTaskCubit({
    required this.projectRepository,
    required this.timeTrackingRepository,
    required this.taskHistoryRepository,
  }) : super(const InitialCreateUpdateTaskState());

  ///Implementation of [IProjectRepository] to create or update tasks
  final IProjectRepository projectRepository;

  ///Implementation of [ITimeTrackingRepository] to track time spent on tasks
  final ITimeTrackingRepository timeTrackingRepository;

  ///Implementation of [ITaskHistoryRepository] to store to history
  final ITaskHistoryRepository taskHistoryRepository;

  ///Initialise with project or task
  void init(ProjectModel? projectModel, TaskModel? taskModel) {
    if (state is! InitialCreateUpdateTaskState) {
      return;
    }
    assert(
        (projectModel == null && taskModel != null) ||
            (projectModel != null && taskModel == null),
        'Both project and task cannot be null and one of them must be null');
    if (projectModel != null) {
      emit(CreateTaskState(projectID: projectModel.id));
    } else {
      _loadExistingTask(taskModel!);
    }
  }

  ///Initialise with existing task
  void _loadExistingTask(TaskModel taskModel) {
    emit(
      UpdateTaskState(
        content: taskModel.content,
        description: taskModel.description,
        labels: taskModel.labels,
        taskModel: taskModel,
        taskTimeTacking: _getTimeTrackingInfo(taskModel.id),
      ),
    );
  }

  ///Validate string input for task
  String? validateInput(String? value, String fieldTitle) {
    if (value == null || value.isEmpty) {
      return '$fieldTitle is required.';
    }
    return null;
  }

  ///Update task title
  void updateTitle(String title) {
    emit(state.copyWith(content: title));
    if (state is UpdateTaskState) {
      final state = this.state as UpdateTaskState;
      emit(
        state.copyWith(
          taskModel: state.taskModel.copyWith(content: title),
        ),
      );
    }
  }

  ///Update task status
  void updateStatus(TaskStatus status) {
    emit(state.copyWith(labels: [status.name]));
    if (state is UpdateTaskState) {
      final state = this.state as UpdateTaskState;
      emit(
        state.copyWith(
          taskModel: state.taskModel.copyWith(labels: [status.name]),
        ),
      );
    }
  }

  ///Update task status
  int incrementCommentCount() {
    if (state is UpdateTaskState) {
      final state = this.state as UpdateTaskState;
      final commentCount = state.taskModel.commentCount + 1;
      emit(
        state.copyWith(
          taskModel: state.taskModel.copyWith(
            commentCount: commentCount,
          ),
        ),
      );
      return commentCount;
    }
    return 0;
  }

  ///Update task description
  void updateDescription(String description) {
    emit(state.copyWith(description: description));
    if (state is UpdateTaskState) {
      final state = this.state as UpdateTaskState;
      emit(
        state.copyWith(
          taskModel: state.taskModel.copyWith(description: description),
        ),
      );
    }
  }

  ///Create or update a task
  Future<TaskModel?> addOrUpdateTask() async {
    if (state is! InitialCreateUpdateTaskState) {
      emit(state.copyWith(isLoading: true, error: ''));
      try {
        final result = state is UpdateTaskState
            ? await projectRepository.updateTask(
                (state as UpdateTaskState).taskModel.copyWith(
                      content: state.content,
                      description: state.description,
                      labels: state.labels,
                    ),
              )
            : await projectRepository.addTask(state as CreateTaskState);
        emit(state.copyWith(isLoading: false, error: ''));
        return result;
      } catch (e) {
        emit(
          state.copyWith(
            error: e.toString().replaceFirst('Exception: ', ''),
            isLoading: false,
          ),
        );
      }
    }
    return null;
  }

  ///Archive a task to history
  Future<TaskModel?> archiveToHistory(List<CommentModel> comment) async {
    if (state is UpdateTaskState &&
        (state as UpdateTaskState).taskModel.status == TaskStatus.done) {
      final state = this.state as UpdateTaskState;
      emit(state.copyWith(isLoading: true, error: ''));
      try {
        final result = await projectRepository.closeTask(state.taskModel);
        if (result) {
          final task = state.taskModel.copyWith(isCompleted: true);
          final historyModel = TaskHistoryModel(
              taskModel: task,
              taskTimeTacking: state.taskTimeTacking,
              comments: comment,
              completionTimeStamp: DateTime.now().toIso8601String());
          taskHistoryRepository.addTaskToHistory(historyModel);
          emit(state.copyWith(isLoading: false, error: '', taskModel: task));
          return task;
        }
      } catch (e) {
        emit(
          state.copyWith(
            error: e.toString().replaceFirst('Exception: ', ''),
            isLoading: false,
          ),
        );
      }
    }
    return null;
  }

  TaskTimeTacking _getTimeTrackingInfo(String taskID) {
    return timeTrackingRepository.getTimeSpentOnTask(taskID);
  }

  ///Function to start time tracking
  void toggleTimeTracking({required bool startTracking}) {
    if (state is UpdateTaskState) {
      final state = this.state as UpdateTaskState;
      if (startTracking) {
        timeTrackingRepository.startTrackingTime(state.taskModel.id);
      } else {
        timeTrackingRepository.stopTrackingTime(state.taskModel.id);
      }
      final taskTimeTacking =
          timeTrackingRepository.getTimeSpentOnTask(state.taskModel.id);
      emit(state.copyWith(taskTimeTacking: taskTimeTacking));
    }
  }
}
