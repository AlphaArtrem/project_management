// ignore_for_file: unused_import

import 'package:task_manager/business_layer/create_update_task/create_update_task_cubit.dart';
import 'package:task_manager/data_layer/models/project/project_model.dart';
import 'package:task_manager/data_layer/models/task/task_model.dart';
import 'package:task_manager/data_layer/static/api_constants.dart';
import 'package:task_manager/repositories/project/project_repository_interface.dart';
import 'package:task_manager/service_layer/api_service/api_service.dart';
import 'package:task_manager/service_layer/services_setup.dart';

///Repository to add and fetch projects
class ProjectRepository implements IProjectRepository {
  ///Constructor for [ProjectRepository]
  ProjectRepository(this.apiService);

  @override
  final ApiService apiService;

  ///Auth header for API calls
  Map<String, String> get authHeaders => apiService.authHeadersForTodoist;

  @override
  Future<List<ProjectModel>> getProjects() async {
    try {
      final result = await apiService.getRequest(
        APIConstants.projects,
        headers: authHeaders,
        parseResponseToMap: false,
      );
      if (result.statusCode == 200 && result.data != null) {
        final projectList = result.data!['data'] as List;
        final projects = <ProjectModel>[];
        for (final project in projectList) {
          if (project is Map<String, dynamic>) {
            projects.add(ProjectModel.fromJson(project));
          }
        }
        return projects;
      } else {
        throw Exception(apiService.parseErrorStatus(result.statusCode));
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProjectModel> addProject(String title) async {
    try {
      final result = await apiService.postRequest(
        APIConstants.projects,
        {'name': title},
        headers: authHeaders,
      );
      if (result.statusCode == 200 && result.data != null) {
        return ProjectModel.fromJson(result.data!);
      } else {
        throw Exception(apiService.parseErrorStatus(result.statusCode));
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<TaskModel>> getTasks(String projectID) async {
    try {
      final result = await apiService.getRequest(
        APIConstants.getTasks(projectID),
        headers: authHeaders,
        parseResponseToMap: false,
      );
      if (result.statusCode == 200 && result.data != null) {
        final taskList = result.data!['data'] as List;
        final tasks = <TaskModel>[];
        for (final task in taskList) {
          if (task is Map<String, dynamic>) {
            tasks.add(TaskModel.fromJson(task));
          }
        }
        return tasks;
      } else {
        throw Exception(apiService.parseErrorStatus(result.statusCode));
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TaskModel> addTask(CreateTaskState createTaskState) async {
    try {
      final result = await apiService.postRequest(
        APIConstants.tasks,
        createTaskState.toJson(),
        headers: authHeaders,
      );
      if (result.statusCode == 200 && result.data != null) {
        return TaskModel.fromJson(result.data!);
      } else {
        throw Exception(apiService.parseErrorStatus(result.statusCode));
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final result = await apiService.postRequest(
        '${APIConstants.tasks}/${task.id}',
        task.updateTaskJson(),
        headers: authHeaders,
      );
      if (result.statusCode == 200 && result.data != null) {
        return TaskModel.fromJson(result.data!);
      } else {
        throw Exception(apiService.parseErrorStatus(result.statusCode));
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> closeTask(TaskModel task) async {
    try {
      final result = await apiService.postRequest(
        APIConstants.closeTask(task.id),
        task.updateTaskJson(),
        headers: authHeaders,
        parseResponseToMap: false,
        successCodes: [204],
      );
      if (result.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }
}
