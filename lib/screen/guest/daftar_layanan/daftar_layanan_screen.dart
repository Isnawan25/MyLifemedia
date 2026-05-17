import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/base/widgets/paketItem.dart';
import 'package:mylm/base/widgets/skeleton_shimmer/skeleton_loading.dart';
import 'package:mylm/data/cubit/register_cust/form_register_cubit.dart';
import 'package:mylm/data/cubit/register_cust/newpackages_cubit.dart';
import 'package:mylm/data/cubit/register_cust/newpackages_state.dart';
import 'package:mylm/data/cubit/register_cust/region_cubit.dart';
import 'package:mylm/data/cubit/term_conditions/term_conditions_cubit.dart';
import 'package:mylm/screen/guest/daftar_layanan/daftar_layanan2_screen.dart';

class DaftarLayananScreen extends StatefulWidget {
  const DaftarLayananScreen({super.key});

  @override
  State<DaftarLayananScreen> createState() =>
      _DaftarLayananScreenState();
}

class _DaftarLayananScreenState
    extends State<DaftarLayananScreen> {

  int? selectedProductId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewPackagesCubit()..fetchPackages(),

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
            onPressed: () => Navigator.pop(context),
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

        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),

          child: BlocBuilder<NewPackagesCubit, NewPackagesState>(
            builder: (context, state) {

              // LOADING
              if (state is NewPackagesLoading) {
                return ListView.separated(
                  itemCount: 3,
                  separatorBuilder: (_, __) =>
                      SizedBox(height: 12.h),

                  itemBuilder: (_, __) =>
                      SkeletonLoading(height: 60.h),
                );
              }

              // ERROR
              if (state is NewPackagesError) {
                return Center(
                  child: Text(state.message),
                );
              }

              // SUCCESS
              if (state is NewPackagesLoaded) {
                return Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(
                      "Pilih Paket Layanan",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    Expanded(
                      child: ListView.separated(
                        itemCount: state.packages.length,

                        separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),

                        itemBuilder: (context, index) {

                          final pkg =
                          state.packages[index];

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedProductId =
                                    pkg.productId;
                              });
                            },

                            child: PaketItem(
                              data: pkg,
                              selectedId: selectedProductId?.toString(),
                              onTap: () {
                                setState(() {
                                  selectedProductId = pkg.productId;
                                });
                              },
                            ),
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
                          onPressed:
                          selectedProductId == null
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
                                      create: (_) => TermConditionsCubit()
                                        ..loadTerms(),
                                    ),

                                    BlocProvider(
                                      create: (_) => RegionCubit()
                                        ..getProvinces(),
                                    ),

                                  ],

                                  child: DaftarLayanan2Screen(
                                    productId: selectedProductId!,
                                  ),
                                ),
                              ),
                            );
                          },

                          style: ButtonStyle(
                            shape:
                            WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                    30),
                              ),
                            ),

                            backgroundColor:
                            selectedProductId == null
                                ? WidgetStateProperty.all(
                              Colors.grey.shade300,
                            )
                                : WidgetStateProperty.all(
                              Colors.transparent,
                            ),

                            padding:
                            WidgetStateProperty.all(
                                EdgeInsets.zero),

                            elevation:
                            WidgetStateProperty.all(0),
                          ),

                          child: Ink(
                            decoration:
                            selectedProductId == null
                                ? null
                                : BoxDecoration(
                              gradient:
                              const LinearGradient(
                                colors: [
                                  darkorange,
                                  orange,
                                ],

                                begin:
                                Alignment
                                    .topLeft,

                                end: Alignment
                                    .bottomRight,
                              ),

                              borderRadius:
                              BorderRadius
                                  .circular(
                                  30),
                            ),

                            child: Container(
                              alignment: Alignment.center,

                              child: Text(
                                "Selanjutnya",

                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  fontWeight:
                                  FontWeight.w600,

                                  color:
                                  selectedProductId ==
                                      null
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

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}