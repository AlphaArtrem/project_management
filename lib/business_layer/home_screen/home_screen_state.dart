part of 'home_screen_bloc.dart';

///Abstract state for [HomeScreenBloc]
abstract class HomeScreenState extends Equatable {
  const HomeScreenState({
    this.isLoading = true,
    this.error = '',
  });

  ///[isLoading] determines weather to show a loading state to user
  final bool isLoading;

  ///Error if any in loading or adding projects
  final String error;

  HomeScreenState copyWith({
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

///Initial state for [HomeScreenBloc]
class InitialHomeScreenState extends HomeScreenState {
  const InitialHomeScreenState({
    super.isLoading,
    super.error,
  });

  @override
  InitialHomeScreenState copyWith({
    List<ProjectModel>? projects,
    bool? isLoading,
    String? error,
  }) {
    return InitialHomeScreenState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

///Loaded state for [HomeScreenBloc]
class LoadedHomeScreenState extends HomeScreenState {
  const LoadedHomeScreenState({
    required this.projects,
    super.isLoading = false,
    super.error,
  });

  ///List of user projects
  final List<ProjectModel> projects;

  @override
  LoadedHomeScreenState copyWith({
    List<ProjectModel>? projects,
    bool? isLoading,
    String? error,
  }) {
    return LoadedHomeScreenState(
      projects: projects ?? this.projects,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        projects,
        ...super.props,
      ];
}
