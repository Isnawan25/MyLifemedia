import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/data/models/bill/bill_last_response.dart';
import 'package:mylm/data/network/api_service.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:mylm/base/currency_formatter.dart';
import 'package:mylm/base/date_formatter.dart';
import 'package:mylm/screen/main/manage_bills/bayar_tagihan/detail_tagihan_screen.dart';

class BayarTagihanScreen extends StatelessWidget {
  final String custNumber;
  final String accessToken;

  const BayarTagihanScreen({
    super.key,
    required this.custNumber,
    required this.accessToken,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
          "Pembayaran Tagihan",
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),

      body: FutureBuilder<List<BillItem>>(
        future: ApiService().getBillLast(
          accessToken: accessToken,
          custNumber: custNumber,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Gagal memuat data"));
          }

          final bills = snapshot.data ?? [];

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: bills.isEmpty
                ? _buildEmpty()
                : _buildBillCard(context, bills.first),
          );
        },
      ),
    );
  }

  // EMPTY PAGE
  Widget _buildEmpty() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/no_empty_logo.png",
          height: 200.h,
        ),
        Text(
          "Belum ada Tagihan untuk saat ini",
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  // CARD
  Widget _buildBillCard(BuildContext context, BillItem bill) {
    return Column(
      children: [
        SizedBox(height: 20.h),

        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                children: [
                  Text(
                    bill.spCode,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: darkorange,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "BELUM DIBAYAR",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 5.h),

              Text(
                formatRupiah(num.tryParse(bill.totals.toString()) ?? 0),
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  color: darkorange,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 6.h),

              Text(
                "Bayar Sebelum: ${formatTanggal(bill.invDue)}",
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: Colors.black54,
                ),
              ),

              SizedBox(height: 16.h),

              // BUTTON BAYAR
              Center(
                child: Container(
                  width: 300.w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [darkorange, orange],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => _getPaymentUrl(context),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        child: Center(
                          child: Text(
                            "Bayar Sekarang",
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 14),

              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailTagihanScreen(
                          accessToken: accessToken,
                          piNumber: bill.invNumber,
                        ),
                      ),
                    );
                  },

                  child: Text(
                    "No. Tagihan: ${bill.invNumber}",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: darkorange,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
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


  // PAYMENT URL
  void _getPaymentUrl(BuildContext context) async {
    try {
      final urlResponse = await ApiService()
          .getUrlBill(accessToken: accessToken, custNumber: custNumber);

      _openCustomTab(urlResponse.url);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal mengambil URL pembayaran")),
      );
    }
  }

  void _openCustomTab(String url) async {
    try {
      await launchUrl(
        Uri.parse(url),
        customTabsOptions: const CustomTabsOptions(showTitle: true),
      );
    } catch (e) {
      debugPrint("Gagal membuka custom tab: $e");
    }
  }
}
