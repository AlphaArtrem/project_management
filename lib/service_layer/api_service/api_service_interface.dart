import 'package:task_manager/data_layer/api/call_outcome.dart';
import 'package:task_manager/service_layer/app_config/app_config_service_interface.dart';

///Interface for making API requests
abstract class IApiService {
  ///Default constructor for [IApiService].
  ///Takes [IAppConfigService] as a parameter
  IApiService(this.appConfigService);

  ///[IAppConfigService] implementation to fetch app details
  ///like baseUrl
  final IAppConfigService appConfigService;

  ///Auth headers for todoist APIs
  Map<String, String> get authHeadersForTodoist => {};

  ///Function for GET API requests
  Future<CallOutcome<Map<String, dynamic>>> getRequest(
    String apiPath, {
    Map<String, String>? headers,
    bool useBaseUrl = true,
  });

  ///Function for POST API requests
  Future<CallOutcome<Map<String, dynamic>>> postRequest(
    String apiPath,
    Map<String, dynamic> postData, {
    Map<String, String>? headers,
    bool useBaseUrl = true,
  });

  ///Function for PATCH API requests
  Future<CallOutcome<Map<String, dynamic>>> patchRequest(
    String apiPath,
    Map<String, dynamic> postData, {
    Map<String, String>? headers,
    bool useBaseUrl = true,
  });

  ///Function for PUT API requests
  Future<CallOutcome<Map<String, dynamic>>> putRequest(
    String apiPath,
    Map<String, dynamic> postData, {
    Map<String, String>? headers,
    bool useBaseUrl = true,
  });

  ///Parse status codes other than 200 and 204
  String parseErrorStatus(int statusCode);
}
