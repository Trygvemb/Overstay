//tanken er at denne skal håndtere hvilken type visa, fx tourist visa osv
// id, visaType, maxStayDays
// denne model skal dog være tilsvarende den der er i MockVisaType.cs!! vigtigt!!

class VisaType {
  final String id;
  final String name;
  final int maxStayDays;

  VisaType({required this.id, required this.name, required this.maxStayDays});

  factory VisaType.fromJson(Map<String, dynamic> json) => VisaType(
    id: json['id'],
    name: json['name'],
    maxStayDays: json['maxStayDays'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'maxStayDays': maxStayDays,
  };
}
