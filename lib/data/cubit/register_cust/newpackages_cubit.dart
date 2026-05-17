import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylm/data/cubit/register_cust/newpackages_state.dart';
import 'package:mylm/data/network/services/get/get_newpackages.dart';

class NewPackagesCubit extends Cubit<NewPackagesState> {
  NewPackagesCubit() : super(NewPackagesInitial());

  final service = GetNewPackagesService();

  Future<void> fetchPackages() async {
    emit(NewPackagesLoading());

    try {
      final response = await service.getNewPackages();

      if (response == null || response.success != 1) {
        emit(NewPackagesError("Gagal mengambil paket"));
        return;
      }

      emit(NewPackagesLoaded(response.data));
    } catch (e) {
      emit(NewPackagesError(e.toString()));
    }
  }
}