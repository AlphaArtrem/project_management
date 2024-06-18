import 'package:task_manager/data_layer/api/call_outcome.dart';
import 'package:task_manager/service_layer/api_service/api_service_interface.dart';

class ApiServiceDummy extends IApiService {
  ApiServiceDummy(super.appConfigService);

  @override
  Future<CallOutcome<Map<String, dynamic>>> getRequest(
    String apiPath, {
    Map<String, String>? headers,
    bool useBaseUrl = true,
  }) async {
    return CallOutcome<Map<String, dynamic>>(statusCode: 200, data: {});
  }

  @override
  String parseErrorStatus(int statusCode) {
    return 'Error';
  }

  @override
  Future<CallOutcome<Map<String, dynamic>>> patchRequest(
    String apiPath,
    Map<String, dynamic> postData, {
    Map<String, String>? headers,
    bool useBaseUrl = true,
  }) async {
    return CallOutcome<Map<String, dynamic>>(statusCode: 200, data: {});
  }

  @override
  Future<CallOutcome<Map<String, dynamic>>> postRequest(
    String apiPath,
    Map<String, dynamic> postData, {
    Map<String, String>? headers,
    bool useBaseUrl = true,
  }) async {
    return CallOutcome<Map<String, dynamic>>(statusCode: 200, data: {});
  }

  @override
  Future<CallOutcome<Map<String, dynamic>>> putRequest(
    String apiPath,
    Map<String, dynamic> postData, {
    Map<String, String>? headers,
    bool useBaseUrl = true,
  }) async {
    return CallOutcome<Map<String, dynamic>>(statusCode: 200, data: {});
  }
}
