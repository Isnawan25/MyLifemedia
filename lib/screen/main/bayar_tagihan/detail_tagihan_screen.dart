import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/data/models/bill/detail_bill_response.dart';
import 'package:mylm/base/date_formatter.dart';
import 'package:mylm/base/currency_formatter.dart';
import 'package:mylm/data/network/services/post/post_detail_bill.dart';

class DetailTagihanScreen extends StatelessWidget {
  final String accessToken;
  final String piNumber;

  const DetailTagihanScreen({
    super.key,
    required this.accessToken,
    required this.piNumber,
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
          "Detail Tagihan",
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),

      body: FutureBuilder<DetailBillResponse>(
        future: DetailBillService().getDetailBill(
          accessToken: accessToken,
          piNumber: piNumber,
        ),

        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error (misal statusCode != 201)
          if (snapshot.hasError) {
            return const Center(
              child: Text("Gagal memuat detail tagihan"),
            );
          }

          // Tidak ada data
          if (!snapshot.hasData) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          final data = snapshot.data!.data;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Invoice: ${data.invNumber}",
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _buildDetailRow("Pelanggan", data.custNumber),
                  _buildDetailRow("Layanan", data.spName),
                  _buildDetailRow("Metode Bayar", data.payMethod),
                  _buildDetailRow("Jatuh Tempo", formatTanggal(data.invDue)),
                  _buildDetailRow(
                      "Status",
                      data.invStatus == 1 ? "LUNAS" : "BELUM DIBAYAR"
                  ),
                  _buildDetailRow(
                    "Total",
                    formatRupiah(num.tryParse(data.totals) ?? 0),
                  ),
                  _buildDetailRow(
                    "Tanggal Pembayaran",
                    data.payDate != null ? formatTanggal(data.payDate) : "-",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
