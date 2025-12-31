import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylm/data/network/services/post/post_auth_otp.dart';
import 'package:mylm/data/preferences/secure_storage.dart';
import 'package:mylm/data/cubit/login/login_state.dart';


class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void onIdChanged(String value) {
    final hasLetter = value.contains(RegExp(r'[A-Za-z]'));
    final hasNumber = value.contains(RegExp(r'[0-9]'));
    final minLength = value.length >= 6;

    emit(state.copyWith(
      custNumber: value,
      isValid: hasLetter && hasNumber && minLength,
    ));
  }

  Future<void> login() async {
    if (!state.isValid) return;

    emit(state.copyWith(status: LoginStatus.loading));

    try {
      final api = AuthOtpService();
      final custNumber = state.custNumber;

      final result = await api.login(custNumber);

      if (result == null || !result.success) {
        emit(state.copyWith(
          status: LoginStatus.error,
          message: result?.message ?? 'Login gagal',
        ));
        return;
      }

      final data = result.data;
      final accessToken = data?.accessToken ?? '';
      final custGroupId = data?.custGroupId ?? '';

      // Simpan ke Secure Storage
      await SecureStorage.saveAccessToken(accessToken);
      await SecureStorage.saveCustNumber(custNumber);
      await SecureStorage.saveCustGroupId(custGroupId);
      await SecureStorage.saveCustName(data?.custName ?? '');
      await SecureStorage.saveCustPhone(data?.custPhone ?? '');
      await SecureStorage.saveCustEmail(data?.custEmail ?? '');
      await SecureStorage.saveCustAddress(data?.custAddress ?? '');
      await SecureStorage.saveCustProvince(data?.custProvince ?? '');
      await SecureStorage.saveCustDistrict(data?.custDistrict ?? '');
      await SecureStorage.saveCustSubDistrict(data?.custSubDistrict ?? '');
      await SecureStorage.saveCustVillage(data?.custVillage ?? '');

      // Request OTP
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
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.error,
        message: e.toString(),
      ));
    }
  }
}
