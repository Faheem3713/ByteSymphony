import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  // LOGIN
  Future<String> login(String email, String password) async {
    final storage = const FlutterSecureStorage();
    final resp = await dio.post(
      '/api/auth/login',
      data: {'email': email, 'password': password},
    );

    final token = resp.data['token'] ?? resp.data['accessToken'] ?? resp.data;
    if (token is String) {
      await storage.write(key: 'jwt_token', value: token);
      return token;
    } else {
      throw Exception('Unexpected login token format');
    }
  }

  Future<Map<String, dynamic>> me() async {
    final r = await dio.get('/api/me');
    return r.data;
  }

  // CLIENTS
  Future<Map<String, dynamic>> getClients({
    int page = 1,
    int pageSize = 10,
    String? search,
    String? sortBy,
    String? sortDir, // 'asc' / 'desc'
  }) async {
    final q = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
      if (search != null && search.isNotEmpty) 'search': search,
      if (sortBy != null) 'sortBy': sortBy,
      if (sortDir != null) 'sortDir': sortDir,
    };
    final r = await dio.get('/api/clients', queryParameters: q);
    // expect server returns { items: [...], total: n } or just array - adapt accordingly
    return Map<String, dynamic>.from(r.data);
  }

  Future<Map<String, dynamic>> getClient(int id) async {
    final r = await dio.get('/api/clients/$id');
    return Map<String, dynamic>.from(r.data);
  }

  Future<Map<String, dynamic>> createClient(
    Map<String, dynamic> payload,
  ) async {
    final r = await dio.post('/api/clients', data: payload);
    return Map<String, dynamic>.from(r.data);
  }

  Future<Map<String, dynamic>> updateClient(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final r = await dio.put('/api/clients/$id', data: payload);
    return Map<String, dynamic>.from(r.data);
  }

  Future<void> deleteClient(int id) async {
    await dio.delete('/api/clients/$id');
  }

  // INVOICES
  Future<Map<String, dynamic>> getInvoices({
    int? clientId,
    String? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    final q = {
      'page': page,
      'pageSize': pageSize,
      if (clientId != null) 'clientId': clientId,
      if (status != null) 'status': status,
    };
    final r = await dio.get('/api/invoices', queryParameters: q);
    return Map<String, dynamic>.from(r.data);
  }

  Future<Map<String, dynamic>> createInvoice(
    Map<String, dynamic> payload,
  ) async {
    final r = await dio.post('/api/invoices', data: payload);
    return Map<String, dynamic>.from(r.data);
  }

  Future<Map<String, dynamic>> updateInvoice(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final r = await dio.put('/api/invoices/$id', data: payload);
    return Map<String, dynamic>.from(r.data);
  }
}
