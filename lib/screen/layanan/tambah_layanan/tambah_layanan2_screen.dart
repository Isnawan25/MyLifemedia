import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/base/popup/popup.dart';
import 'package:mylm/data/network/api_service.dart';
import 'package:mylm/screen/layanan/tambah_layanan/location_maps_screen.dart';
import 'package:mylm/data/models/customer/register_cust/register_customer_request.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:mylm/data/network/geocoding_service.dart';
import 'dart:typed_data';
import 'package:mylm/data/models/support/term_conditions_response.dart';


class TambahLayanan2Screen extends StatefulWidget {
  final String custNumber;
  final String accessToken;
  final String packageId;
  final String custGroupId;

  const TambahLayanan2Screen({
    super.key,
    required this.custNumber,
    required this.accessToken,
    required this.packageId,
    required this.custGroupId,
  });

  @override
  State<TambahLayanan2Screen> createState() => _TambahLayanan2ScreenState();
}

class _TambahLayanan2ScreenState extends State<TambahLayanan2Screen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;
  TermConditionsData? termData;

  // Controller untuk setiap field
  final _namaController = TextEditingController();
  final _hpController = TextEditingController();
  final _emailController = TextEditingController();
  final _alamatController = TextEditingController();
  final _kodeposController = TextEditingController();
  final _kelurahanController = TextEditingController();
  final _kecamatanController = TextEditingController();
  final _kotaController = TextEditingController();
  final _provinsiController = TextEditingController();
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
    _kodeposController.addListener(_checkFormFilled);
    _alamatController.addListener(_checkFormFilled);
    _kelurahanController.addListener(_checkFormFilled);
    _kecamatanController.addListener(_checkFormFilled);
    _kotaController.addListener(_checkFormFilled);
    _provinsiController.addListener(_checkFormFilled);
    _loadTerms();
  }

  void _checkFormFilled() {
    setState(() {
      _isFilled = _namaController.text.isNotEmpty &&
          _hpController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _kodeposController.text.isNotEmpty &&
          _alamatController.text.isNotEmpty &&
          _kelurahanController.text.isNotEmpty &&
          _kecamatanController.text.isNotEmpty &&
          _kotaController.text.isNotEmpty &&
          _provinsiController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hpController.dispose();
    _emailController.dispose();
    _kodeposController.dispose();
    _alamatController.dispose();
    _kelurahanController.dispose();
    _kecamatanController.dispose();
    _kotaController.dispose();
    _provinsiController.dispose();
    _latController.dispose();
    _longController.dispose();

    super.dispose();
  }

  Future<void> _loadTerms() async {
    final apiService = ApiService();
    final result = await apiService.getTermConditions();
    if (mounted) {
      setState(() {
        termData = result?.data;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Tambah Layanan",
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

              isLoading
                  ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
              )
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: termData == null
                    ? Text(
                  "Gagal memuat Syarat & Ketentuan.",
                  style: GoogleFonts.inter(fontSize: 13.sp),
                )
                    : Text(
                  termData!.termconditions,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),
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

                            // Kelurahan
                            _kelurahanController.text = address['village'] ??
                                address['suburb'] ??
                                address['neighbourhood'] ??
                                '';

                            // Kecamatan
                            _kecamatanController.text = address['city_district'] ??
                                address['district'] ??
                                address['suburb'] ??
                                '';

                            // Kota
                            _kotaController.text = address['city'] ??
                                address['town'] ??
                                address['municipality'] ??
                                address['county'] ??
                                '';

                            // Provinsi
                            _provinsiController.text = address['state'] ?? '';

                            // Kode pos
                            _kodeposController.text = address['postcode'] ?? '';
                          });

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
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Gagal membaca alamat lokasi")),
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
                    _buildLabeledTextField("Latitude", _latController),
                    _buildLabeledTextField("Longitude", _longController),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Label + TextField Inputs
              _buildLabeledTextField("Nama Lengkap", _namaController),
              _buildLabeledTextField("No. Handphone", _hpController),
              _buildLabeledTextField("Email", _emailController),
              _buildLabeledTextField("Kode Pos", _kodeposController),
              _buildLabeledTextField("Alamat", _alamatController),
              _buildLabeledTextField("Kelurahan", _kelurahanController),
              _buildLabeledTextField("Kecamatan", _kecamatanController),
              _buildLabeledTextField("Kabupaten/Kota", _kotaController),
              _buildLabeledTextField("Provinsi", _provinsiController),

              SizedBox(height: 24.h),

              // Tombol Kirim
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 300.w,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: _isFilled
                        ? () async {
                      bool? confirm = await showConfirmationDialog(context);

                      if (confirm == true) {
                        try {
                          final request = RegisterCustomerRequest(
                            custName: _namaController.text,
                            custPhone: _hpController.text,
                            custEmail: _emailController.text,
                            custPostalCode: int.parse(_kodeposController.text),
                            custProvince: _provinsiController.text,
                            custDistrict: _kotaController.text,
                            custSubDistrict: _kecamatanController.text,
                            custVillage: _kelurahanController.text,
                            custAddress: _alamatController.text,
                            custLat: double.parse(_latController.text.isEmpty ? '0' : _latController.text),
                            custLong: double.parse(_longController.text.isEmpty ? '0' : _longController.text),
                            packageId: widget.packageId,
                          );

                          // Log isi data yang akan dikirim
                          print("Kirim Data:");
                          print(request.toJson());

                          print("Mengirim Req ke server...");
                          final response = await ApiService().registerCustomer(request);

                          print("Response diterima dari server:");
                          print("Status: ${response.success}");
                          print("Pesan: ${response.message}");

                          if (response.success == 1) {
                            print("Data berhasil dikirim dan diterima server!");
                            showSuccessDialog(context,
                              custNumber: widget.custNumber,
                              accessToken: widget.accessToken,
                                custGroupId: widget.custGroupId);
                          } else {
                            print("Server menolak data: ${response.message}");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Gagal: ${response.message}")),
                            );
                          }
                        } catch (e) {
                          print("Terjadi error saat mengirim data: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: $e")),
                          );
                        }
                      }
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
    );
  }

  Widget _buildLabeledTextField(String label, TextEditingController controller) {
    final bool isEmailOrPhone = label.toLowerCase().contains('email') || label.toLowerCase().contains('handphone');
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 6.h),
          TextFormField(
            controller: controller,
            textCapitalization:
            isEmailOrPhone ? TextCapitalization.none : TextCapitalization.words,
            keyboardType: isEmailOrPhone && label.toLowerCase().contains('email')
                ? TextInputType.emailAddress
                : TextInputType.text,
            decoration: InputDecoration(
              hintText: "Masukkan $label",
              hintStyle: GoogleFonts.inter(
                color: Colors.grey.shade400,
                fontSize: 14.sp,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding:
              EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
