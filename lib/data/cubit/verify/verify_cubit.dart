import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylm/data/network/services/post/post_auth_otp.dart';
import 'package:mylm/data/network/services/post/post_added_nopel.dart';
import 'package:mylm/data/preferences/secure_storage.dart';
import 'verify_state.dart';

class VerifyCubit extends Cubit<VerifyState> {
  VerifyCubit() : super(VerifyInitial());

  Future<void> verifyOtp({
    required String otp,
    required String custNumber,
    required String accessToken,
    required String custGroupId,
    required String mainCustNumber,
    required String newCustNumber,
    required OtpMode mode,
  }) async {
    emit(VerifyLoading());

    final api = AuthOtpService();
    final response = await api.verifyOtp(
      custNumber: custNumber,
      otp: otp,
      accessToken: accessToken,
      mode: mode,
    );

    if (response == null ||
        response.data?.statusOTP.toLowerCase() != "verified") {
      emit(const VerifyError("Kode OTP kamu salah"));
      emit(VerifyInitial()); //reset roast
      return;
    }

    // LOGIN MODE
    if (mode == OtpMode.login) {
      await SecureStorage.saveAccessToken(accessToken);
      await SecureStorage.saveCustNumber(custNumber);
      await SecureStorage.saveCustGroupId(custGroupId);

      emit(VerifySuccessLogin());
      return;
    }

    // ADD CUSTOMER MODE
    if (mode == OtpMode.addCustomer) {
      final addResp = await AddedNopelService().addNopel(
        custNumber: mainCustNumber,
        newCustNumber: custNumber,
        custGroupId: custGroupId,
        accessToken: accessToken,
      );

      if (addResp == null || addResp.success != 1) {
        emit(const VerifyError("Gagal menambahkan ID pelanggan"));
        emit(VerifyInitial());
        return;
      }

      await SecureStorage.saveCustGroupId(addResp.data!.groupId);

      emit(VerifySuccessAddCustomer(addResp.data!.nopel));
    }
  }

  Future<void> resendOtp({
    required String custNumber,
    required String accessToken,
    required OtpMode mode,
  }) async {
    await AuthOtpService().resendOtp(
      custNumber: custNumber,
      accessToken: accessToken,
      mode: mode,
    );
  }
}
