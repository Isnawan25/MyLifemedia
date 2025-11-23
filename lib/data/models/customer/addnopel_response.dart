class AddNopelResponse {
  final String message;
  final int success;
  final AddNopelData? data;

  AddNopelResponse({
    required this.message,
    required this.success,
    required this.data,
  });

  factory AddNopelResponse.fromJson(Map<String, dynamic> json) {
    return AddNopelResponse(
      message: json["message"] ?? "",
      success: json["success"] ?? 0,
      data: AddNopelData.fromJson(json["data"] ?? {}),
    );
  }
}

class AddNopelData {
  final String nopel;
  final String groupId;

  AddNopelData({
    required this.nopel,
    required this.groupId,
  });

  factory AddNopelData.fromJson(Map<String, dynamic> json) {
    return AddNopelData(
      nopel: json["nopel"] ?? "",
      groupId: json["groupId"] ?? "",
    );
  }
}
