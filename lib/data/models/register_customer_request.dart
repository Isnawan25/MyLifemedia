class RegisterCustomerRequest {
  final String custName;
  final String custPhone;
  final String custEmail;
  final int custPostalCode;
  final String custProvince;
  final String custDistrict;
  final String custSubDistrict;
  final String custVillage;
  final String custAddress;
  final double custLat;
  final double custLong;
  final String packageId;

  RegisterCustomerRequest({
    required this.custName,
    required this.custPhone,
    required this.custEmail,
    required this.custPostalCode,
    required this.custProvince,
    required this.custDistrict,
    required this.custSubDistrict,
    required this.custVillage,
    required this.custAddress,
    required this.custLat,
    required this.custLong,
    required this.packageId,
  });

  Map<String, dynamic> toJson() => {
    "custName": custName,
    "custPhone": custPhone,
    "custEmail": custEmail,
    "custPostalCode": custPostalCode,
    "custProvince": custProvince,
    "custDistrict": custDistrict,
    "custSubDistrict": custSubDistrict,
    "custVillage": custVillage,
    "custAddress": custAddress,
    "custLat": custLat,
    "custLong": custLong,
    "packageId": packageId,
  };
}
