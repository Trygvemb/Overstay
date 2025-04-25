class CreateVisaRequest {
  final DateTime?
  arrivalDate; // optional – backend sætter nuværende tid hvis null
  final DateTime? expireDate; // kan sendes null → backend beregner
  final String visaTypeId;

  CreateVisaRequest({
    this.arrivalDate,
    this.expireDate,
    required this.visaTypeId,
  });

  Map<String, dynamic> toJson() => {
    'arrivalDate': arrivalDate?.toIso8601String(),
    'expireDate': expireDate?.toIso8601String(),
    'visaTypeId': visaTypeId,
  };
}
