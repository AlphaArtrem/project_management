import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/data_layer/models/project/project_model.dart';
import 'package:task_manager/data_layer/models/task/task_model.dart';
import 'package:task_manager/presentation_layer/add_project/add_project.dart';
import 'package:task_manager/presentation_layer/create_update_task/create_update_task_screen.dart';
import 'package:task_manager/presentation_layer/history/history_screen.dart';
import 'package:task_manager/presentation_layer/home/home_screen.dart';
import 'package:task_manager/presentation_layer/project_overview/project_overview_screen.dart';
import 'package:task_manager/presentation_layer/splash_screen.dart';
import 'package:task_manager/service_layer/routes/app_router_service_interface.dart';

///[IAppRouterService] implementation to manage app routes
class AppRoutersService implements IAppRouterService {
  @override
  BuildContext get context =>
      router.routeInformationParser.configuration.navigatorKey.currentContext!;

  @override
  final GoRouter router = GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: SplashScreen.route.path,
    routes: [
      GoRoute(
        path: SplashScreen.route.path,
        name: SplashScreen.route.name,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: SplashScreen(),
          );
        },
      ),
      GoRoute(
        path: HomeScreen.route.path,
        name: HomeScreen.route.name,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: HomeScreen(),
          );
        },
      ),
      GoRoute(
        path: ProjectOverviewScreen.route.path,
        name: ProjectOverviewScreen.route.name,
        pageBuilder: (context, state) {
          assert(
            state.extra is ProjectModel,
            'extra needs to be passed with type [ProjectModel]',
          );

          return MaterialPage(
            child: ProjectOverviewScreen(
              projectModel: state.extra! as ProjectModel,
            ),
          );
        },
      ),
      GoRoute(
        path: CreateUpdateTaskScreen.route.path,
        name: CreateUpdateTaskScreen.route.name,
        pageBuilder: (context, state) {
          assert(
            state.extra is ProjectModel || state.extra is TaskModel,
            'extra needs to be passed with type [ProjectModel] or [TaskModel]',
          );

          final projectModel =
              state.extra is ProjectModel ? state.extra! as ProjectModel : null;
          final taskModel =
              state.extra is TaskModel ? state.extra! as TaskModel : null;

          return MaterialPage(
            child: CreateUpdateTaskScreen(
              projectModel: projectModel,
              taskModel: taskModel,
            ),
          );
        },
      ),
      GoRoute(
        path: HistoryScreen.route.path,
        name: HistoryScreen.route.name,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: HistoryScreen(),
          );
        },
      ),
      GoRoute(
        path: AddProjectScreen.route.path,
        name: AddProjectScreen.route.name,
        pageBuilder: (context, state) {
          return MaterialPage(
            child: AddProjectScreen(),
          );
        },
      ),
    ],
    errorPageBuilder: (context, state) {
      return const MaterialPage(
        child: Center(
          child: Text(
            'Page not found',
          ),
        ),
      );
    },
  );
}
