import 'package:task_manager/data_layer/models/comment/comment_model.dart';
import 'package:task_manager/service_layer/api_service/api_service_interface.dart';

///Interface for making API requests for comments
abstract class ICommentsRepository {
  ///Default constructor for [ICommentsRepository].
  ///Takes [IApiService] as a parameter
  ICommentsRepository(this.apiService);

  ///[IApiService] implementation to make API  calls
  final IApiService apiService;

  ///Function to get comments
  Future<List<CommentModel>> getComments(String taskID);

  ///Function to add comments
  Future<CommentModel> addComments(CommentModel comment);
}
