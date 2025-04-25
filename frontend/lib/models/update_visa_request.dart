class UpdateVisaRequest {
  final DateTime? arrivalDate;
  final DateTime? expireDate;
  final String? visaTypeId;
  final String? userId; // kun hvis du vil flytte et visa til anden bruger

  UpdateVisaRequest({
    this.arrivalDate,
    this.expireDate,
    this.visaTypeId,
    this.userId,
  });

  Map<String, dynamic> toJson() => {
    'arrivalDate': arrivalDate?.toIso8601String(),
    'expireDate': expireDate?.toIso8601String(),
    'visaTypeId': visaTypeId,
    'userId': userId,
  };
}
