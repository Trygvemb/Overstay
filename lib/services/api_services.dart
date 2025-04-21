//tanken er at denne skal håndtere HTTP REST-kald GET-POST-PUT-DELETE

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:visa_app/models/visa_type.dart';

// API service class to handle API requests
class ApiService {
  static const String _base = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'http://localhost:5000',
  );

  static final _jsonHeader = {'Content-Type': 'application/json'};

  // HENT visa‑typer
  static Future<List<VisaType>> getVisaTypes() async {
    final res = await http.get(
      Uri.parse('$_base/visa-types'),
      headers: _jsonHeader,
    );
    final list = jsonDecode(res.body) as List;
    return list.map((e) => VisaType.fromJson(e)).toList();
  }

  // Opret visa‑type
  static Future<void> createVisaType(VisaType vt) async {
    await http.post(
      Uri.parse('$_base/visa-types'),
      headers: _jsonHeader,
      body: jsonEncode(vt.toJson()),
    );
  }

  // Tilføj login/signup osv.
}
