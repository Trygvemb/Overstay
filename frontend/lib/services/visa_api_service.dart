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

  /// POST /api/Visa  – opret visa
  Future<VisaResponse> createVisa(CreateVisaRequest req) async {
    final res = await post('/api/Visa', req.toJson());
    return parse(res, (j) => VisaResponse.fromJson(j));
  }

  /// PUT /api/Visa/{id}  – opdater visa
  Future<void> updateVisa(String id, UpdateVisaRequest req) async {
    final res = await put('/api/Visa/$id', req.toJson());
    if (res.statusCode != 204) _throw(res);
  }

  /// DELETE /api/Visa/{id}
  Future<void> deleteVisa(String id) async {
    final res = await delete('/api/Visa/$id');
    if (res.statusCode != 204) _throw(res);
  }

  void _throw(res) =>
      throw Exception('API-fejl ${res.statusCode}: ${res.body}');
}
