class BillListResponse {
  final String message;
  final int success;
  final List<BillData> data;

  BillListResponse({
    required this.message,
    required this.success,
    required this.data,
  });

  factory BillListResponse.fromJson(Map<String, dynamic> json) {
    return BillListResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? 0,
      data: (json['data'] as List)
          .map((item) => BillData.fromJson(item))
          .toList(),
    );
  }
}

class BillData {
  final String custNumber;
  final String invNumber;
  final String? invStart;
  final String? invDue;
  final int invStatus;
  final String? payMethod;
  final String? payDate;
  final String totals;
  final String spName;

  BillData({
    required this.custNumber,
    required this.invNumber,
    required this.invStart,
    required this.invDue,
    required this.invStatus,
    required this.payMethod,
    required this.payDate,
    required this.totals,
    required this.spName,
  });

  factory BillData.fromJson(Map<String, dynamic> json) {
    return BillData(
      custNumber: json['custNumber'] ?? '',
      invNumber: json['invNumber'] ?? '',
      invStart: json['invStart']?.toString(),
      invDue:   json['invDue']?.toString(),
      invStatus: json['invStatus'] ?? 0,
      payMethod: json['payMethod'],
      payDate:   json['payDate']?.toString(),
      totals: json['totals'] ?? '0',
      spName: json['spName'] ?? '',
    );
  }
}
