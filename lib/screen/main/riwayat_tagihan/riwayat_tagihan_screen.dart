import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/base/currency_formatter.dart';
import 'package:mylm/base/widgets/skeleton_shimmer/skeleton_loading.dart';
import 'package:mylm/data/models/bill/bill_list_response.dart';
import 'package:mylm/data/network/services/get/get_bill_list.dart';
import 'package:mylm/screen/main/main_screen.dart';
import 'package:mylm/screen/main/riwayat_tagihan/detail_tagihan_screen.dart';
import 'package:mylm/base/date_formatter.dart';

class RiwayatTagihanScreen extends StatefulWidget {
  final String custNumber;
  final String accessToken;
  final String custGroupId;

  const RiwayatTagihanScreen({
    super.key,
    required this.accessToken,
    required this.custNumber,
    required this.custGroupId,
  });

  @override
  State<RiwayatTagihanScreen> createState() => _RiwayatTagihanScreenState();
}

class _RiwayatTagihanScreenState extends State<RiwayatTagihanScreen> {
  late Future<BillListResponse> _billFuture;

  @override
  void initState() {
    super.initState();
    _billFuture = BillListService().getBillList(
      custNumber: widget.custNumber,
      accessToken: widget.accessToken,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/svgs/arrow_back.svg",
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(
                custNumber: widget.custNumber,
                accessToken: widget.accessToken,
                custGroupId: widget.custGroupId,
              ),
            ),
          ),
        ),
        title: Text(
          "Riwayat Tagihan",
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: FutureBuilder<BillListResponse>(
        future: _billFuture,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.separated(
              itemCount: 12, // jumlah dummy skeleton
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (_, __) {
                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SkeletonLoading(width: double.infinity, height: 20.h),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
            return const Center(child: Text("Belum ada data tagihan"));
          }

          final tagihanList = snapshot.data!.data;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: ListView.separated(
              itemCount: tagihanList.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final tagihan = tagihanList[index];
                final isBelumBayar = tagihan.invStatus == 0;
                final statusText = isBelumBayar
                    ? "Menunggu Pembayaran"
                    : "Sudah dibayar";
                final tanggalPembayaran = isBelumBayar
                    ? "Menunggu Pembayaran"
                    : "Sudah dibayar ${formatTanggalWaktu(tagihan.payDate)}";

                return InkWell(
                  borderRadius: BorderRadius.circular(16.r),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailTagihanScreen(
                          Periode:
                          "${formatTanggal(tagihan.invStart)} - ${formatTanggal(tagihan.invDue)}",
                          idTagihan: tagihan.invNumber,
                          paketInternet: tagihan.spName,
                          Pembayaran: tagihan.payMethod ?? "Belum Bayar",
                          harga: formatRupiah(num.tryParse(tagihan.totals.toString()) ?? 0),
                          status: statusText,
                          tanggalPembayaran: tagihan.payDate ?? "-",
                        ),
                      ),
                    );
                  },
                  splashColor: Colors.orange.withValues(alpha: 0.1),
                  child: Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [darkorange, orange],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.w),
                            child: SvgPicture.asset(
                              isBelumBayar
                                  ? "assets/svgs/icons_three_dots.svg"
                                  : "assets/svgs/icons_invoice2.svg",
                              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                            ),
                          ),
                        ),

                        SizedBox(width: 12.w),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tagihan.invNumber,
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                formatRupiah(num.tryParse(tagihan.totals.toString()) ?? 0),
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                tanggalPembayaran,
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                  color: isBelumBayar
                                      ? Colors.orange[800]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Transform.flip(
                          flipX: true,
                          child: SvgPicture.asset(
                            "assets/svgs/arrow_back.svg",
                            width: 16.w,
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
              },
            ),
          );
        },
      ),
    );
  }
}
