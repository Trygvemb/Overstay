import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_service.dart';
import '../models/notification_settings.dart';
import 'api_exception.dart';

class NotificationApiService extends ApiService {
  NotificationApiService(Ref ref) : super(ref);

  Future<NotificationSettings> getNotification() async {
    final res = await get('/api/Notification');
    if (res.statusCode != 200) {
      throw ApiException(res.statusCode, res.body);
    }
    return NotificationSettings.fromJson(jsonDecode(res.body));
  }

  Future<void> createNotification(NotificationSettings n) async {
    final res = await post('/api/Notification', n.toJson());
    if (res.statusCode != 201) {
      throw ApiException(res.statusCode, res.body);
    }
  }

  Future<void> updateNotification(NotificationSettings n) async {
    final res = await put('/api/Notification', n.toJson());
    if (res.statusCode != 200) {
      throw ApiException(res.statusCode, res.body);
    }
  }
}
