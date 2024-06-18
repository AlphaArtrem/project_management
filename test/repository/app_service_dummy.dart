import 'package:task_manager/service_layer/app_config/app_config_service_interface.dart';

class AppConfigServiceDummy extends IAppConfigService {
  AppConfigServiceDummy() {
    configApp();
  }

  @override
  void configApp() {
    appName = 'appName';
    baseUrl = 'baseUrl';
    todoistBearerToken = 'todoistBearerToken';
  }
}
