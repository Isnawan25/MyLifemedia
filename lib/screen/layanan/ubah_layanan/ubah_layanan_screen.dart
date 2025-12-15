import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/data/models/product/exists_package_response.dart';
import 'package:mylm/screen/layanan/ubah_layanan/ubah_layanan2_screen.dart';
import 'package:mylm/data/network/api_service.dart';
import 'package:mylm/data/models/product/packages_response.dart';
import 'package:mylm/base/widgets/skeleton_shimmer/skeleton_loading.dart';
import 'package:mylm/base/currency_formatter.dart';

class UbahLayananScreen extends StatefulWidget {
  final String custNumber;
  final String accessToken;
  final String custGroupId;
  final ExistsPackage? currentPackage;


  const UbahLayananScreen({
    super.key,
    required this.custNumber,
    required this.accessToken,
    required this.custGroupId,
    required this.currentPackage,
  });

  @override
  State<UbahLayananScreen> createState() => _UbahLayananScreenState();
}

class _UbahLayananScreenState extends State<UbahLayananScreen> {
  bool isLoading = true;
  List<PackageData> packages = [];

  @override
  void initState() {
    super.initState();
    _fetchPackages();
  }

  Future<void> _fetchPackages() async {
    final api = ApiService();
    final result = await api.getPackages();

    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      setState(() {
        if (result != null && result.success == 1) {
          packages = result.data;
        }
        isLoading = false;
      });
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
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Perubahan Layanan",
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


            ...packages.map((pkg) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildPaketItem(
                title: pkg.spName,
                subtitle:
                "Kecepatan Internet s/d ${pkg.spCode.replaceAll(RegExp(r'[^0-9]'), '')} Mbps",
                harga:
                "${formatRupiah(pkg.spPrice)}/bulan",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UbahLayanan2Screen(
                        custNumber: widget.custNumber,
                        accessToken: widget.accessToken,
                        packagePrice: pkg.spPrice,
                        custGroupId: widget.custGroupId,
                        newPackageId: pkg.spCodeId,
                        currentPackage: widget.currentPackage,
                      ),
                    ),
                  );
                },
              ),
            )),
            const Spacer(),
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
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
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

            Transform.flip(
              flipX: true,
              child: SvgPicture.asset(
                "assets/svgs/arrow_back.svg",
                width: 14.w,
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

