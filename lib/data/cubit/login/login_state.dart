enum LoginStatus { initial, loading, success, error }

class LoginState {
  final String custNumber;
  final bool isValid;
  final LoginStatus status;
  final String message;
  final String accessToken;
  final String custGroupId;

  const LoginState({
    this.custNumber = '',
    this.isValid = false,
    this.status = LoginStatus.initial,
    this.message = '',
    this.accessToken = '',
    this.custGroupId = '',
  });

  LoginState copyWith({
    String? custNumber,
    bool? isValid,
    LoginStatus? status,
    String? message,
    String? accessToken,
    String? custGroupId,
  }) {
    return LoginState(
      custNumber: custNumber ?? this.custNumber,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
      message: message ?? this.message,
      accessToken: accessToken ?? this.accessToken,
      custGroupId: custGroupId ?? this.custGroupId,
    );
  }
}
