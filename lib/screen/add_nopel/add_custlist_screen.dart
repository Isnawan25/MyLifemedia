import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:mylm/base/widgets/skeleton_shimmer/skeleton_loading.dart';
import 'package:mylm/data/network/services/get/get_cust_list.dart';
import 'package:mylm/data/network/services/post/post_auth_otp.dart';
import 'package:mylm/screen/add_nopel/addcust_bottomsheet.dart';
import 'package:mylm/data/preferences/secure_storage.dart';

class AddCustlistScreen extends StatefulWidget {
  final String custNumber;
  final String accessToken;
  final String custGroupId;

  AddCustlistScreen({
    super.key,
    required this.custNumber,
    required this.custGroupId,
    required this.accessToken,
  });

  @override
  _AddCustListScreenState createState() => _AddCustListScreenState();
}

class _AddCustListScreenState extends State<AddCustlistScreen> {
  List<String> customerList = [];
  bool isLoading = true;
  bool isSilentLogin = false;

  @override
  void initState() {
    super.initState();
    fetchCustomerList();
  }

  Future<void> fetchCustomerList() async {
    setState(() => isLoading = true);

    final resp = await CustListService().getCustomerList(
      accessToken: widget.accessToken,
      groupId: widget.custGroupId,
    );

    if (resp != null && resp.data !="") {
      setState(() {
        customerList = resp.data.map((e) => e.nopel).toList();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  //Silent Login
  Future<void> performSilentLogin(String newCustNumber) async {
    setState(() => isSilentLogin = true);

    final resp = await AuthOtpService().login(newCustNumber);

    if (resp != null && resp.success && resp.data != null) {
      final d = resp.data!;

      // Simpan Seluruh Data ke SecureStorage
      await SecureStorage.saveAccessToken(d.accessToken);
      await SecureStorage.saveCustNumber(d.custNumber);
      await SecureStorage.saveCustGroupId(d.custGroupId);
      await SecureStorage.saveCustName(d.custName);
      await SecureStorage.saveCustPhone(d.custPhone);
      await SecureStorage.saveCustEmail(d.custEmail);
      await SecureStorage.saveCustAddress(d.custAddress);

      if (d.custProvince != null) await SecureStorage.saveCustProvince(d.custProvince!);
      if (d.custDistrict != null) await SecureStorage.saveCustDistrict(d.custDistrict!);
      if (d.custSubDistrict != null) await SecureStorage.saveCustSubDistrict(d.custSubDistrict!);
      if (d.custVillage != null) await SecureStorage.saveCustVillage(d.custVillage!);

      setState(() => isSilentLogin = false);

      // Kembalikan data ke page sebelumnya
      Navigator.pop(context, {
        'custNumber': d.custNumber,
        'custGroupId': d.custGroupId,
        'accessToken': d.accessToken,
      });

    } else {
      setState(() => isSilentLogin = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal login. Coba lagi.")),
      );
    }
  }

  //pilih id silent login
  void onSelectCustomer(String selectedId) {
    if (selectedId != widget.custNumber) {
      performSilentLogin(selectedId);
    }
  }

  // add new customer
  Future<void> _addNewCustomer() async {
    final result = await showAddCustomerBottomSheet(context);

    if (result != null && result['nopel'] != null) {
      await fetchCustomerList();
      onSelectCustomer(result['nopel']??"");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "ID Pelanggan Kamu",
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isLoading
                    ? Column(
                  children: List.generate(
                    3,
                        (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SkeletonLoading(height: 60.h, width: double.infinity),
                    ),
                  ),
                )
                    : Column(
                  children: [
                    // ID utama
                    InkWell(
                      onTap: () => onSelectCustomer(widget.custNumber),
                      child: _buildCustomerCard(
                        widget.custNumber,
                        isSelected: true,
                      ),
                    ),
                    const SizedBox(height: 12),

                    ...customerList
                        .where((id) => id != widget.custNumber)
                        .map(
                          (id) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => onSelectCustomer(id),
                          child: _buildCustomerCard(id),
                        ),
                      ),
                    )
                        .toList(),
                  ],
                ),
                const SizedBox(height: 28),
                Text(
                  "Tambah ID Pelanggan Lainnya",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                const SizedBox(height: 12),

                // CARD TAMBAH ID
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/mylm_logo.png",
                        width: 120,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: _addNewCustomer,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Masukkan ID Pelanggan",
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Transform.flip(
                                flipX: true,
                                child: SvgPicture.asset(
                                  "assets/svgs/arrow_back.svg",
                                  width: 16.w,
                                  height: 16.h,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.black,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),

        // loading overlay
        if (isSilentLogin)
          Container(
            color: Colors.black.withValues(alpha: 0.4),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
          ),
      ],
    );
  }

  Widget _buildCustomerCard(String custId, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? orange : Colors.grey.shade300,
          width: 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [darkorange, orange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                "assets/svgs/icons_user.svg",
                width: 20.w,
                height: 20.h,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            custId,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
