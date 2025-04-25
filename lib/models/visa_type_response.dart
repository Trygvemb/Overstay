class VisaTypeResponse {
  final String id;
  final String? name;
  final String? description;
  final int? durationInDays;
  final bool? isMultipleEntry;

  VisaTypeResponse({
    required this.id,
    this.name,
    this.description,
    this.durationInDays,
    this.isMultipleEntry,
  });

  factory VisaTypeResponse.fromJson(Map<String, dynamic> json) =>
      VisaTypeResponse(
        id: json['id'] as String,
        name: json['name'] as String?,
        description: json['description'] as String?,
        durationInDays: json['durationInDays'] as int?,
        isMultipleEntry: json['isMultipleEntry'] as bool?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'durationInDays': durationInDays,
    'isMultipleEntry': isMultipleEntry,
  };
}
