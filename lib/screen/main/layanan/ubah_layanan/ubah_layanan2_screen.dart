import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/base/popup/showSuccessDialogLoggedin.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mylm/data/cubit/term_conditions/term_conditions_cubit.dart';
import 'package:mylm/data/models/product/exists_package_response.dart';
import 'package:mylm/data/models/product/upgrade_package_request.dart';
import 'package:mylm/data/network/services/post/post_upgrade_packages.dart';
import 'package:mylm/base/currency_formatter.dart';
import 'package:mylm/data/preferences/secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylm/data/cubit/term_conditions/term_conditions_state.dart';



class UbahLayanan2Screen extends StatefulWidget {
  final String custNumber;
  final String accessToken;
  final int packagePrice;
  final String custGroupId;
  final String newPackageId;
  final ExistsPackage? currentPackage;


  const UbahLayanan2Screen({
    super.key,
    required this.custNumber,
    required this.accessToken,
    required this.packagePrice,
    required this.custGroupId,
    required this.newPackageId,
    required this.currentPackage
  });

  @override
  State<UbahLayanan2Screen> createState() => _UbahLayanan2ScreenState();
}

class _UbahLayanan2ScreenState extends State<UbahLayanan2Screen> {
  bool isChecked = false;

  // DATA PROFIL (diambil dari SecureStorage)
  String? custName;
  String? custPhone;
  String? custEmail;
  String? custProvince;
  String? custDistrict;
  String? custSubDistrict;
  String? custVillage;
  String? custAddress;

  final TextEditingController accManagerController = TextEditingController();
  String? accManager;

  @override
  void dispose() {
    accManagerController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    _loadCustomerData();
  }

  Future<void> _loadCustomerData() async {
    custName = await SecureStorage.getCustName();
    custPhone = await SecureStorage.getCustPhone();
    custEmail = await SecureStorage.getCustEmail();
    custProvince = await SecureStorage.getCustProvince();
    custDistrict = await SecureStorage.getCustDistrict();
    custSubDistrict = await SecureStorage.getCustSubDistrict();
    custVillage = await SecureStorage.getCustVillage();
    custAddress = await SecureStorage.getCustAddress();

    print("CUSTOMER PROFILE LOADED FROM STORAGE");
    print("custNumber: ${widget.custNumber}");
    print("custName: $custName");
    print("custPhone: $custPhone");
    print("custEmail: $custEmail");
    print("custProvince: $custProvince");
    print("custDistrict: $custDistrict");
    print("custSubDistrict: $custSubDistrict");
    print("custVillage: $custVillage");
    print("custAddress: $custAddress");
  }



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TermConditionsCubit()..loadTerms(),
      child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rincian Tagihan Baru",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Card harga
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Builder(
                builder: (context) {
                  final total = widget.packagePrice + (widget.packagePrice * 0.11).round();
                  return Column(
                    children: [
                      _buildPriceRow(
                        "Tagihan Internet",
                        "${formatRupiah(widget.packagePrice)}",
                      ),
                      const SizedBox(height: 8),
                      _buildPriceRow(
                        "PPN 11%",
                        "${formatRupiah((widget.packagePrice * 0.11).round())}",
                      ),
                      const Divider(thickness: 1, height: 20),
                      _buildPriceRow(
                        "Total",
                        formatRupiah(total),
                        isBold: true,
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Account Manager (Opsional)",
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: accManagerController,
              textInputAction: TextInputAction.done,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: "Masukkan Account Manager (Opsional)",
                hintStyle: GoogleFonts.inter(
                  fontSize: 13.sp,
                  color: Colors.grey.shade500,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                accManager = value.trim().isEmpty ? null : value.trim();
              },
            ),

            const SizedBox(height: 24),


            Text(
              "Syarat dan Ketentuan",
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: BlocBuilder<TermConditionsCubit, TermConditionsState>(
                builder: (context, state) {
                  if (state is TermConditionsLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                    );
                  }

                  if (state is TermConditionsError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: GoogleFonts.inter(fontSize: 13.sp),
                      ),
                    );
                  }

                  if (state is TermConditionsLoaded) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Html(
                        data: state.data.termconditions,
                        style: {
                          "body": Style(
                            margin: Margins.zero,
                            padding: HtmlPaddings.zero,
                            fontSize: FontSize(13.sp),
                            color: Colors.black87,
                            fontFamily: GoogleFonts.inter().fontFamily,
                            lineHeight: LineHeight.number(1.5),
                            textAlign: TextAlign.justify,
                          ),
                          "a": Style(
                            color: darkorange,
                            textDecoration: TextDecoration.underline,
                          ),
                        },
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),


            const SizedBox(height: 12),

            // Checkbox
            GestureDetector(
              behavior: HitTestBehavior.opaque, // area klik full
              onTap: () {
                setState(() {
                  isChecked = !isChecked;
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isChecked,
                    activeColor: orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onChanged: (value) {
                      setState(() {
                        isChecked = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "Saya telah membaca dan menyetujui syarat & ketentuan yang berlaku",
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),



            const SizedBox(height: 16),

            // Tombol Tambah Permintaan
            Center(
            child: SizedBox(
              width: 300.w,
              height: 48.h,
              child: ElevatedButton(
                  onPressed: isChecked
                      ? () async {
                    bool? confirm = await showConfirmationDialog(context);

                    if (confirm == true) {
                      final api = UpgradePackageService();

                      final request = UpgradePackageRequest(
                        accessToken: widget.accessToken,
                        custNumber: widget.custNumber,
                        custName: custName ?? "",
                        custPhone: custPhone ?? "",
                        custEmail: custEmail ?? "",
                        custProvince: custProvince ?? "",
                        custDistrict: custDistrict ?? "",
                        custSubDistrict: custSubDistrict ?? "",
                        custVillage: custVillage ?? "",
                        custAddress: custAddress ?? "",
                        custSpCodeIdExists: widget.currentPackage?.spCodeId ?? "",
                        custSpCodeIdNew: widget.newPackageId,
                        accManager: accManager
                      );

                      final result = await api.upgradePackage(
                        accessToken: widget.accessToken,
                        request: request,
                      );

                      print("=== RESPONSE RESULT ===");
                      print(result.toJson());

                      if (result.success == 1) {
                        showSuccessDialogLoggedIn(
                          context,
                          custNumber: widget.custNumber,
                          accessToken: widget.accessToken,
                          custGroupId: widget.custGroupId,
                        );
                      }
                    }
                  }
                      : null,
                  style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (states) {
                      if (!isChecked) return Colors.grey.shade400;
                      return Colors.transparent;
                    },
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  elevation: WidgetStateProperty.all(4),
                ),
                child: Ink(
                  decoration: isChecked
                      ? const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [darkorange, orange],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  )
                      : null,
                  child: Center(
                    child: Text(
                      "Tambah Permintaan",
                      style: GoogleFonts.inter(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            )
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
