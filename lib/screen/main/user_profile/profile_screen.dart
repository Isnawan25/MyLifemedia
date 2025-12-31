import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/base/widgets/text_utils.dart';
import 'package:mylm/data/network/services/get/get_profile.dart';
import 'package:mylm/screen/auth/login_screen.dart';
import 'package:mylm/screen/main/main_screen.dart';
import 'package:mylm/data/models/user_profile/detail_profile_response.dart';
import 'package:mylm/data/preferences/user_preferences.dart';
import 'package:mylm/data/preferences/secure_storage.dart';
import 'package:mylm/base/widgets/skeleton_shimmer/skeleton_loading.dart';


class ProfileScreen extends StatefulWidget {
  final String custNumber;
  final String accessToken;
  final String custGroupId;


  const ProfileScreen({
    super.key,
    required this.custNumber,
    required this.accessToken,
    required this.custGroupId,
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

    final api = ProfileService();
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
                  custGroupId: widget.custGroupId,
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

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: isLoadingProfile
            ? _buildProfileSkeleton()
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoField(
              label: "ID Pelanggan",
              value: profile?.custNumber ?? "-",
              showEditButton: false,
            ),
            SizedBox(height: 12.h),

            _buildInfoField(
              label: "Nama Lengkap",
              value: shortText(profile?.custName ?? "-", limit: 30),
              showEditButton: false,
            ),
            SizedBox(height: 12.h),

            _buildInfoField(
              label: "Alamat",
              value: shortText(profile?.custAddress ?? "-", limit: 36),
              showEditButton: false,
            ),
            SizedBox(height: 12.h),

            _buildInfoField(
              label: "No. Handphone",
              value: profile?.custPhone ?? "-",
              showEditButton: false,
            ),
            SizedBox(height: 12.h),

            _buildInfoField(
              label: "Email",
              value: profile?.custEmail ?? "-",
              showEditButton: false,
            ),

            const Spacer(),
            const LogoutButton(),
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

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          Feedback.forTap(context);

          final confirmLogout = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              title: Text(
                "Keluar Aplikasi",
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: Text(
                "Apakah Anda yakin ingin keluar dari akun ini?",
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: Colors.black54,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    "Batal",
                    style: GoogleFonts.inter(color: Colors.grey[700]),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [darkorange, orange],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(
                        "Keluar",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        )
                    ),
                  ),
                ),
              ],
            ),
          );

          if (confirmLogout == true) {
            try {
              await SecureStorage.clear();
              await UserPreferences.clear();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (_) => false,
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Gagal logout, coba lagi")),
              );
            }
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [darkorange, orange],
              ).createShader(bounds),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}



Widget _buildProfileSkeleton() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(5, (index) {
      return Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // label skeleton
            SkeletonLoading(
              width: 120.w,
              height: 12.h,
              radius: 4,
            ),
            SizedBox(height: 6.h),

            // value field skeleton
            SkeletonLoading(
              width: double.infinity,
              height: 44.h,
              radius: 8,
            ),
          ],
        ),
      );
    }),
  );
}
