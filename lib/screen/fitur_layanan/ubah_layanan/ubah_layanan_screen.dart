import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/screen/fitur_layanan/ubah_layanan/ubah_layanan2_screen.dart';

class UbahLayananScreen extends StatefulWidget {
  const UbahLayananScreen({super.key});

  @override
  State<UbahLayananScreen> createState() => _UbahLayananScreenState();
}

class _UbahLayananScreenState extends State<UbahLayananScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
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

            // Paket 1
            _buildPaketItem(
              title: "izzi life 30",
              subtitle: "Kecepatan Internet s/d 30 Mbps",
              harga: "Rp 150.000/bulan",
              value: "paket30",
            ),
            const SizedBox(height: 12),

            // Paket 2
            _buildPaketItem(
              title: "izzi life 50",
              subtitle: "Kecepatan Internet s/d 50 Mbps",
              harga: "Rp 250.000/bulan",
              value: "paket50",
            ),
            const SizedBox(height: 12),

            // Paket 3
            _buildPaketItem(
              title: "izzi life 100",
              subtitle: "Kecepatan Internet s/d 100 Mbps",
              harga: "Rp 350.000/bulan",
              value: "paket100",
            ),
            const SizedBox(height: 12),

            // Paket 4
            _buildPaketItem(
              title: "izzi life 200",
              subtitle: "Kecepatan Internet s/d 200 Mbps",
              harga: "Rp 600.000/bulan",
              value: "paket200",
            ),

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
    required String value,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
Navigator.push(context,
    MaterialPageRoute(builder: (context) => const UbahLayanan2Screen()));
      },
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
            // Kotak ikon wifi
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

            // Teks info paket
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

