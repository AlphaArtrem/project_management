///Interface for app config service
abstract class IAppConfigService {
  ///App display name
  late final String appName;

  ///App backend base URL for API calls
  late final String baseUrl;

  ///Bearer token for todoist API calls
  late final String todoistBearerToken;

  ///Function to setup app config
  void configApp() {
    throw UnimplementedError();
  }
}
