part of 'add_project_cubit.dart';

///abstract State for [AddProjectCubit]
class AddProjectState extends Equatable {
  ///[AddProjectState] default constructor
  const AddProjectState({
    this.isLoading = false,
    this.error = '',
  });

  ///Is the cubit in loading state
  final bool isLoading;

  ///Error while creating updating task
  final String error;

  ///Copy constructor for [AddProjectState]
  AddProjectState copyWith({
    String? error,
    bool? isLoading,
  }) {
    return AddProjectState(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
      ];
}
