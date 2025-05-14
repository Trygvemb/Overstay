import 'package:intl/intl.dart';

class UpdateVisaRequest {
  final DateTime arrivalDate;
  final DateTime expireDate;
  final String visaTypeId;

  UpdateVisaRequest({
    required this.arrivalDate,
    required this.expireDate,
    required this.visaTypeId,
  });

  // -------------- ens formatter som i CreateVisaRequest --------------
  static String _fmt(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  Map<String, dynamic> toJson() => {
    'arrivalDate': _fmt(arrivalDate),
    'expireDate': _fmt(expireDate),
    'visaTypeId': visaTypeId,
  };
}
