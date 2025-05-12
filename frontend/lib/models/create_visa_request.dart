import 'package:intl/intl.dart';

class CreateVisaRequest {
  final DateTime? arrivalDate;
  final DateTime? expireDate;
  final String visaTypeId;

  CreateVisaRequest({
    this.arrivalDate,
    this.expireDate,
    required this.visaTypeId,
  });

  //-------------helper til datoformatting----------------
  static String? _formatDate(DateTime? date) =>
      date == null ? null : DateFormat('yyyy-MM-dd').format(date);

  Map<String, dynamic> toJson() => {
    // ens formatter til arrival og expire date
    'arrivalDate': _formatDate(arrivalDate),
    'expireDate': _formatDate(expireDate),
    'visaTypeId': visaTypeId,
  };
}
