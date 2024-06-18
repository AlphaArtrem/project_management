import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/business_layer/create_update_task/create_update_task_cubit.dart';

import 'repository/api_service_dummy.dart';
import 'repository/app_service_dummy.dart';
import 'repository/project_repository_dummy.dart';

void main() async {
  final file = File('${Directory.current.path}/test/json_data/test_data.json');
  final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  test('Project Repo Test', () async {
    final appConfigService = AppConfigServiceDummy();
    final apiService = ApiServiceDummy(appConfigService);
    final projectRepositoryDummy = ProjectRepositoryDummy(json, apiService);

    var projects = await projectRepositoryDummy.getProjects();

    expect(
      projects.length,
      equals(2),
      reason: 'List of projects fetched should be equal to test_data, '
          '2 in this case',
    );

    expect(
      projects.first.name,
      equals('Inbox'),
      reason: 'First project name will be inbox by default',
    );

    final newProject = await projectRepositoryDummy.addProject('New project');
    projects = await projectRepositoryDummy.getProjects();

    expect(
      projects.last.name,
      equals('New project'),
      reason: 'Last project should be newly added project',
    );

    expect(
      newProject.name,
      equals('New project'),
      reason: 'Returned project name should be to newly added project',
    );

    var tasks = await projectRepositoryDummy.getTasks(projects.first.id);

    expect(
      tasks.first.projectId,
      equals(projects.first.id),
      reason: 'Tasks projectID should match the passed project id',
    );

    final newTask = await projectRepositoryDummy
        .addTask(CreateTaskState(projectID: projects.first.id));

    tasks = await projectRepositoryDummy.getTasks(projects.first.id);

    expect(
      tasks.last.id,
      equals(newTask.id),
      reason: 'Last task id should match the added project id',
    );

    expect(
      newTask.projectId,
      equals(projects.first.id),
      reason: "Returned task's project id should match the passed project id",
    );

    final updatedTask = await projectRepositoryDummy.updateTask(
      newTask.copyWith(content: 'hello'),
    );
    tasks = await projectRepositoryDummy.getTasks(projects.first.id);

    expect(
      tasks.last.content,
      equals('hello'),
      reason: 'Updated task content should match',
    );

    expect(
      updatedTask.content,
      equals('hello'),
      reason: 'Returned Updated task content should match',
    );

    final deletedTask = tasks.last;
    await projectRepositoryDummy.closeTask(deletedTask);

    tasks = await projectRepositoryDummy.getTasks(projects.first.id);

    expect(
      tasks.contains(deletedTask),
      equals(false),
      reason: 'Closed task should be removed',
    );
  });
}
