class RegionResponse {
  final String message;
  final int success;
  final List<RegionModel> data;

  RegionResponse({
    required this.message,
    required this.success,
    required this.data,
  });

  factory RegionResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    return RegionResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => RegionModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class RegionModel {
  final String id;
  final String name;

  // optional karena tidak semua endpoint punya ini
  final String? provinceId;

  RegionModel({
    required this.id,
    required this.name,
    this.provinceId,
  });

  factory RegionModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return RegionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      provinceId: json['province_id'],
    );
  }
}