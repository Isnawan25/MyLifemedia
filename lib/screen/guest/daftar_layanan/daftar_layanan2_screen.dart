import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/base/popup/showSuccessDialogLoggedin.dart';
import 'package:mylm/base/popup/showSuccessDialogGuest.dart';
import 'package:mylm/base/widgets/labeltextfield.dart';
import 'package:mylm/base/widgets/showregionbottomsheet.dart';
import 'package:mylm/data/cubit/term_conditions/term_conditions_cubit.dart';
import 'package:mylm/data/cubit/term_conditions/term_conditions_state.dart';
import 'package:mylm/screen/main/layanan/tambah_layanan/location_maps_screen.dart';
import 'package:mylm/data/models/customer/register_cust/register_customer_request.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:mylm/data/network/geocoding_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylm/data/cubit/register_cust/form_register_cubit.dart';
import 'package:mylm/data/cubit/register_cust/form_register_state.dart';
import 'package:flutter/services.dart';
import 'package:mylm/data/cubit/register_cust/region_cubit.dart';
import 'package:mylm/data/cubit/register_cust/region_state.dart';

class DaftarLayanan2Screen extends StatefulWidget {
  final int productId;

  const DaftarLayanan2Screen({
    super.key,
    required this.productId,

  });

  @override
  State<DaftarLayanan2Screen> createState() => _DaftarLayanan2ScreenState();
}

class _DaftarLayanan2ScreenState extends State<DaftarLayanan2Screen> {
  final _formKey = GlobalKey<FormState>();

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  // Controller untuk setiap field
  final _namaController = TextEditingController();
  final _hpController = TextEditingController();
  final _emailController = TextEditingController();
  final _alamatController = TextEditingController();
  final _latController = TextEditingController();
  final _longController = TextEditingController();

  bool _isFilled = false;
  Uint8List? _mapPreview;

  @override
  void initState() {
    super.initState();

    _namaController.addListener(_checkFormFilled);
    _hpController.addListener(_checkFormFilled);
    _emailController.addListener(_checkFormFilled);
    _alamatController.addListener(_checkFormFilled);

    context.read<TermConditionsCubit>().loadTerms();
  }

  void _checkFormFilled() {

    final regionState =
        context.read<RegionCubit>().state;

    setState(() {

      _isFilled =
          _namaController.text.isNotEmpty &&
              _hpController.text.isNotEmpty &&
              _emailController.text.isNotEmpty &&
              _alamatController.text.isNotEmpty &&

              regionState.selectedProvince != null &&
              regionState.selectedRegency != null &&
              regionState.selectedDistrict != null &&
              regionState.selectedVillage != null;
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hpController.dispose();
    _emailController.dispose();
    _alamatController.dispose();
    _latController.dispose();
    _longController.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<FormRegisterCubit, FormRegisterState>(
      listener: (context, state) {
        if (state is FormRegisterSubmitSuccess) {
          showSuccessDialogGuest(context);
        }

        if (state is FormRegisterError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/svgs/arrow_back.svg",
            colorFilter: const ColorFilter.mode(
              Colors.black,
              BlendMode.srcIn,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Daftar Layanan",
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Lengkapi Data",
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),

              BlocBuilder<TermConditionsCubit, TermConditionsState>(
                builder: (context, state) {
                  if (state is TermConditionsLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8)
                    );
                  }

                  if (state is TermConditionsLoaded) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        state.data.termconditions,
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          height: 1.5,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  }

                  if (state is TermConditionsError) {
                    return Text(
                      state.message,
                      style: GoogleFonts.inter(fontSize: 13.sp),
                    );
                  }

                  return const SizedBox();
                },
              ),


              SizedBox(height: 16.h),

              Text(
                "Lokasi",
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),

              Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: _mapPreview != null
                        ? MemoryImage(_mapPreview!)
                        : const AssetImage("assets/images/maps_dummy.png")
                    as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.location_pin, color: darkorange, size: 40),
                ),
              ),

              SizedBox(height: 12.h),

