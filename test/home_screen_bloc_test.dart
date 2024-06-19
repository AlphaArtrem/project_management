import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/business_layer/add_project/add_project_cubit.dart';
import 'package:task_manager/business_layer/home_screen/home_screen_bloc.dart';
import 'package:task_manager/data_layer/models/project/project_model.dart';

import 'repository/api_service_dummy.dart';
import 'repository/app_service_dummy.dart';
import 'repository/project_repository_dummy.dart';

void main() async {
  final file = File('${Directory.current.path}/test/json_data/test_data.json');
  final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  final appConfigService = AppConfigServiceDummy();
  final apiService = ApiServiceDummy(appConfigService);
  final projectRepositoryDummy = ProjectRepositoryDummy(json, apiService);
  final projects = await projectRepositoryDummy.getProjects();

  group('Chat Flow Test', () {
    late HomeScreenBloc homeScreenBloc;

    setUp(() {
      homeScreenBloc = HomeScreenBloc(projectRepositoryDummy);
    });

    test('Initial HomeScreenBloc State Test', () {
      expect(
        homeScreenBloc.state,
        equals(const InitialHomeScreenState()),
        reason: 'Initial HomeScreenBloc state should be InitialHomeScreenState',
      );

      expect(
        homeScreenBloc.state.error.isEmpty,
        equals(true),
        reason: 'Initial HomeScreenBloc error should be empty',
      );

      expect(
        homeScreenBloc.state.isLoading,
        equals(true),
        reason: 'Initial HomeScreenBloc state should be loading',
      );
    });

    blocTest<HomeScreenBloc, HomeScreenState>(
      'On LoadHomeScreenEvent Projects should be fetched from '
      'the IProjectRepository implementation',
      build: () => homeScreenBloc,
      act: (bloc) => bloc.add(const LoadHomeScreenEvent()),
      expect: () async => [
        LoadedHomeScreenState(
          projects: await projectRepositoryDummy.getProjects(),
        ),
      ],
    );

    blocTest<HomeScreenBloc, HomeScreenState>(
      'On AddProjectEvent Projects should be added to HomeScreenState '
      'as well as to IProjectRepository implementation storage',
      build: () => HomeScreenBloc(
        projectRepositoryDummy,
        initialState: LoadedHomeScreenState(projects: projects),
      ),
      act: (bloc) async => bloc.add(
        AddProjectEvent(
          await projectRepositoryDummy.addProject('New Project'),
        ),
      ),
      expect: () async => [
        LoadedHomeScreenState(
          projects: [
            (await projectRepositoryDummy.getProjects()).last,
            ...projects,
          ],
        ),
      ],
    );
  });
}
