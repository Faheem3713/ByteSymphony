import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://your-api-url.com', // replace when needed
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }
}
