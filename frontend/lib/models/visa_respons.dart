import 'package:overstay_frontend/models/visa_type_response.dart';

class VisaResponse {
  final String id;
  final DateTime arrivalDate;
  final DateTime expireDate;
  final VisaTypeResponse visaType;
  final bool isActive; // **nyt til at indikerer om visa er aktivt eller ej**

  VisaResponse({
    required this.id,
    required this.arrivalDate,
    required this.expireDate,
    required this.visaType,
    required this.isActive, // ny tilføjelse i kode
  });

  factory VisaResponse.fromJson(Map<String, dynamic> json) => VisaResponse(
    id: json['id'] as String,
    arrivalDate: DateTime.parse(json['arrivalDate'] as String),
    expireDate: DateTime.parse(json['expireDate'] as String),
    visaType: VisaTypeResponse.fromJson(
      json['visaType'] as Map<String, dynamic>,
    ),
    isActive: json['isActive'] as bool, // ny tilføjelse i kode
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'arrivalDate': arrivalDate.toIso8601String(),
    'expireDate': expireDate.toIso8601String(),
    'visaType': visaType.toJson(),
    'isActive': isActive, // ny tilføjelse i kode
  };
}
