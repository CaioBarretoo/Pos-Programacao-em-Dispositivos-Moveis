import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  factory DioClient({String baseUrl = "https://repetorio-api.onrender.com/"}) =>
      _instance.._baseUrl = baseUrl;

  DioClient._internal();

  late String _baseUrl;
  late Dio _dio;

  Dio get dio {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ));

    _dio.interceptors.add(ApiInterceptor());
    return _dio;
  }
}

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('Request: ${options.method} ${options.baseUrl}${options.path}');
    }
    options.headers['Authorization'] = 'Bearer seu_token_de_acesso';
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('Response: ${response.statusCode} ${response.data}');
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionTimeout) {
      if (kDebugMode) {
        print('Erro de tempo limite de conexão');
      }
    } else if (err.response != null) {
      if (err.response!.statusCode! >= 400) {
        if (kDebugMode) {
          print('Erro do servidor: ${err.response!.statusCode}');
        }
        // Lógica para lidar com erros do servidor
      }
    } else {
      if (kDebugMode) {
        print('Erro desconhecido: ${err.message}');
      }
      // Lógica para lidar com erros desconhecidos
    }
    return handler.next(err);
  }
}
