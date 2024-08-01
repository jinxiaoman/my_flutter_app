import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';

class ApiService extends GetxService {
  late Dio _dio;
  final StorageService _storageService = Get.find<StorageService>();

  Future<ApiService> init() async {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://api.example.com',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add token to header
        final token = _storageService.read<String>('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Handle response
        return handler.next(response);
      },
      onError: (DioError e, handler) async {
        // Handle error
        if (e.response?.statusCode == 401) {
          // Token expired, refresh token
          // Implement your token refresh logic here
        }
        return handler.next(e);
      },
    ));

    return this;
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path,
      {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response =
          await _dio.post(path, data: data, queryParameters: queryParameters);
      return response;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  // Add other HTTP methods as needed

  Exception _handleError(DioError e) {
    if (e.type == DioErrorType.connectTimeout ||
        e.type == DioErrorType.receiveTimeout) {
      return TimeoutException('连接超时');
    } else if (e.type == DioErrorType.response) {
      return ServerException('服务器错误: ${e.response?.statusCode}');
    } else {
      return NetworkException('网络错误: ${e.message}');
    }
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
}

class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}
