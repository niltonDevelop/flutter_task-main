import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertask/core/constants/option.dart';
import 'package:fluttertask/core/network/dio_client.dart';
import 'package:fluttertask/core/network/models/api_response.dart';
import 'package:logging/logging.dart';

typedef FromJson<T> = T Function(Map<String, dynamic>);

class ApiService {
  // final Dio _dio = DioClient().dio;
  final _dioReqRes = DioClient(baseUrl: dotenv.env['REQRES_URL']!).dio;
  final _dioTask = DioClient(baseUrl: dotenv.env['JSONPLACEHOLDER_URL']!).dio;
  final _logger = Logger('ApiService');

  Future<ApiResponse<List<T>>> getList<T>({
    required String endpoint,
    required FromJson<T> fromJson,
    Map<String, dynamic>? queryParameters,
    required int baseUrl,
  }) async {
    try {
      final dio = baseUrl == BaseUrl.reqReslUrl ? _dioReqRes : _dioTask;
      final response = await dio.get<List<dynamic>>(
        endpoint,
        queryParameters: queryParameters,
      );
      final data = response.data;

      if (data == null) {
        throw Exception('''
        Respuesta del servidor inválida.

        Lista de datos nula.
        ''');
      }

      return ApiResponse.success(
        data: data.map((e) => fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (error, stackTrace) {
      return _handleError(error, stackTrace);
    }
  }

  Future<ApiResponse<T?>> get<T>({
    required String endpoint,
    required FromJson<T> fromJson,
    Map<String, dynamic>? queryParameters,
    required int baseUrl,
  }) async {
    assert(T is! List, 'Use `getList` for list responses');
    try {
      final dio = baseUrl == BaseUrl.reqReslUrl ? _dioReqRes : _dioTask;
      final response = await dio.get<Map<String, dynamic>>(
        endpoint,
        queryParameters: queryParameters,
      );
      final data = response.data?['data'] ?? {};
      return ApiResponse.success(data: data == null ? null : fromJson(data));
    } catch (error, stackTrace) {
      return _handleError(error, stackTrace);
    }
  }

  Future<ApiResponse<dynamic>> post({
    required String endpoint,
    Map<String, dynamic>? data,
    required int baseUrl,
  }) async {
    try {
      final dio = baseUrl == BaseUrl.reqReslUrl ? _dioReqRes : _dioTask;
      final result = await dio.post<dynamic>(endpoint, data: data);
      return ApiResponse(data: result);
    } catch (error, stackTrace) {
      return _handleError(error, stackTrace);
    }
  }

  Future<ApiResponse<dynamic>> put({
    required String endpoint,
    Map<String, dynamic>? data,
    required int baseUrl,
  }) async {
    try {
      final dio = baseUrl == BaseUrl.reqReslUrl ? _dioReqRes : _dioTask;
      await dio.put<dynamic>(endpoint, data: data);
      return const ApiResponse();
    } catch (error, stackTrace) {
      return _handleError(error, stackTrace);
    }
  }

  Future<ApiResponse<dynamic>> putList({
    required String endpoint,
    required List<Map<String, dynamic>> data,
  }) async {
    try {
      await _dioReqRes.put<dynamic>(endpoint, data: data);
      return const ApiResponse();
    } catch (error, stackTrace) {
      return _handleError(error, stackTrace);
    }
  }

  Future<ApiResponse<dynamic>> delete({
    required String endpoint,
    Map<String, dynamic>? data,
    required int baseUrl,
  }) async {
    try {
      final dio = baseUrl == BaseUrl.reqReslUrl ? _dioReqRes : _dioTask;
      await dio.delete<dynamic>(endpoint, data: data);
      return const ApiResponse();
    } catch (error, stackTrace) {
      return _handleError(error, stackTrace);
    }
  }

  ApiResponse<T> _handleError<T>(Object error, StackTrace stackTrace) {
    if (error is DioException) {
      return ApiResponse.error(message: _getErrorMessage(error));
    }
    _logger.severe('Error en la petición', error, stackTrace);
    return ApiResponse.error(message: error.toString());
  }

  String _getErrorMessage(DioException error) => switch (error.type) {
    DioExceptionType.connectionTimeout => 'Tiempo de conexión agotado',
    DioExceptionType.sendTimeout => 'Tiempo de envío agotado',
    DioExceptionType.receiveTimeout => 'Tiempo de respuesta agotado',
    DioExceptionType.badResponse => _decipherError(error),
    DioExceptionType.cancel => 'Solicitud cancelada',
    DioExceptionType.badCertificate => 'Certificado SSL inválido',
    DioExceptionType.connectionError => 'Error de conexión',
    DioExceptionType.unknown => error.message.toString(),
  };

  String _decipherError(DioException error) {
    if (error.response?.statusCode == 404) {
      final data = error.response?.data;
      try {
        if (data is Map<String, dynamic> && data.containsKey('Message')) {
          _logger.info('Mensaje de error: $data');
          return (jsonDecode(data['Message'] as String) as List)
              .map((e) => (e as Map<String, dynamic>)['Descripcion'] as String)
              .join('\n');
        }
      } catch (e, stackTrace) {
        _logger.severe(
          'Error al mapear el mensaje de error: $data',
          e,
          stackTrace,
        );
      }
    }
    return 'Error desconocido en la respuesta';
  }
}
