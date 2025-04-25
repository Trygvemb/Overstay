import 'package:overstay_frontend/models/visa_type_response.dart';

class VisaResponse {
  final String id;
  final DateTime arrivalDate;
  final DateTime expireDate;
  final VisaTypeResponse visaType;

  VisaResponse({
    required this.id,
    required this.arrivalDate,
    required this.expireDate,
    required this.visaType,
  });

  factory VisaResponse.fromJson(Map<String, dynamic> json) => VisaResponse(
    id: json['id'] as String,
    arrivalDate: DateTime.parse(json['arrivalDate'] as String),
    expireDate: DateTime.parse(json['expireDate'] as String),
    visaType: VisaTypeResponse.fromJson(
      json['visaType'] as Map<String, dynamic>,
    ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'arrivalDate': arrivalDate.toIso8601String(),
    'expireDate': expireDate.toIso8601String(),
    'visaType': visaType.toJson(),
  };
}
