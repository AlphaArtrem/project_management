import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:task_manager/data_layer/api/call_outcome.dart';
import 'package:task_manager/service_layer/api_service/api_service_interface.dart';
import 'package:task_manager/service_layer/app_config/app_config_service.dart';

///[IApiService] implementation for making API requests
class ApiService implements IApiService {
  ///Default constructor for [ApiService].
  ///Takes [AppConfigService] as a parameter
  ApiService(this.appConfigService);

  ///[Logger] instance to print console logs
  final Logger log = Logger(
    printer: PrettyPrinter(methodCount: 4, lineLength: 1000),
    filter: ProductionFilter(),
    level: Level.debug,
  );

  @override
  final AppConfigService appConfigService;

  @override
  Future<CallOutcome<Map<String, dynamic>>> getRequest(
    String apiPath, {
    Map<String, String>? headers,
    bool useBaseUrl = true,
    List<int> successCodes = const [200],
    bool parseResponseToMap = true,
  }) async {
    try {
      final result = await http.get(
        Uri.parse(useBaseUrl ? appConfigService.baseUrl + apiPath : apiPath),
        headers: headers,
      );
      if (successCodes.contains(result.statusCode)) {
        if (parseResponseToMap) {
          final data = jsonDecode(result.body) as Map<String, dynamic>;
          log.d(data);
          return CallOutcome<Map<String, dynamic>>(
            data: data,
            statusCode: result.statusCode,
          );
        } else {
          log.d(result.body);
          return CallOutcome<Map<String, dynamic>>(
            data: {
              'data': jsonDecode(result.body),
            },
            statusCode: result.statusCode,
          );
        }
      } else {
        log.e(result.body);
        return CallOutcome(
          exception: Exception(result.body),
          data: parseResponseToMap
              ? jsonDecode(result.body) as Map<String, dynamic>
              : {
                  'data': result.body,
                },
          statusCode: result.statusCode,
        );
      }
    } catch (e) {
      log.e(e);
      return CallOutcome<Map<String, dynamic>>(
        exception: e is Exception ? e : Exception(e),
        statusCode: 0,
      );
    }
  }

  @override
  Future<CallOutcome<Map<String, dynamic>>> patchRequest(
    String apiPath,
    Map<String, dynamic> postData, {
    Map<String, String>? headers,
    bool useBaseUrl = true,
    List<int> successCodes = const [200],
    bool parseResponseToMap = true,
  }) {
    // TODO(Yash): implement patchRequest
    throw UnimplementedError();
  }

  @override
  Future<CallOutcome<Map<String, dynamic>>> postRequest(
    String apiPath,
    Map<String, dynamic> postData, {
    Map<String, String>? headers,
    bool useBaseUrl = true,
    List<int> successCodes = const [200],
    bool parseResponseToMap = true,
  }) async {
    try {
      final result = await http.post(
        Uri.parse(useBaseUrl ? appConfigService.baseUrl + apiPath : apiPath),
        headers: headers,
        body: jsonEncode(postData),
      );
      if (successCodes.contains(result.statusCode)) {
        if (parseResponseToMap) {
          final data = jsonDecode(result.body) as Map<String, dynamic>;
          log.d(data);
          return CallOutcome<Map<String, dynamic>>(
            data: data,
            statusCode: result.statusCode,
          );
        } else {
          log.d(result.body);
          return CallOutcome<Map<String, dynamic>>(
            data: {
              'data': result.body,
            },
            statusCode: result.statusCode,
          );
        }
      } else {
        log.e(result.body);
        return CallOutcome(
          exception: Exception(result.body),
          data: parseResponseToMap
              ? jsonDecode(result.body) as Map<String, dynamic>
              : {
                  'data': result.body,
                },
          statusCode: result.statusCode,
        );
      }
    } on Exception catch (e) {
      log.e(e);
      return CallOutcome<Map<String, dynamic>>(
        exception: e,
        statusCode: 0,
      );
    }
  }

  @override
  Future<CallOutcome<Map<String, dynamic>>> putRequest(
    String apiPath,
    Map<String, dynamic> postData, {
    Map<String, String>? headers,
    bool useBaseUrl = true,
    List<int> successCodes = const [200],
    bool parseResponseToMap = true,
  }) {
    // TODO(Yash): implement putRequest
    throw UnimplementedError();
  }

  @override
  Map<String, String> get authHeadersForTodoist => {
        'Authorization': 'Bearer ${appConfigService.todoistBearerToken}',
        'Content-Type': 'application/json',
      };

  @override
  String parseErrorStatus(int statusCode) {
    if (statusCode >= 400 && statusCode < 500) {
      return 'The request was processed with an error. '
          'The request was invalid and should not be retried unmodified.';
    } else if (statusCode >= 500 && statusCode < 600) {
      return 'The request failed due to a server error, '
          "it's safe to retry later.";
    } else {
      return 'Something went wrong, try again later.';
    }
  }
}
