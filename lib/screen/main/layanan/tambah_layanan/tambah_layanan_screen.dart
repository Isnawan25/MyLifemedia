import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/base/widgets/paketItem.dart';
import 'package:mylm/data/cubit/register_cust/form_register_cubit.dart';
import 'package:mylm/data/cubit/term_conditions/term_conditions_cubit.dart';
import 'package:mylm/screen/main/layanan/tambah_layanan/tambah_layanan2_screen.dart';
import 'package:mylm/base/widgets/skeleton_shimmer/skeleton_loading.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylm/data/cubit/register_cust/packages_register_cubit.dart';
import 'package:mylm/data/cubit/register_cust/packages_register_state.dart';

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
          child: BlocBuilder<PackagesCubit, PackagesState>(
            builder: (context, state) {
              if (state is PackagesLoading) {
                return ListView.separated(
                  itemCount: 3,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (_, __) => SkeletonLoading(height: 60.h),
                );
              }

              if (state is PackagesError) {
                return Center(child: Text(state.message));
              }

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

                    Expanded(
                      child: ListView.separated(
                        itemCount: state.packages.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final pkg = state.packages[index];
                          return PaketItem(
                            data: pkg,
                            selectedId: state.selectedPackageId,
                            onTap: () => context
                                .read<PackagesCubit>()
                                .selectPackage(pkg.spCodeId),
                          );
                        },
                      ),
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 300.w,
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed: state.selectedPackageId == null
                              ? null
                              : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (_) => FormRegisterCubit(),
                                    ),
                                    BlocProvider(
                                      create: (_) => TermConditionsCubit()..loadTerms(),
                                    ),
                                  ],
                                  child: TambahLayanan2Screen(
                                    custNumber: widget.custNumber,
                                    accessToken: widget.accessToken,
                                    custGroupId: widget.custGroupId,
                                    packageId: state.selectedPackageId!,
                                  ),
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
                            backgroundColor: state.selectedPackageId == null
                                ? WidgetStateProperty.all(Colors.grey.shade300)
                                : WidgetStateProperty.all(Colors.transparent),
                            padding: WidgetStateProperty.all(EdgeInsets.zero),
                            elevation: WidgetStateProperty.all(0),
                          ),
                          child: Ink(
                            decoration: state.selectedPackageId == null
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
                                  color: state.selectedPackageId == null
                                      ? Colors.black45
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox(height: 20);
            },
          ),
        ),
    ),
    );
  }
}


