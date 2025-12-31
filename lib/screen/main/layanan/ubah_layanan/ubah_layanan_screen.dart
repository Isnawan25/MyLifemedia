import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/data/cubit/term_conditions/term_conditions_cubit.dart';
import 'package:mylm/data/models/product/exists_package_response.dart';
import 'package:mylm/screen/main/layanan/ubah_layanan/ubah_layanan2_screen.dart';
import 'package:mylm/base/widgets/skeleton_shimmer/skeleton_loading.dart';
import 'package:mylm/base/currency_formatter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylm/data/cubit/register_cust/packages_register_cubit.dart';
import 'package:mylm/data/cubit/register_cust/packages_register_state.dart';


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


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => PackagesCubit()..fetchPackages(),
        child: Scaffold(
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
          child: BlocBuilder<PackagesCubit, PackagesState>(
              builder: (context, state) {
                // loading
                if (state is PackagesLoading) {
                  return ListView.separated(
                    itemCount: 3,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (_, __) {
                      return Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: SkeletonLoading(
                          width: double.infinity,
                          height: 20.h,
                        ),
                      );
                    },
                  );
                }
                // error
                if (state is PackagesError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: GoogleFonts.inter(color: Colors.red),
                    ),
                  );
                }
                // LOADED
                if (state is PackagesLoaded) {
                  return Column(
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

                      ...state.packages.map(
                            (pkg) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildPaketItem(
                            title: pkg.spName,
                            subtitle:
                            "Kecepatan Internet s/d ${pkg.spCode.replaceAll(RegExp(r'[^0-9]'), '')} Mbps",
                            harga: "${formatRupiah(pkg.spPrice)}/bulan",
                            onTap: () {
                              context
                                  .read<PackagesCubit>()
                                  .selectPackage(pkg.spCodeId);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                        create: (_) => TermConditionsCubit()..loadTerms(),
                                      ),
                                    ],
                                  child: UbahLayanan2Screen(
                                    custNumber: widget.custNumber,
                                    accessToken: widget.accessToken,
                                    packagePrice: pkg.spPrice,
                                    custGroupId: widget.custGroupId,
                                    newPackageId: pkg.spCodeId,
                                    currentPackage: widget.currentPackage,
                                  ),
                                ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const Spacer(),
                    ],
                  );
                }

                return const SizedBox();
              },
      ),
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

