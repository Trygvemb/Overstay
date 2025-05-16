// models, tanken er at denne skal håndtere brugerens ønskede notifikationsvalg
//daysBefore, allowEmail, allow90days,

class NotificationSettings {
  final String id; // empty when you POST first time
  final bool emailNotification;
  final bool nintyDaysNotification;
  final bool expiredNotification;
  final int daysBefore;

  const NotificationSettings({
    required this.id,
    required this.emailNotification,
    required this.nintyDaysNotification,
    required this.expiredNotification,
    required this.daysBefore,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> j) =>
      NotificationSettings(
        id: j['id'] as String? ?? '',
        emailNotification: j['emailNotification'] as bool? ?? true,
        nintyDaysNotification: j['nintyDaysNotification'] as bool? ?? true,
        expiredNotification: j['expiredNotification'] as bool? ?? true,
        daysBefore: j['daysBefore'] as int? ?? 7,
      );

  Map<String, dynamic> toJson() => {
    'emailNotification': emailNotification,
    'nintyDaysNotification': nintyDaysNotification,
    'expiredNotification': expiredNotification,
    'daysBefore': daysBefore,
  };

  NotificationSettings copyWith({
    bool? nintyDaysNotification,
    bool? expiredNotification,
    int? daysBefore,
  }) => NotificationSettings(
    id: id,
    emailNotification: emailNotification,
    nintyDaysNotification: nintyDaysNotification ?? this.nintyDaysNotification,
    expiredNotification: expiredNotification ?? this.expiredNotification,
    daysBefore: daysBefore ?? this.daysBefore,
  );
}
