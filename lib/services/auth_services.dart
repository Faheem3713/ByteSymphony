import 'package:dio/dio.dart';
import 'package:task/core/network/dio_client.dart';

class AuthServices {
  final Dio _dio = DioClient().dio;

  Future<Response> login(String email, String password) async {
    return _dio.post('/login', data: {'email': email, 'password': password});
  }
}
