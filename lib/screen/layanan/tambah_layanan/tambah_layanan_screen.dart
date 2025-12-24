import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/currency_formatter.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/data/network/services/get/get_packages.dart';
import 'package:mylm/screen/layanan/tambah_layanan/tambah_layanan2_screen.dart';
import 'package:mylm/data/models/product/packages_response.dart';
import 'package:mylm/base/widgets/skeleton_shimmer/skeleton_loading.dart';

class TambahLayananScreen extends StatefulWidget {
  final String custNumber;
  final String accessToken;
  final String custGroupId;


  const TambahLayananScreen({
    super.key,
    required this.custNumber,
    required this.accessToken,
    required this.custGroupId,
  });

  @override
  State<TambahLayananScreen> createState() => _TambahLayananScreenState();
}

class _TambahLayananScreenState extends State<TambahLayananScreen> {
  String? _selectedPaket;
  bool isLoading = true;
  List<PackageData> packages = [];

  @override
  void initState() {
    super.initState();
    _fetchPackages();
  }

  Future<void> _fetchPackages() async {
    final api = PackagesService();
    final response = await api.getPackages();

    if (response != null && response.success == 1) {
      setState(() {
        packages = response.data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("Gagal memuat data packages");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: isLoading
            ? ListView.separated(
          itemCount: 3, // jumlah dummy skeleton
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (_, __) {
            return Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SkeletonLoading(width: double.infinity, height: 20.h),
            );
          },
        )

            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih Paket Layanan",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.separated(
                itemCount: packages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final pkg = packages[index];
                  return _buildPaketItem(
                    title: pkg.spName,
                    subtitle: "Kecepatan Internet s/d ${pkg.spName.replaceAll(RegExp(r'[^0-9]'), '')} Mbps",
                    harga: "${formatRupiah(pkg.spPrice)}/bulan",
                    value: pkg.spCodeId,
                  );
                },
              ),
            ),

            // Tombol Selanjutnya
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 300.w,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: _selectedPaket == null
                      ? null
                      : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TambahLayanan2Screen(
                              custNumber: widget.custNumber,
                              accessToken: widget.accessToken,
                              packageId: _selectedPaket!,
                              custGroupId: widget.custGroupId,
                            ),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    backgroundColor: _selectedPaket == null
                        ? WidgetStateProperty.all(Colors.grey.shade300)
                        : null,
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                    elevation: WidgetStateProperty.all(0),
                  ),
                  child: Ink(
                    decoration: _selectedPaket == null
                        ? null
                        : BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [darkorange, orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Selanjutnya",
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: _selectedPaket == null
                              ? Colors.black45
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPaketItem({
    required String title,
    required String subtitle,
    required String harga,
    required String value,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        setState(() {
          _selectedPaket = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [darkorange, orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.wifi, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 12),

            // Info paket
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    harga,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // Radio
            Radio<String>(
              value: value,
              groupValue: _selectedPaket,
              activeColor: darkorange,
              onChanged: (val) {
                setState(() {
                  _selectedPaket = val;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}


