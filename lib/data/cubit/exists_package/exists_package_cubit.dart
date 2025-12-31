import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylm/data/network/services/get/get_exists_package.dart';
import 'exists_package_state.dart';

class ExistsPackageCubit extends Cubit<ExistsPackageState> {
  final ExistsPackageService service;

  ExistsPackageCubit(this.service) : super(ExistsPackageInitial());

  Future<void> fetch({
    required String custGroupId,
    required String custNumber,
    required String accessToken,
  }) async {
    emit(ExistsPackageLoading());

    try {
      final result = await service.getExistingPackage(
        custGroupId,
        custNumber,
        accessToken,
      );
      emit(ExistsPackageLoaded(result));
    } catch (_) {
      emit(ExistsPackageError("Gagal memuat paket aktif"));
    }
  }
}
