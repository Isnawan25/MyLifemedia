import 'package:flutter/material.dart';
import 'package:mylm/base/widgets/skeleton_shimmer/skeleton_loading.dart';

class SkeletonText extends StatelessWidget {
  final double width;
  final double height;

  const SkeletonText({
    super.key,
    required this.width,
    this.height = 14,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoading(
      width: width,
      height: height,
      radius: 4,
    );
  }
}
