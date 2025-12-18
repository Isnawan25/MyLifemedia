import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mylm/data/network/api_service.dart';
import 'package:mylm/data/models/product/promotion_response.dart';
import 'package:mylm/base/widgets/skeleton_shimmer/skeleton_loading.dart';
import 'package:mylm/screen/guest/daftar_layanan/daftar_layanan_screen.dart';
import 'package:mylm/screen/guest/welcome_screen.dart';
import 'package:mylm/data/network/check_internet_connection.dart';


class HomePreviewScreen extends StatefulWidget {

  const HomePreviewScreen({
    super.key,
  });
  @override
  _HomePreviewScreenState createState() => _HomePreviewScreenState();
}

class _HomePreviewScreenState extends State<HomePreviewScreen> {

  late Future<List<Promotion>> _promotionsFuture;


  @override
  void initState() {
    super.initState();

    _promotionsFuture = ApiService().getPromotions();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetConnection(
        context,
        onConnected: _reloadHomeData,
      );
    });
  }

  void _reloadHomeData() {
    setState(() {
      _promotionsFuture = ApiService().getPromotions();
    });
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
                            Feedback.forTap(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WelcomeScreen(
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
                                children: [
                                  Text(
                                    "Anda Belum Login",
                                    style: GoogleFonts.inter(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                                  );
                                },
                                icon: SvgPicture.asset(
                                  "assets/svgs/icons_notification.svg",
                                  width: 32.w,
                                  height: 32.h,
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
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => WelcomeScreen()));
                            },
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

                        // Guest Access Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.20),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              // === MYLM LOGO (SAFE SIZE) ===
                              SizedBox(
                                height: 40, // aman, tidak bikin card turun
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Image.asset("assets/images/mylm_logo.png"),
                                ),
                              ),

                              SizedBox(height: 12),

                              Text(
                                "Akses Layanan MyLifemedia",
                                style: GoogleFonts.inter(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),

                              SizedBox(height: 6),

                              Text(
                                "Masukkan ID Pelanggan untuk mulai menggunakan layanan MyLifemedia. "
                                    "Jika Anda belum memiliki ID, silakan daftar layanan terlebih dahulu.",
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),

                              SizedBox(height: 14),

                              Row(
                                children: [
                                  // Tombol Masuk
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => WelcomeScreen()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: darkorange,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: Text(
                                        "Masuk",
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 12),

                                  // Tombol Daftar Layanan
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => DaftarLayananScreen()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      child: Text(
                                        "Daftar Layanan",
                                        style: GoogleFonts.inter(
                                          fontSize: 14.sp,
                                          color: darkorange,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
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
                              MaterialPageRoute(builder: (context) => WelcomeScreen(
                              )),
                            );
                          }),
                          _buildFeature(context, "assets/svgs/icons_repost.svg", "Ubah Layanan", onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WelcomeScreen(
                              )),
                            );
                          }),
                          _buildFeature(context, "assets/svgs/icons_invoice.svg", "Bayar Tagihan",
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => WelcomeScreen(
                                    )));
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
                future: _promotionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: SkeletonLoading(height: 280),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Gagal memuat promosi"),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text("Belum ada penawaran."),
                    );
                  }

                  final promotions = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: promotions.map((promo) {
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
          ),
          )
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
