import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:task/providers/auth_provider.dart';
import 'package:task/services/api_services.dart';

extension ClientRef on Ref {
  Dio get dio {
    final Dio dio =
        Dio(
            BaseOptions(
              baseUrl: 'https://www.bytesymphony.dev/TestAPI',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          )
          ..interceptors.add(
            InterceptorsWrapper(
              onRequest: (options, handler) async {
                final storage = const FlutterSecureStorage();
                final token = await storage.read(key: 'jwt_token');
                log('Added Authorization header ${options.headers}');
                if (token != null && token.isNotEmpty) {
                  options.headers['Authorization'] = 'Bearer $token';
                }
                return handler.next(options);
              },
              onResponse: (response, handler) {
                return handler.next(response);
              },
              onError: (error, handler) async {
                final response = error.response;
                final code = response?.statusCode;
                final message = _getErrorMessage(code);

                log('API Error: $code — ${error.message}');

                // Handle 401 specifically (token expired)
                if (code == 401) {
                  read(authNotifierProvider.notifier).logout();
                }

                return handler.next(error);
              },
            ),
          );
    return dio;
  }

  /// Error message mapper
  String _getErrorMessage(int? code) {
    switch (code) {
      case 400:
        return 'Invalid input. Please check your data and try again.';
      case 401:
        return 'Your session has expired. Please log in again.';
      case 404:
        return 'Requested data not found. Please check and try again.';
      case 500:
        return 'Internal server error. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  /// Show alert dialog if context is passed in request options
  void _showErrorDialogIfPossible(Map<String, dynamic> extras, String message) {
    final context = extras['context'] as BuildContext?;
    if (context == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(ref.dio);
});
