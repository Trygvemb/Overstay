import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/create_visa_request.dart';
import '../models/update_visa_request.dart';
import '../models/visa_respons.dart';
import '../models/visa_type_response.dart';
import 'api_service.dart';

class VisaApiService extends ApiService {
  VisaApiService(Ref ref) : super(ref);

  /// GET /api/VisaType  – hent alle typer (til dropdown)
  Future<List<VisaTypeResponse>> getVisaTypes() async {
    final res = await get('/api/VisaType');
    if (res.statusCode != 200) _throw(res);

    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((e) => VisaTypeResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/Visa – henter brugerens *aktuelle* active visa **NY Ændring**
  Future<VisaResponse?> getCurrentVisa() async {
    final res = await get('/api/Visa');
    if (res.statusCode == 404) return null; // intet aktivt visa
    if (res.statusCode != 200) _throw(res);

    final data = jsonDecode(res.body);
    if (data == null) return null;

    return VisaResponse.fromJson(data as Map<String, dynamic>);
  }

  // GET /api/Visa/all - henter ALLE visa (aktive og inactive) for brugern **NY Ændring**
  Future<List<VisaResponse>> getAllVisas() async {
    final res = await get('/api/Visa/all');
    if (res.statusCode != 200) _throw(res);

    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((e) => VisaResponse.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// POST /api/Visa  – opretter nyt visa
  Future<String> createVisa(CreateVisaRequest req) async {
    final res = await post('/api/Visa', req.toJson());

    // API svarer 201 + id som ren tekst: "id 3dfg33545s-sdf4545-..."
    if (res.statusCode == 201) {
      return res.body.replaceAll('"', '');
    }
    _throw(res);
    throw Exception(
      'Unexpected error in creating visa',
    ); // for at tilfredsstille Dart
  }

  /// PUT /api/Visa/{id}  – opdaterer eksisterende visa
  Future<void> updateVisa(String id, UpdateVisaRequest req) async {
    final res = await put('/api/Visa/$id', req.toJson());
    if (res.statusCode != 204) _throw(res);
  }

  /// DELETE /api/Visa/{id} - sletter et visa
  Future<void> deleteVisa(String id) async {
    final res = await delete('/api/Visa/$id');
    if (res.statusCode != 204) _throw(res);
  }

  void _throw(res) =>
      throw Exception('API-fejl ${res.statusCode}: ${res.body}');
}
