import 'package:task_manager/business_layer/create_update_task/create_update_task_cubit.dart';
import 'package:task_manager/data_layer/models/project/project_model.dart';
import 'package:task_manager/data_layer/models/task/task_model.dart';
import 'package:task_manager/service_layer/api_service/api_service_interface.dart';

///Interface for making API requests
abstract class IProjectRepository {
  ///Default constructor for [IProjectRepository].
  ///Takes [IApiService] as a parameter
  IProjectRepository(this.apiService);

  ///[IApiService] implementation to make API  calls
  final IApiService apiService;

  ///Function to get projects
  Future<List<ProjectModel>> getProjects();

  ///Function to add projects
  Future<ProjectModel> addProject(String title);

  ///Function to get tasks of a project
  Future<List<TaskModel>> getTasks(String projectID);

  ///Function to add task to a project
  Future<TaskModel> addTask(CreateTaskState createTaskState);

  ///Function to update task
  Future<TaskModel> updateTask(TaskModel task);

  ///Function to close a Task
  Future<bool> closeTask(TaskModel task);
}
