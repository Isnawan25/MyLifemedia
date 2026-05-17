import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylm/data/network/services/get/get_packages.dart';
import 'packages_state.dart';

class PackagesCubit extends Cubit<PackagesState> {
  PackagesCubit() : super(PackagesLoading());

  final PackagesService _service = PackagesService();

  Future<void> fetchPackages() async {
    emit(PackagesLoading());

    final response = await _service.getPackages();

    if (response != null && response.success == 1) {
      emit(PackagesLoaded(packages: response.data));
    } else {
      emit(const PackagesError("Gagal memuat data paket"));
    }
  }

  void selectPackage(String packageId) {
    if (state is PackagesLoaded) {
      final current = state as PackagesLoaded;
      emit(current.copyWith(selectedPackageId: packageId));
    }
  }
}
