class ExistsPackage {
  final String custNumber;
  final String spCode;
  final String spCodeId;
  final int spReguler;
  final String groupId;

  ExistsPackage({
    required this.custNumber,
    required this.spCode,
    required this.spCodeId,
    required this.spReguler,
    required this.groupId,
  });

  factory ExistsPackage.fromJson(Map<String, dynamic> json) {
    return ExistsPackage(
      custNumber: json['custNumber'] ?? '',
      spCode: json['spCode'] ?? '',
      spCodeId: json['spCodeId'] ?? '',
      spReguler: json['spReguler'] ?? 0,
      groupId: json['groupId'] ?? '',
    );
  }
}
