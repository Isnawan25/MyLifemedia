import 'package:mylm/data/models/customer/register_cust/region_response.dart';

class RegionState {

  // LOADING
  final bool isLoadingProvince;
  final bool isLoadingRegency;
  final bool isLoadingDistrict;
  final bool isLoadingVillage;


  // DATA LIST
  final List<RegionModel> provinces;
  final List<RegionModel> regencies;
  final List<RegionModel> districts;
  final List<RegionModel> villages;

  // SELECTED
  final RegionModel? selectedProvince;
  final RegionModel? selectedRegency;
  final RegionModel? selectedDistrict;
  final RegionModel? selectedVillage;

  // ERROR
  final String? errorMessage;

  RegionState({
    this.isLoadingProvince = false,
    this.isLoadingRegency = false,
    this.isLoadingDistrict = false,
    this.isLoadingVillage = false,

    this.provinces = const [],
    this.regencies = const [],
    this.districts = const [],
    this.villages = const [],

    this.selectedProvince,
    this.selectedRegency,
    this.selectedDistrict,
    this.selectedVillage,

    this.errorMessage,
  });

  RegionState copyWith({

    bool? isLoadingProvince,
    bool? isLoadingRegency,
    bool? isLoadingDistrict,
    bool? isLoadingVillage,

    List<RegionModel>? provinces,
    List<RegionModel>? regencies,
    List<RegionModel>? districts,
    List<RegionModel>? villages,

    RegionModel? selectedProvince,
    RegionModel? selectedRegency,
    RegionModel? selectedDistrict,
    RegionModel? selectedVillage,

    String? errorMessage,

  }) {

    return RegionState(

      isLoadingProvince:
      isLoadingProvince ??
          this.isLoadingProvince,

      isLoadingRegency:
      isLoadingRegency ??
          this.isLoadingRegency,

      isLoadingDistrict:
      isLoadingDistrict ??
          this.isLoadingDistrict,

      isLoadingVillage:
      isLoadingVillage ??
          this.isLoadingVillage,

      provinces:
      provinces ?? this.provinces,

      regencies:
      regencies ?? this.regencies,

      districts:
      districts ?? this.districts,

      villages:
      villages ?? this.villages,

      selectedProvince:
      selectedProvince ??
          this.selectedProvince,

      selectedRegency:
      selectedRegency ??
          this.selectedRegency,

      selectedDistrict:
      selectedDistrict ??
          this.selectedDistrict,

      selectedVillage:
      selectedVillage ??
          this.selectedVillage,

      errorMessage:
      errorMessage,
    );
  }
}