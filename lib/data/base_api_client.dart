import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tabapplication/res/constants/api_constants.dart';


import 'package:tabapplication/utils/errorhandling.dart';

class BaseApiClient {
 /*  String basicAuth = 'Basic ' +
      base64.encode(
        utf8.encode(
            '${AppConstants.authorization}:${AppConstants.authorization}'),
      ); */
  late final Dio _client = Dio(
    BaseOptions(
      baseUrl: ApiConstants.uatbaseUrl,
      // headers: { 'authorization': basicAuth},
      connectTimeout:
         120*1000, // Set connection timeout in milliseconds
      receiveTimeout:
         120*1000, // Set receive timeout in milliseconds
    ),
  )..interceptors.addAll([
      CustomInterceptor(),
      LoggingInterceptor(),
    ]);

  Future<dynamic> postCall(
    BuildContext context,
    String url,
    Map<String, dynamic> payload, {
    String contenType = "application/json",
  }) async {
    try {

      final response = await _client.post(
        url,
        data: payload,
        options: Options(
            headers: {'Content-Type': contenType}),
      );
      return response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.connectTimeout) {
        // Handle connection timeout error
        String errorMessage = "Connection timeout occurred.";
        ErrorHandlingUtils().showErrorDialog(context, errorMessage);
      } else if (error.type == DioErrorType.receiveTimeout) {
        // Handle receive timeout error
        String errorMessage = "Receive timeout occurred.";
        ErrorHandlingUtils().showErrorDialog(context, errorMessage);
      } else {
        // Handle other Dio errors
        String errorMessage = ErrorHandlingUtils.handleError(error, context);
        ErrorHandlingUtils().showErrorDialog(context, errorMessage);
      }
      return null;
    } catch (error) {
      // Handle other errors
      String errorMessage = ErrorHandlingUtils.handleError(error, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
      return null;
    }
  }

  Future<dynamic> getCall(
    BuildContext context,
    String url, {
    String contenType = "application/json",
  }) async {
    try {
      final response = await _client.get(
        url,
        options: Options(headers: {
          'Content-Type': contenType,
        }),
      );
        print(response.data);
      return response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.connectTimeout) {
        // Handle connection timeout error
        String errorMessage = "Connection timeout occurred.";
        ErrorHandlingUtils().showErrorDialog(context, errorMessage);
      } else if (error.type == DioErrorType.receiveTimeout) {
        // Handle receive timeout error
        String errorMessage = "Receive timeout occurred.";
        ErrorHandlingUtils().showErrorDialog(context, errorMessage);
      } else {
        // Handle other Dio errors
        String errorMessage = ErrorHandlingUtils.handleError(error, context);
        ErrorHandlingUtils().showErrorDialog(context, errorMessage);
      }
      return null;
    } catch (error) {
      // Handle other errors
      String errorMessage = ErrorHandlingUtils.handleError(error, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
      return null;
    }
    /*  catch (e) {
      EasyLoading.dismiss();
      print('error');
    } */
  }

  Future<dynamic> postMultipartCall(
      BuildContext context, String url, FormData formdata) async {
    try {
      final response = await _client.post(url, data: formdata);
      /*  print(response.data);
      print("payload ${formdata.files}"); */
      return response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.connectTimeout) {
        // Handle connection timeout error
        String errorMessage = "Connection timeout occurred.";
        ErrorHandlingUtils().showErrorDialog(context, errorMessage);
      } else if (error.type == DioErrorType.receiveTimeout) {
        // Handle receive timeout error
        String errorMessage = "Receive timeout occurred.";
        ErrorHandlingUtils().showErrorDialog(context, errorMessage);
      } else {
        // Handle other Dio errors
        String errorMessage = ErrorHandlingUtils.handleError(error, context);
        ErrorHandlingUtils().showErrorDialog(context, errorMessage);
      }
      return null;
    } catch (error) {
      // Handle other errors
      String errorMessage = ErrorHandlingUtils.handleError(error, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
      return null;
    }
    /*  catch (e) {
      EasyLoading.dismiss();
      print('error');
    } */
  }

  Future<dynamic> postAuthorizationCall(
    BuildContext context,
    String url,
    Map<String, dynamic> payload, {
    String contenType = "application/json",
    String? BearerToken,
  }) async {
    try {
      final response = await _client.post(
        url,
        data: payload,
        options: Options(headers: {
          'Content-Type': contenType,
          'Authorization': BearerToken,
        }),
      );
      /* print(response.data);
      print("postAuthorizationCall payload $payload"); */
      return response.data;
    } on DioError catch (error) {
      if (error.type == DioErrorType.connectTimeout) {
        // Handle connection timeout error
        String errorMessage = "Connection timeout occurred.";
        ErrorHandlingUtils().showErrorDialog(context, errorMessage);
      } else if (error.type == DioErrorType.receiveTimeout) {
        // Handle receive timeout error
        String errorMessage = "Receive timeout occurred.";
        ErrorHandlingUtils().showErrorDialog(context, errorMessage);
      } else {
        // Handle other Dio errors
        String errorMessage = ErrorHandlingUtils.handleError(error, context);
        ErrorHandlingUtils().showErrorDialog(context, errorMessage);
      }
      return null;
    } catch (error) {
      // Handle other errors
      String errorMessage = ErrorHandlingUtils.handleError(error, context);
      ErrorHandlingUtils().showErrorDialog(context, errorMessage);
      return null;
    }
    /*  catch (e) {
      EasyLoading.dismiss();
      print('error');
    } */
  }
}

class CustomInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // add custom header to request
    options.headers['Custom-Header'] = 'custom value';
    super.onRequest(options, handler);
  }
}

// LoggingInterceptor logs the request and response data
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('Sending request: ${options.uri}');
    debugPrint('Sending body: ${options.data}');
    debugPrint('Sending contentType: ${options.contentType}');
    debugPrint('Sending headers: ${options.headers}');
    debugPrint('Sending queryParameters: ${options.queryParameters}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('Received response: ${response.data}');
    super.onResponse(response, handler);
  }
}
