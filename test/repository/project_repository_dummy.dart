import 'package:task_manager/business_layer/create_update_task/create_update_task_cubit.dart';
import 'package:task_manager/data_layer/models/project/project_model.dart';
import 'package:task_manager/data_layer/models/task/task_model.dart';
import 'package:task_manager/repositories/project/project_repository_interface.dart';
import 'package:task_manager/service_layer/api_service/api_service_interface.dart';

class ProjectRepositoryDummy extends IProjectRepository {
  ProjectRepositoryDummy(this.json, IApiService apiService) : super(apiService);

  final Map<String, dynamic> json;

  @override
  Future<ProjectModel> addProject(String title) async {
    (json['projects'] as List).add({
      'id': '2334924851',
      'name': title,
      'comment_count': 0,
    });
    return ProjectModel.fromJson(
      (json['projects'] as List).last as Map<String, dynamic>,
    );
  }

  @override
  Future<TaskModel> addTask(CreateTaskState createTaskState) async {
    (json['tasks'] as List).add({
      'id': '123456789',
      'project_id': createTaskState.projectID,
      'content': createTaskState.content,
      'description': createTaskState.description,
      'labels': createTaskState.labels,
      'comment_count': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
    return TaskModel.fromJson(
      (json['tasks'] as List).last as Map<String, dynamic>,
    );
  }

  @override
  Future<bool> closeTask(TaskModel task) async {
    (json['tasks'] as List).removeWhere(
        (taskJson) => (taskJson as Map<String, dynamic>)['id'] == task.id);
    return true;
  }

  @override
  Future<List<ProjectModel>> getProjects() async {
    final list = <ProjectModel>[];
    final projects = json['projects'] as List;
    for (var i = 0; i < projects.length; i++) {
      list.add(
        ProjectModel.fromJson(
          projects[i] as Map<String, dynamic>,
        ),
      );
    }
    return list;
  }

  @override
  Future<List<TaskModel>> getTasks(String projectID) async {
    final list = <TaskModel>[];
    final tasks = json['tasks'] as List;
    for (var i = 0; i < tasks.length; i++) {
      final task = TaskModel.fromJson(
        tasks[i] as Map<String, dynamic>,
      );
      if (task.projectId == projectID) {
        list.add(task);
      }
    }
    return list;
  }

  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    var index = -1;
    for (var i = 0; i < (json['tasks'] as List).length; i++) {
      final temp = TaskModel.fromJson(
        (json['tasks'] as List)[i] as Map<String, dynamic>,
      );
      if (task.id == temp.id) {
        index = i;
        break;
      }
    }
    for (final key in task.updateTaskJson().keys) {
      ((json['tasks'] as List)[index] as Map<String, dynamic>)[key] =
          task.updateTaskJson()[key];
    }
    return TaskModel.fromJson(
        (json['tasks'] as List)[index] as Map<String, dynamic>);
  }
}
