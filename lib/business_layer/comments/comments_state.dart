part of 'comments_cubit.dart';

///abstract State for [CommentsCubit]
abstract class CommentsState extends Equatable {
  ///[CommentsState] default constructor
  const CommentsState({
    this.isLoading = false,
    this.error = '',
  });

  ///Is the cubit in loading state
  final bool isLoading;

  ///Error while creating updating task
  final String error;

  ///Copy constructor for [CommentsState]
  CommentsState copyWith({
    String? error,
    bool? isLoading,
  });

  @override
  List<Object?> get props => [
        isLoading,
        error,
      ];
}

///Initial State for [CommentsCubit]
class InitialCommentsState extends CommentsState {
  ///[CommentsState] default constructor
  const InitialCommentsState({
    super.isLoading = true,
    super.error = '',
  });

  ///Copy constructor for [CommentsState]
  @override
  InitialCommentsState copyWith({
    String? error,
    bool? isLoading,
  }) {
    return InitialCommentsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
      ];
}

///[LoadedCommentsState] State for [CommentsCubit]
class LoadedCommentsState extends CommentsState {
  ///[LoadedCommentsState] default constructor
  const LoadedCommentsState({
    required this.taskID,
    this.comments = const [],
    super.isLoading = false,
    super.error,
  });

  ///Task id
  final String taskID;

  ///List of comments for this task
  final List<CommentModel> comments;

  ///Copy constructor for [CommentsState]
  @override
  LoadedCommentsState copyWith({
    String? error,
    bool? isLoading,
    String? taskID,
    List<CommentModel>? comments,
  }) {
    return LoadedCommentsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      taskID: taskID ?? this.taskID,
      comments: comments ?? this.comments,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        comments,
        taskID,
      ];
}
