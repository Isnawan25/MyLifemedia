import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoading extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsets margin;
  final bool isCard; // true shimmer card (default: true)

  const SkeletonLoading({
    super.key,
    this.itemCount = 4,
    this.itemHeight = 90,
    this.margin = const EdgeInsets.only(bottom: 12),
    this.isCard = true,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: List.generate(itemCount, (index) {
          if (isCard) {
            // Shimmer card
            return Container(
              margin: margin,
              padding: const EdgeInsets.all(12),
              height: itemHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon shimmer
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Text shimmer bagian kanan
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title shimmer
                        Container(
                          height: 14,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Subtitle shimmer
                        Container(
                          height: 12,
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Harga shimmer
                        Container(
                          height: 14,
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Version Banner
            return Container(
              margin: margin,
              height: itemHeight,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }
        }),
      ),
    );
  }
}
