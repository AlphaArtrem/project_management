part of 'create_update_task_cubit.dart';

///State for [CreateUpdateTaskCubit]
abstract class CreateUpdateTaskState extends Equatable {
  ///[CreateUpdateTaskState] default constructor
  const CreateUpdateTaskState({
    this.content = '',
    this.description = '',
    this.labels = const ['todo'],
    this.isLoading = false,
    this.error = '',
  });

  ///Task title
  final String content;

  ///Task description
  final String description;

  ///Task labels for task status
  final List<String> labels;

  ///Is the cubit in loading state
  final bool isLoading;

  ///Error while creating updating task
  final String error;

  ///Copy constructor for [CreateUpdateTaskState]
  CreateUpdateTaskState copyWith({
    String? content,
    String? description,
    String? error,
    List<String>? labels,
    bool? isLoading,
  });

  ///Convert state to json
  Map<String, dynamic> toJson() => {
        'content': content,
        'description': description,
        'labels': labels.map((x) => x).toList(),
      };

  @override
  String toString() {
    return '$content, $description, '
        '$labels, $isLoading';
  }

  @override
  List<Object?> get props => [
        content,
        description,
        labels,
        isLoading,
        error,
      ];
}

///Initial state for [InitialCreateUpdateTaskState]
class InitialCreateUpdateTaskState extends CreateUpdateTaskState {
  ///[InitialCreateUpdateTaskState] default constructor
  const InitialCreateUpdateTaskState({
    super.content,
    super.description,
    super.labels,
    super.isLoading,
    super.error = '',
  });

  ///Copy constructor for [CreateTaskState]
  @override
  InitialCreateUpdateTaskState copyWith({
    String? content,
    String? description,
    String? error,
    List<String>? labels,
    bool? isLoading,
    String? projectID,
  }) {
    return InitialCreateUpdateTaskState(
      content: content ?? this.content,
      description: description ?? this.description,
      labels: labels ?? this.labels,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

///State for [CreateUpdateTaskCubit]
class CreateTaskState extends CreateUpdateTaskState {
  ///[CreateTaskState] default constructor
  const CreateTaskState({
    required this.projectID,
    super.content,
    super.description,
    super.labels,
    super.isLoading,
    super.error = '',
  });

  ///Project id
  final String projectID;

  ///Copy constructor for [CreateTaskState]
  @override
  CreateTaskState copyWith({
    String? content,
    String? description,
    String? error,
    List<String>? labels,
    bool? isLoading,
    String? projectID,
  }) {
    return CreateTaskState(
      content: content ?? this.content,
      description: description ?? this.description,
      labels: labels ?? this.labels,
      isLoading: isLoading ?? this.isLoading,
      projectID: projectID ?? this.projectID,
      error: error ?? this.error,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map['project_id'] = projectID;
    return map;
  }

  @override
  String toString() {
    return '$content, $description, '
        '$labels, $isLoading, $projectID';
  }

  @override
  List<Object?> get props => [
        content,
        description,
        labels,
        isLoading,
        error,
        projectID,
      ];
}

///State for [CreateUpdateTaskCubit]
class UpdateTaskState extends CreateUpdateTaskState {
  ///[UpdateTaskState] default constructor
  const UpdateTaskState({
    required this.taskModel,
    required this.taskTimeTacking,
    super.content,
    super.description,
    super.labels,
    super.isLoading,
    super.error = '',
  });

  ///Existing task if being updated
  final TaskModel taskModel;

  ///Task time tracking info
  final TaskTimeTacking taskTimeTacking;

  ///Copy constructor for [UpdateTaskState]
  @override
  UpdateTaskState copyWith({
    String? content,
    String? description,
    String? error,
    List<String>? labels,
    bool? isLoading,
    String? projectID,
    TaskModel? taskModel,
    TaskTimeTacking? taskTimeTacking,
  }) {
    return UpdateTaskState(
      content: content ?? this.content,
      description: description ?? this.description,
      labels: labels ?? this.labels,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      taskModel: taskModel ?? this.taskModel,
      taskTimeTacking: taskTimeTacking ?? this.taskTimeTacking,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();
    map['project_id'] = taskModel.projectId;
    return map;
  }

  @override
  String toString() {
    return '$content, $description, '
        '$labels, $isLoading, $taskModel';
  }

  @override
  List<Object?> get props => [
        content,
        description,
        labels,
        isLoading,
        error,
        taskModel,
        taskTimeTacking,
      ];
}
