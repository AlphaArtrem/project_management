import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/data_layer/models/comment/comment_model.dart';
import 'package:task_manager/repositories/comments/comments_interface.dart';
import 'package:task_manager/repositories/project/project_repository_interface.dart';

part 'comments_state.dart';

///Cubit to view and add comments
class CommentsCubit extends Cubit<CommentsState> {
  ///[CommentsCubit] default constructor
  CommentsCubit(this.commentsRepository) : super(const InitialCommentsState());

  ///Implementation of [IProjectRepository] to create tasks
  final ICommentsRepository commentsRepository;

  Future<void> init(String taskID) async {
    if (state is! InitialCommentsState) {
      return;
    }
    emit(state.copyWith(error: '', isLoading: true));
    try {
      final comments = await commentsRepository.getComments(taskID);
      emit(LoadedCommentsState(comments: comments, taskID: taskID));
    } catch (e) {
      emit(
        state.copyWith(
          error: e.toString().replaceFirst('Exception: ', ''),
          isLoading: false,
        ),
      );
    }
  }

  Future<CommentModel?> addComment(String content) async {
    if (state is LoadedCommentsState) {
      final state = this.state as LoadedCommentsState;
      emit(state.copyWith(error: '', isLoading: true));
      try {
        final comment = await commentsRepository.addComments(
          CommentModel(
            content: content,
            taskId: state.taskID,
          ),
        );
        emit(state.copyWith(comments: [comment, ...state.comments]));
        return comment;
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
}
