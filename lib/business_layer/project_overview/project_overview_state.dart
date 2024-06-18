part of 'project_overview_bloc.dart';

///Abstract state for [ProjectOverviewBloc]
abstract class ProjectOverviewState extends Equatable {
  const ProjectOverviewState({
    this.isLoading = true,
    this.error = '',
  });

  ///[isLoading] determines weather to show a loading state to user
  final bool isLoading;

  ///Error if any in loading or adding projects
  final String error;

  ///Copy with constructor for [ProjectOverviewState]
  ProjectOverviewState copyWith({
    bool? isLoading,
    String? error,
  }) {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
      ];
}

///Initial state for [ProjectOverviewBloc]
class InitialProjectOverviewState extends ProjectOverviewState {
  ///Default constructor for [InitialProjectOverviewState]
  const InitialProjectOverviewState({
    super.isLoading,
    super.error,
  });

  @override
  InitialProjectOverviewState copyWith({
    List<ProjectModel>? projects,
    bool? isLoading,
    String? error,
  }) {
    return InitialProjectOverviewState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

///Loaded state for [ProjectOverviewBloc]
class LoadedProjectOverviewState extends ProjectOverviewState {
  ///Default constructor for [LoadedProjectOverviewState]
  const LoadedProjectOverviewState({
    required this.tasks,
    required this.projectID,
    super.isLoading = false,
    super.error,
  });

  ///Project id for task
  final String projectID;

  ///List of tasks for projects
  final List<TaskModel> tasks;

  @override
  LoadedProjectOverviewState copyWith({
    List<TaskModel>? tasks,
    bool? isLoading,
    String? error,
    String? projectID,
  }) {
    return LoadedProjectOverviewState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      projectID: projectID ?? this.projectID,
    );
  }

  @override
  List<Object?> get props => [
        tasks,
        projectID,
        ...super.props,
      ];
}
