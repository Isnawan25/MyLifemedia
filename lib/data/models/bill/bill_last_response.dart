class BillLastResponse {
  final List<BillItem> data;

  BillLastResponse({required this.data});

  factory BillLastResponse.fromJson(Map<String, dynamic> json) {
    final list = json['data'] as List<dynamic>;
    return BillLastResponse(
      data: list.map((e) => BillItem.fromJson(e)).toList(),
    );
  }
}

class BillItem {
  final String custNumber;
  final String invNumber;
  final String invStart;
  final int invStatus;
  final String invDue;
  final double totals;
  final String spCode;

  BillItem({
    required this.custNumber,
    required this.invNumber,
    required this.invStart,
    required this.invStatus,
    required this.invDue,
    required this.totals,
    required this.spCode,
  });

  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
      custNumber: json['custNumber'],
      invNumber: json['invNumber'],
      invStart: json['invStart'],
      invStatus: json['invStatus'],
      invDue: json['invDue'],
      totals: double.tryParse(json['totals'].toString()) ?? 0.0,
      spCode: json['spCode'],
    );
  }
}
