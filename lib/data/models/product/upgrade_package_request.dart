class UpgradePackageRequest {
  final String accessToken;
  final String custNumber;
  final String custName;
  final String custPhone;
  final String custEmail;
  final String custProvince;
  final String custDistrict;
  final String custSubDistrict;
  final String custVillage;
  final String custAddress;
  final String custSpCodeIdExists;
  final String custSpCodeIdNew;
  final String? accManager;

  UpgradePackageRequest({
    required this.accessToken,
    required this.custNumber,
    required this.custName,
    required this.custPhone,
    required this.custEmail,
    required this.custProvince,
    required this.custDistrict,
    required this.custSubDistrict,
    required this.custVillage,
    required this.custAddress,
    required this.custSpCodeIdExists,
    required this.custSpCodeIdNew,
    this.accManager,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "custNumber": custNumber,
      "custName": custName,
      "custPhone": custPhone,
      "custEmail": custEmail,
      "custProvince": custProvince,
      "custDistrict": custDistrict,
      "custSubDistrict": custSubDistrict,
      "custVillage": custVillage,
      "custAddress": custAddress,
      "custSpCodeIdExists": custSpCodeIdExists,
      "custSpCodeIdNew": custSpCodeIdNew,
    };

    if (accManager != null && accManager!.isNotEmpty) {
      data["accManager"] = accManager;
    }

    return data;
  }
}
