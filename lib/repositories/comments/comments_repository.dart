import 'package:task_manager/data_layer/models/comment/comment_model.dart';
import 'package:task_manager/data_layer/static/api_constants.dart';
import 'package:task_manager/repositories/comments/comments_interface.dart';
import 'package:task_manager/service_layer/api_service/api_service.dart';

///Repository to add and fetch comments
class CommentsRepository implements ICommentsRepository {
  ///Constructor fo [CommentsRepository]
  CommentsRepository(this.apiService);

  @override
  final ApiService apiService;

  ///Auth header for API calls
  Map<String, String> get authHeaders => apiService.authHeadersForTodoist;

  @override
  Future<List<CommentModel>> getComments(String taskID) async {
    try {
      final result = await apiService.getRequest(
        APIConstants.getTaskComments(taskID),
        headers: authHeaders,
        parseResponseToMap: false,
      );
      if (result.statusCode == 200 && result.data != null) {
        final commentsList = result.data!['data'] as List;
        final comments = <CommentModel>[];
        for (final comment in commentsList) {
          if (comment is Map<String, dynamic>) {
            comments.add(CommentModel.fromJson(comment));
          }
        }
        return comments;
      } else {
        throw Exception(apiService.parseErrorStatus(result.statusCode));
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CommentModel> addComments(CommentModel comment) async {
    try {
      final result = await apiService.postRequest(
        APIConstants.comments,
        comment.toJson(),
        headers: authHeaders,
      );
      if (result.statusCode == 200 && result.data != null) {
        return CommentModel.fromJson(result.data!);
      } else {
        throw Exception(apiService.parseErrorStatus(result.statusCode));
      }
    } catch (e) {
      rethrow;
    }
  }
}
