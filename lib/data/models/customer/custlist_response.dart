class GetCustListResponse {
  final int success;
  final String message;
  final List<CustListData> data;

  GetCustListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetCustListResponse.fromJson(Map<String, dynamic> json) {
    return GetCustListResponse(
      success: json['success'] ?? 0,
      message: json['message'] ?? "",
      data: (json['data'] as List<dynamic>)
          .map((e) => CustListData.fromJson(e))
          .toList(),
    );
  }
}

class CustListData {
  final String nopel;
  final String groupId;

  CustListData({
    required this.nopel,
    required this.groupId,
  });

  factory CustListData.fromJson(Map<String, dynamic> json) {
    return CustListData(
      nopel: json['nopel'] ?? "",
      groupId: json['groupId'] ?? "",
    );
  }
}
