import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mylm/base/widgets/text_utils.dart';
import 'package:mylm/screen/fitur_layanan/bayar_tagihan/bayar_tagihan_empty_screen.dart';
import 'package:mylm/screen/fitur_layanan/tambah_layanan/tambah_layanan_screen.dart';
import 'package:mylm/screen/fitur_layanan/ubah_layanan/ubah_layanan_screen.dart';
import 'package:mylm/screen/main/main_profile_screen.dart';
import 'package:mylm/screen/message/pesan_screen.dart';
import 'package:mylm/data/network/api_service.dart';
import 'package:mylm/data/models/product/promotion_response.dart';
import 'package:mylm/base/widgets/skeleton_loading.dart';
import 'package:mylm/data/models/user_profile/detail_profile_response.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mylm/base/widgets/icons_colors.dart';

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
  DetailProfileData? profile;
  bool isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => isLoadingProfile = true);

    final api = ApiService();
    final result = await api.getProfile(widget.custNumber, widget.accessToken, context);

    if (result != null && result.success == 1 && result.data != null) {
      setState(() {
        profile = result.data!;
        isLoadingProfile = false;
      });
    } else {
      setState(() => isLoadingProfile = false);
      print("Gagal memuat profil");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => MainProfileScreen(
                                  accessToken: widget.accessToken,
                                  custNumber: widget.custNumber,
                                  custGroupId: widget.custGroupId,
                                ))
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                  color: darkorange,
                                ),
                              ),
                              const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  shortText(profile?.custName ?? "....", limit: 25),
                                  style: GoogleFonts.inter(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: darkorange,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "Aktif",
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      const PesanScreen(),
                                    ),
                                  );
                                },
                                icon: SvgPicture.asset(
                                  "assets/svgs/icons_notification.svg",
                                  width: 28.w,
                                  height: 28.h,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Info Tagihan Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isLoadingProfile ? "..."
                                    : profile?.custNumber ?? "ID Pelanggan tidak tersedia",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isLoadingProfile
                                    ? "..." : shortText(profile?.custAddress, limit: 36),
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis, // aman ganda
                              ),

                              const Divider(color: Colors.white54, height: 20),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text("Layanan Internet",
                                          style: GoogleFonts.inter(
                                            color: Colors.white70,
                                            fontSize: 12.sp,
                                          )),
                                      Text("Izzi Life 30",
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text("Total Tagihan",
                                          style: GoogleFonts.inter(
                                            color: Colors.white70,
                                            fontSize: 12.sp,
                                          )),
                                      Text("Rp 166.500",
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ],
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildFeature(context, "assets/svgs/icons_cart.svg",
                              "Tambah Layanan", onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => TambahLayananScreen(
                                    custNumber: widget.custNumber,
                                    accessToken: widget.accessToken,
                                    custGroupId: widget.custGroupId

                                )
                                ),
                            );
                              }),
                          buildFeature(context, "assets/svgs/icons_repost.svg",
                              "Ubah Layanan", onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => UbahLayananScreen(
                                  custNumber: widget.custNumber,
                                  accessToken: widget.accessToken,
                                  custGroupId: widget.custGroupId,

                                )));

                              }),
                          buildFeature(context, "assets/svgs/icons_invoice.svg",
                              "Bayar Tagihan", onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder:
                                    (context) => const BayarTagihanEmptyScreen()));
                              }),
                        ],
                      ),
                    ),
                  )
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

              FutureBuilder<List<Promotion>>(
                future: ApiService().getPromotions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: SkeletonLoading(),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Gagal memuat promosi: ${snapshot.error}"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text("Belum ada penawaran."),
                    );
                  } else {
                    final promotions = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: promotions.map((promo) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 180,
                                width: double.infinity,
                                color: Colors.grey.shade200,
                                child: Image.network(
                                  promo.photo,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 180,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    // shimmer loading
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        height: 180,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  },
                                  // jika gagal load/404
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    height: 180,
                                    color: Colors.grey.shade300,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
