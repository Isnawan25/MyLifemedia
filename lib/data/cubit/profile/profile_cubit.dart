import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylm/data/network/services/get/get_profile.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileService service;

  ProfileCubit(this.service) : super(ProfileInitial());

  Future<void> fetch({
    required String custNumber,
    required String accessToken,
    required context,
  }) async {
    emit(ProfileLoading());

    final result = await service.getProfile(
      custNumber,
      accessToken,
      context,
    );

    if (result != null && result.success == 1 && result.data != null) {
      emit(ProfileLoaded(result.data!));
    } else {
      emit(ProfileError("Gagal memuat profil"));
    }
  }
}
