import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylm/base/currency_formatter.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mylm/base/widgets/text_utils.dart';
import 'package:mylm/screen/add_nopel/add_custlist_screen.dart';
import 'package:mylm/screen/main/manage_bills/bayar_tagihan/bayar_tagihan_screen.dart';
import 'package:mylm/screen/layanan/tambah_layanan/tambah_layanan_screen.dart';
import 'package:mylm/screen/layanan/ubah_layanan/ubah_layanan_screen.dart';
import 'package:mylm/screen/main/main_profile_screen.dart';
import 'package:mylm/screen/notification/notification_screen.dart';
import 'package:mylm/data/network/api_service.dart';
import 'package:mylm/data/models/product/promotion_response.dart';
import 'package:mylm/base/widgets/skeleton_loading.dart';
import 'package:mylm/data/models/user_profile/detail_profile_response.dart';
import 'package:shimmer/shimmer.dart';
import 'package:mylm/data/models/product/exists_package_response.dart';
import 'package:mylm/data/preferences/secure_storage.dart';



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
  ExistsPackage? existsPackage;
  bool isLoadingPackage = true;

  late String currentCustNumber;
  late String currentCustGroupId;

  @override
  void initState() {
    super.initState();
    _loadCurrentCust();
  }
  Future<void> _loadCurrentCust() async {
    String? savedCustNumber = await SecureStorage.getCustNumber();
    String? savedCustGroupId = await SecureStorage.getCustGroupId();

    setState(() {
      currentCustNumber = savedCustNumber ?? widget.custNumber;
      currentCustGroupId = savedCustGroupId ?? widget.custGroupId;
    });

    _loadProfile();
    _loadExistingPackage();
  }

  Future<void> _loadProfile() async {
    setState(() => isLoadingProfile = true);
    final api = ApiService();
    final result = await api.getProfile(
      currentCustNumber,
      widget.accessToken,
      context,
    );

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

  Future<void> _loadExistingPackage() async {
    setState(() => isLoadingPackage = true);
    final api = ApiService();
    final result = await api.getExistingPackage(
      currentCustGroupId,
      currentCustNumber,
      widget.accessToken,
    );

    setState(() {
      existsPackage = result;
      isLoadingPackage = false;
    });
  }

  Future<void> _openAddCustList() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => AddCustlistScreen(
          custNumber: currentCustNumber,
          accessToken: widget.accessToken,
          custGroupId: currentCustGroupId,
        ),
      ),
    );

    if (result != null) {
      final newCustNumber = result['custNumber'];
      final newCustGroupId = result['custGroupId'];

      if (newCustNumber != null && newCustGroupId != null) {
        await SecureStorage.saveCustNumber(newCustNumber);
        await SecureStorage.saveCustGroupId(newCustGroupId);

        setState(() {
          currentCustNumber = newCustNumber;
          currentCustGroupId = newCustGroupId;
          isLoadingProfile = true;
          isLoadingPackage = true;
        });

        await _loadProfile();
        await _loadExistingPackage();
      }
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainProfileScreen(
                                  accessToken: widget.accessToken,
                                  custNumber: currentCustNumber,
                                  custGroupId: currentCustGroupId,
                                ),
                              ),
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
                                    shortText(profile?.custName ?? "Nama Tidak Tersedia", limit: 25),
                                    style: GoogleFonts.inter(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: darkorange,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      (widget.accessToken.isNotEmpty) ? "Aktif" : "Nonaktif",
                                      style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const NotificationScreen()),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isLoadingProfile ? "..." : profile?.custNumber ?? "ID Pelanggan tidak tersedia",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isLoadingProfile ? "..." : shortText(profile?.custAddress, limit: 36),
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                ),
                              ),
                              const Divider(color: Colors.white54, height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Layanan Internet",
                                          style: GoogleFonts.inter(
                                            color: Colors.white70,
                                            fontSize: 12.sp,
                                          )),
                                      Text(
                                          isLoadingPackage ? "..." : (existsPackage?.spCode ?? "-"),
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
                                      Text(
                                          isLoadingPackage
                                              ? "..."
                                              : formatRupiah(existsPackage?.spReguler ?? 0),
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
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
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
                          _buildFeature(context, "assets/svgs/icons_cart.svg", "Tambah Layanan", onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TambahLayananScreen(
                                custNumber: currentCustNumber,
                                accessToken: widget.accessToken,
                                custGroupId: currentCustGroupId,
                              )),
                            );
                          }),
                          _buildFeature(context, "assets/svgs/icons_repost.svg", "Ubah Layanan", onTap: () {
                            if (isLoadingPackage || existsPackage == null) {
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
                              MaterialPageRoute(builder: (context) => UbahLayananScreen(
                                custNumber: currentCustNumber,
                                accessToken: widget.accessToken,
                                custGroupId: currentCustGroupId,
                                currentPackage: existsPackage,
                              )),
                            );
                          }),
                          _buildFeature(context, "assets/svgs/icons_invoice.svg", "Bayar Tagihan",
                              onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => BayarTagihanScreen(
                                  accessToken: widget.accessToken,
                                  custNumber: currentCustNumber,)));
                          }),
                        ],
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

              FutureBuilder<List<Promotion>>(
                future: ApiService().getPromotions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: SkeletonLoading(height: 280),
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
                                height: 280.h,
                                width: double.infinity,
                                color: Colors.grey.shade200,
                                child: Image.network(
                                  promo.photo,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 280.h,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return Shimmer.fromColors(
                                      baseColor: Colors.grey.shade300,
                                      highlightColor: Colors.grey.shade100,
                                      child: Container(
                                        height: 280.h,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    height: 280.h,
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

Widget _buildFeature(BuildContext context, String svgPath, String title,
    {VoidCallback? onTap}) {
  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: onTap,
    child: Column(
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [darkorange, orange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: SvgPicture.asset(
            svgPath,
            width: 45.w,
            height: 45.h,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              )
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
