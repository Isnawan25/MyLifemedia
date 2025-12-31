abstract class VerifyState {
  const VerifyState();
}

class VerifyInitial extends VerifyState {}

class VerifyLoading extends VerifyState {}

class VerifySuccessLogin extends VerifyState {}

class VerifySuccessAddCustomer extends VerifyState {
  final String nopel;
  const VerifySuccessAddCustomer(this.nopel);
}

class VerifyError extends VerifyState {
  final String message;
  const VerifyError(this.message);
}
