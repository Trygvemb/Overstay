import 'dart:convert';
import 'api_service.dart';
import '../models/notification_settings.dart';
import 'api_exception.dart';

class NotificationApiService extends ApiService {
  NotificationApiService(super.ref);

  // --------------------- GET NOTIFICATION SETTINGS ---------------------
  /// Henter notification settings fra serveren
  Future<NotificationSettings?> getSettings() async {
    final res = await get('/api/Notification');

    if (res.statusCode == 200) {
      return NotificationSettings.fromJson(jsonDecode(res.body));
    }
    if (res.statusCode == 404) {
      return null;
    }
    throw ApiException(res.statusCode, res.body);
  }

  //---------------------- POST (første gang) ----------------------
  /// Opretter notification settings på serveren
  Future<void> create(NotificationSettings n) async {
    final res = await post('/api/Notification', n.toJson());
    if (res.statusCode != 201) {
      throw ApiException(res.statusCode, res.body);
    }
  }

  // --------------------- PUT (opdatering) ---------------------
  /// Opdaterer notification settings på serveren
  Future<void> update(NotificationSettings n) async {
    final res = await put('/api/Notification', n.toJson());
    if (res.statusCode != 200) {
      throw ApiException(res.statusCode, res.body);
    }
  }
}
