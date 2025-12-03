class DetailBillResponse {
  final String message;
  final int success;
  final DetailBillData data;

  DetailBillResponse({
    required this.message,
    required this.success,
    required this.data,
  });

  factory DetailBillResponse.fromJson(Map<String, dynamic> json) {
    return DetailBillResponse(
      message: json["message"] ?? "",
      success: json["success"] ?? 0,
      data: DetailBillData.fromJson(json["data"]),
    );
  }
}

class DetailBillData {
  final String custNumber;
  final String invNumber;
  final String invStart;
  final int invStatus;
  final String invDue;
  final String payMethod;
  final String? payDate;
  final String totals;
  final String spName;

  DetailBillData({
    required this.custNumber,
    required this.invNumber,
    required this.invStart,
    required this.invStatus,
    required this.invDue,
    required this.payMethod,
    required this.payDate,
    required this.totals,
    required this.spName,
  });

  factory DetailBillData.fromJson(Map<String, dynamic> json) {
    return DetailBillData(
      custNumber: json["custNumber"] ?? "",
      invNumber: json["invNumber"] ?? "",
      invStart: json["invStart"] ?? "",
      invStatus: json["invStatus"] ?? 0,
      invDue: json["invDue"] ?? "",
      payMethod: json["payMethod"] ?? "",
      payDate: json["payDate"] ?? "",
      totals: json["totals"] ?? "0",
      spName: json["spName"] ?? "",
    );
  }
}