              // Tombol Lokasi Saya
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 160.w,
                  height: 42.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LocationMapsScreen(),
                        ),
                      );

                      if (result != null && result is Map) {
                        final GeoPoint point = result['point'];
                        final Uint8List? image = result['image'];

                        setState(() {
                          _latController.text = point.latitude.toString();
                          _longController.text = point.longitude.toString();
                          _mapPreview = image; // simpan screenshot di variabel state
                        });

                        // reverse geocoding
                        final address = await GeocodingService.getAddressFromCoordinates(
                            point.latitude, point.longitude);

                        if (address != null) {
                          setState(() {
                            // Detail alamat
                            _alamatController.text = [
                              address['house_number'],
                              address['road'],
                              address['residential'],
                              address['neighbourhood'],
                              address['hamlet'],
                            ].where((e) => e != null && e.toString().isNotEmpty).join(', ');



                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.black,
                              duration: const Duration(seconds: 3),
                              content: Text(
                                " ${_alamatController.text.isNotEmpty ? _alamatController.text : 'Alamat tidak lengkap'}",
                              ),
                            ),
                          );
                        },
                          );
                        }
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [(darkorange), (orange)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Center(
                        child: Text(
                          "Lokasi Saya",
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: false, // Invisible UI
                child: Column(
                  children: [
                    buildLabeledTextField("Latitude", _latController),
                    buildLabeledTextField("Longitude", _longController),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Label + TextField Inputs
              buildLabeledTextField("Nama Lengkap", _namaController),
              buildLabeledTextField("No. Handphone", _hpController),
              buildLabeledTextField("Email", _emailController),
              buildLabeledTextField("Alamat", _alamatController),

              SizedBox(height: 8.h),

              BlocBuilder<RegionCubit, RegionState>(
                builder: (context, regionState) {

                  return Column(
                    children: [


                      // PROVINCE
                      buildDropdownField(
                        title: "Pilih Provinsi",

                        value:
                        regionState.selectedProvince,

                        items:
                        regionState.provinces,

                        onTap: () async {

                          final selected =
                          await showRegionBottomSheet(
                            title: "Pilih Provinsi",
                            context: context,
                            items:
                            regionState.provinces,
                          );

                          if (selected != null) {

                            context
                                .read<RegionCubit>()
                                .selectProvince(
                              selected,
                            );

                            _checkFormFilled();
                          }
                        },
                      ),

                      SizedBox(height: 14.h),


                      // REGENCY
                      buildDropdownField(
                        title: "Pilih Kabupaten/Kota",

                        value:
                        regionState.selectedRegency,

                        items:
                        regionState.regencies,

                        onTap: regionState
                            .selectedProvince ==
                            null
                            ? null
                            : () async {

                          final selected =
                          await showRegionBottomSheet(
                            context: context,
                            title:
                            "Pilih Kabupaten/Kota",

                            items:
                            regionState.regencies,
                          );

                          if (selected != null) {

                            context
                                .read<RegionCubit>()
                                .selectRegency(
                              selected,
                            );

                            _checkFormFilled();
                          }
                        },
                      ),

                      SizedBox(height: 14.h),


                      // DISTRICT
                      buildDropdownField(
                        title: "Pilih Kecamatan",

                        value:
                        regionState.selectedDistrict,

                        items:
                        regionState.districts,

                        onTap: regionState
                            .selectedRegency ==
                            null
                            ? null
                            : () async {

                          final selected =
                          await showRegionBottomSheet(
                            context: context,
                            title:
                            "Pilih Kecamatan",

                            items:
                            regionState.districts,
                          );

                          if (selected != null) {

                            context
                                .read<RegionCubit>()
                                .selectDistrict(
                              selected,
                            );

                            _checkFormFilled();
                          }
                        },
                      ),

                      SizedBox(height: 14.h),


                      // VILLAGE
                      buildDropdownField(
                        title: "Pilih Kelurahan",

                        value:
                        regionState.selectedVillage,

                        items:
                        regionState.villages,

                        onTap: regionState
                            .selectedDistrict ==
                            null
                            ? null
                            : () async {

                          final selected =
                          await showRegionBottomSheet(
                            context: context,
                            title:
                            "Pilih Kelurahan",

                            items:
                            regionState.villages,
                          );

                          if (selected != null) {

                            context
                                .read<RegionCubit>()
                                .selectVillage(
                              selected,
                            );

                            _checkFormFilled();
                          }
                        },
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: 24.h),

              // Kirim
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 300.w,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: _isFilled
                        ? () async {
                      if (!_formKey.currentState!.validate()) return;

                      final confirm = await showConfirmationDialog(context);
                      if (confirm != true) return;

                      //kirim data ke API
                      final regionState =
                          context.read<RegionCubit>().state;

                      final request = RegisterCustomerRequest(

                        customerName:
                        _namaController.text,

                        customerPhone:
                        _hpController.text,

                        email:
                        _emailController.text,

                        customerAddress:
                        _alamatController.text,

                        latitude:
                        double.parse(
                          _latController.text.isEmpty
                              ? '0'
                              : _latController.text,
                        ),

                        longitude:
                        double.parse(
                          _longController.text.isEmpty
                              ? '0'
                              : _longController.text,
                        ),

                        coverage: null,

                        regionId:
                        regionState.selectedVillage!.id,

                        productId:
                        widget.productId,

                        productCategoryId: 6,

                        divisionId: null,

                        referralCode: null,
                      );

                          // Log isi data yang akan dikirim
                          print("Kirim Data:");
                          print(request.toJson());

                          context.read<FormRegisterCubit>().register(request);
                          }
                        : null,
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      backgroundColor: _isFilled
                          ? null
                          : WidgetStateProperty.all(Colors.grey.shade300),
                      padding: WidgetStateProperty.all(EdgeInsets.zero),
                      elevation: WidgetStateProperty.all(0),
                    ),
                    child: Ink(
                      decoration: _isFilled
                          ? BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [(darkorange), (orange)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      )
                          : null,
                      child: Center(
                        child: Text(
                          "Kirim",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: _isFilled
                                ? Colors.white
                                : Colors.black45,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
    );
  }
  }