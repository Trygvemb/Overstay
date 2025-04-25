import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// BaseService – fælles logik (headers, base-url, fejl-håndtering)
abstract class ApiService {
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:5050';

  Map<String, String> _defaultHeaders({bool isJson = true}) => {
    'Accept': 'application/json',
    if (isJson) 'Content-Type': 'application/json',
    if (dotenv.env['JWT'] != null)
      'Authorization': 'Bearer ${dotenv.env['JWT']}',
  };

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  Future<http.Response> get(String path) =>
      http.get(_uri(path), headers: _defaultHeaders());

  Future<http.Response> post(String path, Map<String, dynamic> body) =>
      http.post(_uri(path), headers: _defaultHeaders(), body: jsonEncode(body));

  Future<http.Response> put(String path, Map<String, dynamic> body) =>
      http.put(_uri(path), headers: _defaultHeaders(), body: jsonEncode(body));

  Future<http.Response> delete(String path) =>
      http.delete(_uri(path), headers: _defaultHeaders());

  /// Smid exception hvis status != 2xx
  T _handle<T>(
    http.Response res,
    T Function(Map<String, dynamic>) successParser,
  ) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isEmpty) return successParser({});
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      return successParser(json);
    }
    throw Exception(
      'API-fejl ${res.statusCode}: ${res.reasonPhrase}\n${res.body}',
    );
  }

  /// Gør `_handle` tilgængelig for sub-services
  T parse<T>(http.Response res, T Function(Map<String, dynamic>) f) =>
      _handle(res, f);
}
