enum LoginStatus { initial, loading, success, error }

class LoginState {
  final String custNumber;
  final String password;
  final bool isValid;
  final LoginStatus status;
  final String message;
  final String accessToken;
  final String custGroupId;
  final String custName;
  final String custPhone;
  final String custEmail;
  final String custAddress;
  final String custProvince;
  final String custDistrict;
  final String custSubDistrict;
  final String custVillage;

  const LoginState({
    this.custNumber = '',
    this.password = '',
    this.isValid = false,
    this.status = LoginStatus.initial,
    this.message = '',
    this.accessToken = '',
    this.custGroupId = '',
    this.custName = '',
    this.custPhone = '',
    this.custEmail = '',
    this.custAddress = '',
    this.custProvince = '',
    this.custDistrict = '',
    this.custSubDistrict = '',
    this.custVillage = '',
  });

  LoginState copyWith({
    String? custNumber,
    String? password,
    bool? isValid,
    LoginStatus? status,
    String? message,
    String? accessToken,
    String? custGroupId,
    String? custName,
    String? custPhone,
    String? custEmail,
    String? custAddress,
    String? custProvince,
    String? custDistrict,
    String? custSubDistrict,
    String? custVillage,
  }) {
    return LoginState(
      custNumber: custNumber ?? this.custNumber,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      message: message ?? this.message,
      accessToken: accessToken ?? this.accessToken,
      custGroupId: custGroupId ?? this.custGroupId,
      custName: custName ?? this.custName,
      custPhone: custPhone ?? this.custPhone,
      custEmail: custEmail ?? this.custEmail,
      custAddress: custAddress ?? this.custAddress,
      custProvince: custProvince ?? this.custProvince,
      custDistrict: custDistrict ?? this.custDistrict,
      custSubDistrict: custSubDistrict ?? this.custSubDistrict,
      custVillage: custVillage ?? this.custVillage,
    );
  }
}
