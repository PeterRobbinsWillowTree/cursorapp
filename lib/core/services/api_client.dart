import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  final bool isOffline;

  ApiClient({required this.dio, this.isOffline = false});

  Future<Response> get(String path) async {
    if (isOffline) {
      throw OfflineModeException();
    }
    return dio.get(path);
  }

  Future<Response> post(String path, {dynamic data}) async {
    if (isOffline) {
      throw OfflineModeException();
    }
    return dio.post(path, data: data);
  }
}

class OfflineModeException implements Exception {
  String get message => 'App is running in offline mode';
} 