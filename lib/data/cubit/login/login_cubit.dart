import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylm/data/network/services/post/post_auth_otp.dart';
import 'package:mylm/data/cubit/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  // ID Pelanggan
  void onIdChanged(String value) {
    final hasLetter = value.contains(RegExp(r'[A-Za-z]'));
    final hasNumber = value.contains(RegExp(r'[0-9]'));
    final minLength = value.length >= 6;

    final isCustValid =
        hasLetter && hasNumber && minLength;

    emit(state.copyWith(
      custNumber: value,
      isValid: isCustValid &&
          state.password.isNotEmpty,
    ));
  }

  // Password
  void onPasswordChanged(String value) {
    emit(state.copyWith(
      password: value,
      isValid:
      state.custNumber.isNotEmpty &&
          value.isNotEmpty,
    ));
  }

  // Login
  Future<void> login() async {
    if (!state.isValid) return;

    emit(state.copyWith(
      status: LoginStatus.loading,
    ));

    try {
      final api = AuthOtpService();

      final custNumber = state.custNumber;
      final password = state.password;

      final result = await api.login(
        custNumber: custNumber,
        password: password,
      );

      if (result == null || !result.success) {
        emit(state.copyWith(
          status: LoginStatus.error,
          message: result?.message ??
              'Login gagal',
        ));
        return;
      }

      final data = result.data;

      final accessToken =
          data?.accessToken ?? '';

      final custGroupId =
          data?.custGroupId ?? '';

      // req otp
      final otp = await api.requestOtp(
        custNumber: custNumber,
        accessToken: accessToken,
        mode: OtpMode.login,
      );

      if (otp == null || !otp.success) {
        emit(state.copyWith(
          status: LoginStatus.error,
          message: 'Gagal mengirim OTP',
        ));
        return;
      }

      emit(state.copyWith(
        status: LoginStatus.success,
        accessToken: accessToken,
        custGroupId: custGroupId,

        custName: data?.custName ?? '',
        custPhone: data?.custPhone ?? '',
        custEmail: data?.custEmail ?? '',
        custAddress: data?.custAddress ?? '',
        custProvince: data?.custProvince ?? '',
        custDistrict: data?.custDistrict ?? '',
        custSubDistrict: data?.custSubDistrict ?? '',
        custVillage: data?.custVillage ?? '',
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.error,
        message: e.toString(),
      ));
    }
  }
}