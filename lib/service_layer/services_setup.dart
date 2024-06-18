import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/business_layer/add_project/add_project_cubit.dart';
import 'package:task_manager/business_layer/comments/comments_cubit.dart';
import 'package:task_manager/business_layer/create_update_task/create_update_task_cubit.dart';
import 'package:task_manager/business_layer/home_screen/home_screen_bloc.dart';
import 'package:task_manager/business_layer/project_overview/project_overview_bloc.dart';
import 'package:task_manager/business_layer/theme/theme_cubit.dart';
import 'package:task_manager/data_layer/models/comment/comment_model.dart';
import 'package:task_manager/data_layer/models/task/task_model.dart';
import 'package:task_manager/data_layer/models/task_history_model/task_history_model.dart';
import 'package:task_manager/data_layer/models/time_tracking/task_time_tracking.dart';
import 'package:task_manager/repositories/comments/comments_repository.dart';
import 'package:task_manager/repositories/history_repository/task_history_repository.dart';
import 'package:task_manager/repositories/project/project_repository.dart';
import 'package:task_manager/repositories/time_tracking/time_tracking_repository.dart';
import 'package:task_manager/service_layer/api_service/api_service.dart';
import 'package:task_manager/service_layer/app_config/app_config_service.dart';
import 'package:task_manager/service_layer/local_storage/local_storage_service.dart';
import 'package:task_manager/service_layer/navigation/navigation_sevice.dart';
import 'package:task_manager/service_layer/routes/app_router_service.dart';

///Service locator to get dependencies
GetIt serviceLocator = GetIt.instance;

///Service to manage in app navigation
final navigationService = serviceLocator<NavigationService>();

///Service to manage app theme
final themeService = serviceLocator<ThemeCubit>();

///Service to manage API calls
final apiService = serviceLocator<ApiService>();

///Service to manage app configurations
final appConfig = serviceLocator<AppConfigService>();

///Function to setup app services. Should be called before running the app.
Future<void> setupServiceLocator() async {
  serviceLocator
    ..registerSingleton(AppRoutersService())
    ..registerSingleton(AppConfigService())
    ..registerSingleton(
      NavigationService(serviceLocator.get<AppRoutersService>()),
    )
    ..registerSingleton(ThemeCubit(ThemeState(isLight: true)))
    ..registerSingleton(ApiService(appConfig))
    ..registerSingleton(ProjectRepository(apiService))
    ..registerSingleton(CommentsRepository(apiService))
    ..registerSingleton(
      TimeTrackingRepository(LocalStorageService.timeTrackingBox),
    )
    ..registerSingleton(
      TaskHistoryRepository(
        taskHistoryBox: LocalStorageService.taskHistoryBox,
        historyTaskIdToIndexBox: LocalStorageService.historyTaskIdToIndexBox,
      ),
    )
    ..registerLazySingleton<HomeScreenBloc>(
      () => HomeScreenBloc(serviceLocator.get<ProjectRepository>())
        ..add(const LoadHomeScreenEvent()),
    )
    ..registerFactory<AddProjectCubit>(
      () => AddProjectCubit(serviceLocator.get<ProjectRepository>()),
    )
    ..registerLazySingleton<ProjectOverviewBloc>(
      () => ProjectOverviewBloc(serviceLocator.get<ProjectRepository>()),
    )
    ..registerFactory<CreateUpdateTaskCubit>(
      () => CreateUpdateTaskCubit(
        projectRepository: serviceLocator.get<ProjectRepository>(),
        timeTrackingRepository: serviceLocator.get<TimeTrackingRepository>(),
        taskHistoryRepository: serviceLocator.get<TaskHistoryRepository>(),
      ),
    )
    ..registerFactory<CommentsCubit>(
      () => CommentsCubit(serviceLocator.get<CommentsRepository>()),
    );
}

///Setup hive and register it's adapters
Future<void> setupHive() async {
  await Hive.initFlutter();
  Hive
    ..registerAdapter(TaskTimeTackingAdapter())
    ..registerAdapter(TaskModelAdapter())
    ..registerAdapter(CommentModelAdapter())
    ..registerAdapter(TaskHistoryModelAdapter());
  await LocalStorageService.init();
}
