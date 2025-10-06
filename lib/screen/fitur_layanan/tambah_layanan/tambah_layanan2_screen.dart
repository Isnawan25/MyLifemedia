import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/screen/main/main_screen.dart';

class TambahLayanan2Screen extends StatefulWidget {
  const TambahLayanan2Screen({super.key});

  @override
  State<TambahLayanan2Screen> createState() => _TambahLayanan2ScreenState();
}

class _TambahLayanan2ScreenState extends State<TambahLayanan2Screen> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk setiap field
  final _namaController = TextEditingController();
  final _hpController = TextEditingController();
  final _emailController = TextEditingController();
  final _alamatController = TextEditingController();
  final _kelurahanController = TextEditingController();
  final _kecamatanController = TextEditingController();
  final _kotaController = TextEditingController();
  final _provinsiController = TextEditingController();

  bool _isFilled = false;

  @override
  void initState() {
    super.initState();
    _namaController.addListener(_checkFormFilled);
    _hpController.addListener(_checkFormFilled);
    _emailController.addListener(_checkFormFilled);
    _alamatController.addListener(_checkFormFilled);
    _kelurahanController.addListener(_checkFormFilled);
    _kecamatanController.addListener(_checkFormFilled);
    _kotaController.addListener(_checkFormFilled);
    _provinsiController.addListener(_checkFormFilled);
  }

  void _checkFormFilled() {
    setState(() {
      _isFilled = _namaController.text.isNotEmpty &&
          _hpController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
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
    _alamatController.dispose();
    _kelurahanController.dispose();
    _kecamatanController.dispose();
    _kotaController.dispose();
    _provinsiController.dispose();
    super.dispose();
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

              // Gambar map dummy
              Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/maps_dummy.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.location_pin, color: Colors.red, size: 40),
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Mendeteksi lokasi Anda..."),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [(darkorange), (orange)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
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

              SizedBox(height: 24.h),

              // Label + TextField Inputs
              _buildLabeledTextField("Nama Lengkap", _namaController),
              _buildLabeledTextField("No. Handphone", _hpController),
              _buildLabeledTextField("Email", _emailController),
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
                      bool? confirm = await _showConfirmationDialog(context);

                      if (confirm == true) {
                        // Tampilkan popup sukses jika user klik YA
                        _showSuccessDialog(context);
                      }
                    }
                        : null,

                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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

  // 🔹 Versi baru dengan label di atas TextField
  Widget _buildLabeledTextField(String label, TextEditingController controller) {
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
  //Pop-up Konfirmasi
  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Apakah kamu yakin data yang dimasukkan sudah benar?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                "TIDAK",
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                "YA",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

// 🔹 Pop-up Sukses
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                Image.asset(
                    "assets/images/success.gif",
                  height: 120.h,
                  width: 120.w,),

              const SizedBox(height: 16),
              const Text(
                "Data kamu sudah terkirim!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Tim kami akan segera menghubungi kamu,\nuntuk proses lebih lanjut.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Tutup dialog
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
                },
                child: const Text(
                  "Kembali ke Beranda",
                  style: TextStyle(
                    color: Colors.pink,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}
