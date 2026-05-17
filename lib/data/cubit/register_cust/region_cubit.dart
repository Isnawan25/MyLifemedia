import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mylm/data/cubit/register_cust/region_state.dart';
import 'package:mylm/data/models/customer/register_cust/region_response.dart';
import 'package:mylm/data/network/services/get/get_region.dart';

class RegionCubit extends Cubit<RegionState> {

  RegionCubit() : super(RegionState());

  final RegionService service =
  RegionService();


  // GET PROVINCES
  Future<void> getProvinces() async {

    emit(
      state.copyWith(
        isLoadingProvince: true,
      ),
    );

    try {

      final response =
      await service.getProvinces();

      emit(
        state.copyWith(
          isLoadingProvince: false,
          provinces: response.data,
        ),
      );

    } catch (e) {

      emit(
        state.copyWith(
          isLoadingProvince: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }


  // SELECT PROVINCE
  Future<void> selectProvince(
      RegionModel province,
      ) async {

    emit(
      state.copyWith(
        selectedProvince: province,

        selectedRegency: null,
        selectedDistrict: null,
        selectedVillage: null,

        regencies: [],
        districts: [],
        villages: [],
      ),
    );

    await getRegencies(province.id);
  }


  // GET REGENCIES
  Future<void> getRegencies(
      String provinceId,
      ) async {

    emit(
      state.copyWith(
        isLoadingRegency: true,
      ),
    );

    try {

      final response =
      await service.getRegencies(
        provinceId,
      );

      emit(
        state.copyWith(
          isLoadingRegency: false,
          regencies: response.data,
        ),
      );

    } catch (e) {

      emit(
        state.copyWith(
          isLoadingRegency: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }


  // SELECT REGENCY
  Future<void> selectRegency(
      RegionModel regency,
      ) async {

    emit(
      state.copyWith(
        selectedRegency: regency,

        selectedDistrict: null,
        selectedVillage: null,

        districts: [],
        villages: [],
      ),
    );

    await getDistricts(regency.id);
  }


  // GET DISTRICTS
  Future<void> getDistricts(
      String regencyId,
      ) async {

    emit(
      state.copyWith(
        isLoadingDistrict: true,
      ),
    );

    try {

      final response =
      await service.getDistricts(
        regencyId,
      );

      emit(
        state.copyWith(
          isLoadingDistrict: false,
          districts: response.data,
        ),
      );

    } catch (e) {

      emit(
        state.copyWith(
          isLoadingDistrict: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }


  // SELECT DISTRICT
  Future<void> selectDistrict(
      RegionModel district,
      ) async {

    emit(
      state.copyWith(
        selectedDistrict: district,

        selectedVillage: null,

        villages: [],
      ),
    );

    await getVillages(district.id);
  }


  // GET VILLAGES
  Future<void> getVillages(
      String districtId,
      ) async {

    emit(
      state.copyWith(
        isLoadingVillage: true,
      ),
    );

    try {

      final response =
      await service.getVillages(
        districtId,
      );

      emit(
        state.copyWith(
          isLoadingVillage: false,
          villages: response.data,
        ),
      );

    } catch (e) {

      emit(
        state.copyWith(
          isLoadingVillage: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }


  // SELECT VILLAGE
  void selectVillage(
      RegionModel village,
      ) {

    emit(
      state.copyWith(
        selectedVillage: village,
      ),
    );
  }
}