import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:swesshome/constants/api_paths.dart';
import 'package:swesshome/core/exceptions/connection_exception.dart';

class NetworkHelper {
  final Dio _dioInstance = Dio();

  NetworkHelper() {
    // Default base options:
    BaseOptions baseOptions = BaseOptions(
        baseUrl: baseUrl,
        method: 'Get',
        receiveTimeout: 70000,
        connectTimeout: 70000,
        sendTimeout: 70000,
        followRedirects: false,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        validateStatus: (status) {
          if (status != null) {
            return status <= 500;
          }
          return false;
        });
    _dioInstance.options = baseOptions;
    _dioInstance.options.responseType = ResponseType.plain;
    initializeInterceptors();
  }

  NetworkHelper.customBaseOptions(BaseOptions baseOptions) {
    _dioInstance.options = baseOptions;
    initializeInterceptors();
  }

  initializeInterceptors() {
    _dioInstance.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          if (kDebugMode) {
            print(error.message);
            print(error.response!.data);
          }
          handler.next(error);
        },
        onRequest: (requestOptions, handler) {
          if (kDebugMode) {
            print("${requestOptions.method} : ${requestOptions.uri}");
          }
          handler.next(requestOptions);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print(response.data);
          }
          handler.next(response);
        },
      ),
    );
  }

  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? header,
      String? token}) async {
    /* Check if there are missed data !!*/
    assert(_dioInstance.options.baseUrl != "",
        "Base url can not has blank value!");
    assert(url != "", "url can not has blank value!");
    assert(header == null || token == null,
        "you can not pass header and token together, put the token inside your passed header!!");
    /* Complete information */
    if (token != null) {
      _dioInstance.options.headers["authorization"] = 'Bearer $token';
    }
    if (header != null) {
      _dioInstance.options.headers = header;
    }
    /* Execute get method */

    Response response;
    try {
      response = await _dioInstance.get(url, queryParameters: queryParameters);
    } on DioError catch (e) {
      if (e.type == DioErrorType.other) {
        throw ConnectionException(errorMessage: "تحقق من اتصالك بالإنترنت");
      }
      if (kDebugMode) {
        print(e.message);
      }
      throw Exception(e.message);
    }
    return response;
  }

  Future<Response> post(String url, dynamic fromData,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? headers,
      String? token,
      Function(int)? onSendProgress}) async {
    /* Check if there are missed data !!*/
    assert(_dioInstance.options.baseUrl != "",
        "Base url can not has blank value!");
    assert(url != "", "url can not has blank value!");
    assert(headers == null || token == null,
        "you can not pass header and token together, put the token inside your passed header!!");
    /* Complete information */
    if (headers != null) {
      _dioInstance.options.headers = headers;
    }
    if (token != null) {
      _dioInstance.options.headers["authorization"] = 'Bearer $token';
    }

    /* Execute post method */
    Response response;
    try {
      response = await _dioInstance.post(
        url,
        data: fromData,
        queryParameters: queryParameters,
        onSendProgress: (sent, total) {
          if (onSendProgress != null) {
            onSendProgress(((sent / total) * 100).toInt());
          }
        },
      );
    } on DioError catch (e) {
      if (e.type == DioErrorType.other) {
        throw ConnectionException(errorMessage: "تحقق من اتصالك بالإنترنت");
      }
      if (kDebugMode) {
        print(e.message);
      }
      throw Exception(e.message);
    }
    return response;
  }

  Future<Response> patch(String url, Map<String, dynamic>? fromData,
      {Map<String, dynamic>? queryParameters,
      Map<String, String>? headers,
      String? token}) async {
    /* Check if there are missed data !!*/

    assert(_dioInstance.options.baseUrl != "",
        "Base url can not has blank value!");
    assert(url != "", "url can not has blank value!");
    assert(headers == null || token == null,
        "you can not pass header and token together, put the token inside your passed header!!");
    /* Complete information */

    if (headers != null) {
      _dioInstance.options.headers = headers;
    }
    if (token != null) {
      _dioInstance.options.headers["authorization"] = 'Bearer $token';
    }
    /* Execute post method */
    Response response;
    try {
      response = await _dioInstance.patch(url,
          data: fromData, queryParameters: queryParameters);
    } on DioError catch (e) {
      if (e.type == DioErrorType.other) {
        throw ConnectionException(errorMessage: "تحقق من اتصالك بالإنترنت");
      }
      if (kDebugMode) {
        print(e.message);
      }
      throw Exception(e.message);
    }
    return response;
  }

  Future<Response> delete(String url,
      {Map<String, dynamic>? fromData,
      Map<String, dynamic>? queryParameters,
      Map<String, String>? headers,
      String? token}) async {
    /* Check if there are missed data !!*/

    assert(_dioInstance.options.baseUrl != "",
        "Base url can not has blank value!");
    assert(url != "", "url can not has blank value!");
    assert(headers == null || token == null,
        "you can not pass header and token together, put the token inside your passed header!!");
    /* Complete information */

    if (headers != null) {
      _dioInstance.options.headers = headers;
    }
    if (token != null) {
      _dioInstance.options.headers["authorization"] = 'Bearer $token';
    }
    /* Execute post method */
    Response response;
    try {
      response = await _dioInstance.delete(url,
          data: fromData, queryParameters: queryParameters);
    } on DioError catch (e) {
      if (e.type == DioErrorType.other) {
        throw ConnectionException(errorMessage: "تحقق من اتصالك بالإنترنت");
      }
      if (kDebugMode) {
        print(e.message);
      }
      throw Exception(e.message);
    }
    return response;
  }
}
