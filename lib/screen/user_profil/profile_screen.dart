import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/base/widgets/text_utils.dart';
import 'package:mylm/screen/login_screen.dart';
import 'package:mylm/screen/main/main_screen.dart';
import 'package:mylm/screen/user_profil/edit_alamat/edit_alamat_screen.dart';
import 'package:mylm/screen/user_profil/edit_email_screen.dart';
import 'package:mylm/screen/user_profil/edit_nama_screen.dart';
import 'package:mylm/screen/user_profil/edit_nomor_screen.dart';
import 'package:mylm/data/models/user_profile/detail_profile_response.dart';
import 'package:mylm/data/network/api_service.dart';
import 'package:mylm/data/preferences/user_preferences.dart';
import 'package:mylm/data/preferences/secure_storage.dart';

class ProfileScreen extends StatefulWidget {
  final String custNumber;
  final String accessToken;

  const ProfileScreen({
    super.key,
    required this.custNumber,
    required this.accessToken
  });
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    final result = await api.getProfile(widget.custNumber, widget.accessToken);

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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/svgs/arrow_back.svg",
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MainScreen(
                  custNumber: widget.custNumber,
                  accessToken: widget.accessToken,
                )));
          },
        ),
        centerTitle: true,
        title: Text(
          "Informasi Akun",
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),

      // --- BODY
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ID Pelanggan
            _buildInfoField(
              label: "ID Pelanggan",
              value: isLoadingProfile ? "..."
                  : profile?.custNumber ?? "ID Pelanggan tidak tersedia",
              showEditButton: false,
            ),
            SizedBox(height: 12.h),

            // Nama Lengkap
            _buildInfoField(
              label: "Nama Lengkap",
              value: shortText(profile?.custName ?? "...", limit: 30),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const EditNamaScreen()));
              },
            ),
            SizedBox(height: 12.h),

            _buildInfoField(
              label: "Alamat",
              value: isLoadingProfile
                  ? "..." : shortText(profile?.custAddress, limit: 36),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const EditAlamatScreen()));
              },
            ),

            SizedBox(height: 12.h),

            // No. Handphone
            _buildInfoField(
              label: "No. Handphone",
              value: profile?.custPhone ?? "No. Handphone Tidak Tersedia",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const EditNomorScreen()));
              },
            ),

            SizedBox(height: 12.h),

            // Email
            _buildInfoField(
              label: "Email",
              value: profile?.custEmail ?? "Email Tidak Tersedia",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const EditEmailScreen()));
              },
            ),

            const Spacer(),

            // Tombol Keluar
            Center(
              child: GestureDetector(
                onTap: () async {
                  // 🔹 Tampilkan dialog konfirmasi logout
                  final confirmLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Text(
                        "Keluar Aplikasi",
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      content: Text(
                        "Apakah Anda yakin ingin keluar dari akun ini?",
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Colors.black54,
                        ),
                      ),
                      actionsAlignment: MainAxisAlignment.end,
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            "Batal",
                            style: GoogleFonts.inter(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [(darkorange), (orange)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            onPressed: () => Navigator.pop(context, true),
                            child: Text(
                              "Keluar",
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )

                      ],
                    ),
                  );

                  // 🔹 Jika user memilih "Keluar"
                  if (confirmLogout == true) {
                    try {
                      // Hapus semua data user yang tersimpan
                      await SecureStorage.clear(); // token, session, dsb.
                      await UserPreferences.clear(); // data prefs seperti nama, email, dsb.

                      // 🔹 Arahkan ke LoginScreen dan hapus semua route sebelumnya
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false,
                      );
                    } catch (e) {
                      debugPrint("Logout error: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Gagal logout, coba lagi.")),
                      );
                    }
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return const LinearGradient(
                          colors: [darkorange, orange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcIn,
                      child: SvgPicture.asset(
                        "assets/svgs/icons_exit.svg",
                        width: 28.w,
                        height: 28.h,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      "Keluar",
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  /// Widget Reusable untuk setiap field informasi
  Widget _buildInfoField({
    required String label,
    required String value,
    VoidCallback? onPressed,
    bool showEditButton = true,
    int maxLines = 1,
    TextOverflow overflow = TextOverflow.ellipsis
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  maxLines: maxLines,
                  overflow: overflow,
                ),
              ),
              if (showEditButton)
                InkWell(
                  onTap: onPressed,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [darkorange, orange],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Text(
                      "Edit",
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
