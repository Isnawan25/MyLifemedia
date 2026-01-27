import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylm/base/currency_formatter.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mylm/base/widgets/buildFeature.dart';
import 'package:mylm/base/widgets/text_utils.dart';
import 'package:mylm/data/network/services/get/get_profile.dart';
import 'package:mylm/screen/main/add_nopel/add_custlist_screen.dart';
import 'package:mylm/screen/main/bayar_tagihan/bayar_tagihan_screen.dart';
import 'package:mylm/screen/main/layanan/tambah_layanan/tambah_layanan_screen.dart';
import 'package:mylm/screen/main/layanan/ubah_layanan/ubah_layanan_screen.dart';
import 'package:mylm/screen/main/main_profile_screen.dart';
import 'package:mylm/screen/main/notification/notification_screen.dart';
import 'package:mylm/base/widgets/skeleton_shimmer/skeleton_loading.dart';
import 'package:mylm/data/cubit/notification/notification_read_cubit.dart';
import 'package:mylm/data/cubit/notification/notification_read_state.dart';
import 'package:mylm/data/cubit/current_cust_loaded/current_cust_cubit.dart';
import 'package:mylm/data/cubit/current_cust_loaded/current_cust_state.dart';
import 'package:mylm/data/cubit/promotions/promotions_cubit.dart';
import 'package:mylm/data/cubit/promotions/promotions_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylm/data/cubit/profile/profile_cubit.dart';
import 'package:mylm/data/cubit/profile/profile_state.dart';
import 'package:mylm/data/cubit/exists_package/exists_package_cubit.dart';
import 'package:mylm/data/cubit/exists_package/exists_package_state.dart';
import 'package:mylm/data/cubit/customer_status/customer_status_cubit.dart';
import 'package:mylm/data/cubit/customer_status/customer_status_state.dart';



class HomeScreen extends StatefulWidget {
  final String custNumber;
  final String accessToken;
  final String custGroupId;


