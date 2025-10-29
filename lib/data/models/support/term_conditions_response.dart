class TermConditionsResponse {
  final String message;
  final int success;
  final TermConditionsData data;

  TermConditionsResponse({
    required this.message,
    required this.success,
    required this.data,
  });

  factory TermConditionsResponse.fromJson(Map<String, dynamic> json) {
    return TermConditionsResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? 0,
      data: TermConditionsData.fromJson(json['data']),
    );
  }
}

class TermConditionsData {
  final int id;
  final String termconditions;
  final String createdAt;
  final String updatedAt;

  TermConditionsData({
    required this.id,
    required this.termconditions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TermConditionsData.fromJson(Map<String, dynamic> json) {
    return TermConditionsData(
      id: json['id'] ?? 0,
      termconditions: json['termconditions'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
