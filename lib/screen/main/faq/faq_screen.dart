import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mylm/base/widgets/skeleton_shimmer/skeleton_loading.dart';
import 'package:mylm/data/models/support/faq_response.dart';
import 'package:mylm/data/network/services/get/get_faq.dart';
import 'package:mylm/screen/main/faq/detailfaq_screen.dart';
import 'package:mylm/screen/main/main_screen.dart';

class FaqScreen extends StatefulWidget {
  final String custNumber;
  final String accessToken;
  final String custGroupId;

  const FaqScreen({
    super.key,
    required this.custNumber,
    required this.accessToken,
    required this.custGroupId,
  });

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Faq> allFaqs = [];
  List<Faq> filteredFaqs = [];

  void _onSearchChanged(String query) {
    setState(() {
      filteredFaqs = allFaqs.where((faq) {
        return faq.titleFaq
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            colorFilter: const ColorFilter.mode(
              Colors.black,
              BlendMode.srcIn,
            ),
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
          "Bantuan",
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            // SEARCH
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: "Cari Bantuan",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 14.h,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // LIST FAQ
            Expanded(
              child: FutureBuilder<List<Faq>>(
                future: FaqService().getFaqs(widget.accessToken),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.separated(
                      itemCount: 10,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (_, __) => SkeletonLoading(
                        width: double.infinity,
                        height: 50.h,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(child: Text("Gagal memuat FAQ"));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("FAQ tidak tersedia"));
                  }

                  if (allFaqs.isEmpty) {
                    allFaqs = snapshot.data!;
                    filteredFaqs = allFaqs;
                  }

                  return ListView.separated(
                    itemCount: filteredFaqs.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final item = filteredFaqs[index];

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(
                            item.titleFaq,
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailFaqScreen(
                                  faq: item,
                                  custNumber: widget.custNumber,
                                  accessToken: widget.accessToken,
                                  custGroupId: widget.custGroupId,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