  const HomeScreen({
    super.key,
    required this.custNumber,
    required this.accessToken,
    required this.custGroupId,
  });
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? currentCustNumber;
  String? currentCustGroupId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });

    context.read<CurrentCustCubit>().load(
      defaultCustNumber: widget.custNumber,
      defaultCustGroupId: widget.custGroupId,
    );

    context.read<NotificationReadCubit>().check();
    context.read<PromotionsCubit>().fetchPromotions();
    context.read<CustomerStatusCubit>().fetchStatus(widget.custNumber);

  }


  Future<void> _openAddCustList() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => AddCustlistScreen(
            custNumber: currentCustNumber!,
            accessToken: widget.accessToken,
            custGroupId: currentCustGroupId!,
          ),
        ),
      );

    if (result != null) {
      final custNumber = result['custNumber'];
      final custGroupId = result['custGroupId'];

      if (custNumber != null && custGroupId != null) {
        context.read<CurrentCustCubit>().change(
          custNumber: custNumber,
          custGroupId: custGroupId,
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrentCustCubit, CurrentCustState>(
        listener: (context, state) {
          if (state is CurrentCustLoaded) {
            currentCustNumber = state.custNumber;
            currentCustGroupId = state.custGroupId;

            context.read<ProfileCubit>().fetch(
              custNumber: state.custNumber,
              accessToken: widget.accessToken,
              context: context,
            );

            context.read<ExistsPackageCubit>().fetch(
              custGroupId: state.custGroupId,
              custNumber: state.custNumber,
              accessToken: widget.accessToken,
            );
            context.read<CustomerStatusCubit>()
                .fetchStatus(state.custNumber);
          }
        },
        child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Background Gradient
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 66),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [darkorange, orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profil
                        GestureDetector(
                          onTap: () {
                            Feedback.forTap(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                  create: (_) => ProfileCubit(ProfileService())
                                    ..fetch(
                                      custNumber: widget.custNumber,
                                      accessToken: widget.accessToken,
                                      context: context,
                                    ),
                                  child: MainProfileScreen(
                                    custNumber: currentCustNumber??"",
                                    accessToken: widget.accessToken,
                                    custGroupId: currentCustGroupId??"",
                                  ),
                                ),
                              ),
                            );

                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar
                              BlocBuilder<ProfileCubit, ProfileState>(
                                builder: (context, state) {
                                  if (state is ProfileLoading) {
                                    return skeletonCircle(size: 56);
                                  }

                                  if (state is ProfileLoaded) {
                                    return const CircleAvatar(
                                      radius: 28,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.person, size: 40, color: darkorange),
                                    );
                                  }

                                  return skeletonCircle(size: 56);
                                },
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BlocBuilder<ProfileCubit, ProfileState>(
                                      builder: (context, state) {
                                        if (state is ProfileLoaded) {
                                          return Text(
                                            state.profile.custName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          );
                                        }

                                        return skeletonText(width: 160, height: 18);
                                      },
                                    ),

                                    const SizedBox(height: 4),

                                    BlocBuilder<CustomerStatusCubit, CustomerStatusState>(
                                      builder: (context, state) {
                                        if (state is CustomerStatusLoading) {
                                          return skeletonText(
                                            width: 60,
                                            height: 12,
                                            radius: 10,
                                          );
                                        }

                                        if (state is CustomerStatusLoaded) {
                                          final status = state.status.custStatus.toLowerCase();
                                          final isActive = status.contains("aktif") &&
                                              !status.contains("tidak");

                                          return Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isActive ? Colors.green : darkorange,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              isActive ? "Aktif" : "Tidak Aktif",
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          );
                                        }

                                        if (state is CustomerStatusError) {
                                          return Text(
                                            "Status tidak tersedia",
                                            style: GoogleFonts.inter(
                                              fontSize: 12.sp,
                                              color: Colors.white70,
                                            ),
                                          );
                                        }

                                        return const SizedBox.shrink();
                                      },
                                    ),

                                  ],
                                )
                                ),

                              BlocBuilder<NotificationReadCubit, NotificationReadState>(
                                builder: (context, state) {
                                  final hasUnread =
                                      state is NotificationReadLoaded && state.hasUnread;

                                  return IconButton(
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const NotificationScreen(),
                                        ),
                                      );
                                      context.read<NotificationReadCubit>().check();
                                    },
                                    icon: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/svgs/icons_notification.svg",
                                          width: 32.w,
                                          height: 32.h,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        if (hasUnread)
                                          Positioned(
                                            right: -1,
                                            top: -1,
                                            child: Container(
                                              width: 9.w,
                                              height: 9.w,
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        ),
                        const SizedBox(height: 12),

                        // Tambah ID Pelanggan
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _openAddCustList,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Tambah ID Pelanggan',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Transform.flip(
                                    flipX: true,
                                    child: SvgPicture.asset(
                                      'assets/svgs/arrow_back.svg',
                                      width: 14,
                                      height: 14,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Info Tagihan Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: BlocBuilder<ProfileCubit, ProfileState>(
                            builder: (context, profileState) {
                              return BlocBuilder<ExistsPackageCubit, ExistsPackageState>(
                                builder: (context, packageState) {

                                  final isLoading =
                                      profileState is ProfileLoading ||
                                          packageState is ExistsPackageLoading;

                                  if (isLoading) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        skeletonText(width: 140),
                                        const SizedBox(height: 6),
                                        skeletonText(width: 220, height: 13),
                                        const Divider(color: Colors.white54, height: 20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                skeletonText(width: 90, height: 12),
                                                const SizedBox(height: 6),
                                                skeletonText(width: 120),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                skeletonText(width: 80, height: 12),
                                                const SizedBox(height: 6),
                                                skeletonText(width: 100),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }

                                  if (profileState is ProfileLoaded &&
                                      packageState is ExistsPackageLoaded &&
                                      packageState.package != null) {

                                    final pkg = packageState.package!;


                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        BlocBuilder<ProfileCubit, ProfileState>(
                                          builder: (context, state) {
                                            if (state is ProfileLoaded) {
                                              final profile = state.profile;

                                              return Text(
                                                profile.custNumber,
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              );
                                            }
                                            return const SizedBox();
                                          },
                                        ),

                                        const SizedBox(height: 4),
                                        BlocBuilder<ProfileCubit, ProfileState>(
                                          builder: (context, state) {
                                            if (state is ProfileLoaded) {
                                              final profile = state.profile;

                                              return Text(
                                                shortText(profile.custAddress, limit: 36),
                                                style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontSize: 13.sp,
                                                ),
                                              );
                                            }

                                            return const SizedBox();
                                          },
                                        ),
                                        const Divider(color: Colors.white54, height: 20),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Layanan Internet",
                                                  style: GoogleFonts.inter(
                                                    color: Colors.white70,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                                Text(
                                                  pkg.spCode,
                                                  style: GoogleFonts.inter(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Total Tagihan",
                                                  style: GoogleFonts.inter(
                                                    color: Colors.white70,
                                                    fontSize: 12.sp,
                                                  ),
                                                ),
                                                Text(
                                                  formatRupiah(pkg.spReguler),
                                                  style: GoogleFonts.inter(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  }

                                  return const SizedBox.shrink();
                                },
                              );
                            },
                          ),
                        ),

                      ],
                      ),
                    ),

                  // Box Fitur Layanan
                  Positioned(
                    left: 24.w,
                    right: 24.w,
                    bottom: -55.h,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),

                      child: BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, profileState) {
                          final loadingProfile = profileState is ProfileLoading;
                          final profile =
                          profileState is ProfileLoaded ? profileState.profile : null;

                          return BlocBuilder<ExistsPackageCubit, ExistsPackageState>(
                            builder: (context, packageState) {
                              final loadingPackage = packageState is ExistsPackageLoading;
                              final package = packageState is ExistsPackageLoaded
                                  ? packageState.package
                                  : null;

                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [

                                  // ================= TAMBAH LAYANAN =================
                                  loadingProfile
                                      ? Column(
                                    children: [
                                      skeletonIcon(size: 32),
                                      const SizedBox(height: 8),
                                      skeletonText(width: 70, height: 12),
                                    ],
                                  )
                                      : buildFeature(
                                    context,
                                    "assets/svgs/icons_cart.svg",
                                    "Tambah Layanan",
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => TambahLayananScreen(
                                            custNumber: profile!.custNumber,
                                            accessToken: widget.accessToken,
                                            custGroupId: currentCustGroupId??"-",
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  // ================= UBAH LAYANAN =================
                                  loadingProfile
                                      ? Column(
                                    children: [
                                      skeletonIcon(size: 32),
                                      const SizedBox(height: 8),
                                      skeletonText(width: 70, height: 12),
                                    ],
                                  )

                                      : buildFeature(
                                    context,
                                    "assets/svgs/icons_repost.svg",
                                    "Ubah Layanan",
                                    onTap: () {
                                      if (loadingPackage || package == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              "Sedang memuat paket aktif...",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            backgroundColor: Colors.black,
                                            duration: const Duration(seconds: 3),
                                          ),
                                        );
                                        return;
                                      }


                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => UbahLayananScreen(
                                            custNumber: profile!.custNumber,
                                            accessToken: widget.accessToken,
                                            custGroupId: currentCustGroupId??"-",
                                            currentPackage: package,
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  // ================= BAYAR TAGIHAN =================
                                  loadingProfile
                                      ? Column(
                                    children: [
                                      skeletonIcon(size: 32),
                                      const SizedBox(height: 8),
                                      skeletonText(width: 70, height: 12),
                                    ],
                                  )
                                      : buildFeature(
                                    context,
                                    "assets/svgs/icons_invoice.svg",
                                    "Bayar Tagihan",
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BayarTagihanScreen(
                                            accessToken: widget.accessToken,
                                            custNumber: profile!.custNumber,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 70),

              // Penawaran
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Penawaran",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              //Tolong tambahkan fungsi cubit dari PromotionsCubit seperti HomePreviewScreen.dart yang saya kirim diatas kode HomeScreen ini,
              // soalnya untuk fungsi ini belum aktif
              BlocBuilder<PromotionsCubit, PromotionsState>(
                builder: (context, state) {
                  if (state is PromotionsLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: SkeletonLoading(height: 280),
                    );
                  }

                  if (state is PromotionsError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(state.message),
                    );
                  }

                  if (state is PromotionsLoaded) {
                    if (state.promotions.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text("Belum ada penawaran."),
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: state.promotions.map((promo) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                promo.photo,
                                height: 280.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
        )
    );
  }


// SKELETON HELPERS
  Widget skeletonText({
    double width = double.infinity,
    double height = 14,
    double radius = 6,
  }) {
    return SkeletonLoading(
      width: width,
      height: height,
      radius: radius,
    );
  }

  Widget skeletonCircle({
    double size = 40,
  }) {
    return SkeletonLoading(
      width: size,
      height: size,
      radius: size / 2,
    );
  }

  Widget skeletonIcon({
    double size = 32,
  }) {
    return SkeletonLoading(
      width: size,
      height: size,
      radius: 8,
    );
  }

}