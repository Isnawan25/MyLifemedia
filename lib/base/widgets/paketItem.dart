import 'package:flutter/material.dart';
import 'package:mylm/base/currency_formatter.dart';
import 'package:mylm/base/lifemedia_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylm/data/models/product/packages_response.dart';


class PaketItem extends StatelessWidget {
  final PackageData data;
  final String? selectedId;
  final VoidCallback onTap;

  const PaketItem({
    super.key,
    required this.data,
    required this.selectedId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [darkorange, orange],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.wifi, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.spName,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Kecepatan Internet s/d ${data.spName.replaceAll(RegExp(r'[^0-9]'), '')} Mbps",
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    "${formatRupiah(data.spPrice)}/bulan",
                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            Radio<String>(
              value: data.spCodeId,
              groupValue: selectedId,
              activeColor: darkorange,
              onChanged: (_) => onTap(),
            )
          ],
        ),
      ),
    );
  }
}
