class UpgradePackageResponse {
  final int success;
  final String message;
  final UpgradePackageData data;

  UpgradePackageResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UpgradePackageResponse.fromJson(Map<String, dynamic> json) {
    return UpgradePackageResponse(
      success: json["success"],
      message: json["message"],
      data: UpgradePackageData.fromJson(json["data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class UpgradePackageData {
  final String custNumber;
  final String custSpCodeIdExists;
  final String custSpCodeIdNew;

  UpgradePackageData({
    required this.custNumber,
    required this.custSpCodeIdExists,
    required this.custSpCodeIdNew,
  });

  factory UpgradePackageData.fromJson(Map<String, dynamic> json) {
    return UpgradePackageData(
      custNumber: json["custNumber"],
      custSpCodeIdExists: json["custSpCodeIdExists"],
      custSpCodeIdNew: json["custSpCodeIdNew"],
    );
  }

  Map<String, dynamic> toJson() => {
    "custNumber": custNumber,
    "custSpCodeIdExists": custSpCodeIdExists,
    "custSpCodeIdNew": custSpCodeIdNew,
  };
}
