import 'package:flutter/material.dart';
import 'package:mylm/base/widgets/skeleton_shimmer/skeleton_loading.dart';

class SkeletonIconCircle extends StatelessWidget {
  final double size;

  const SkeletonIconCircle({
    super.key,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoading(
      width: size,
      height: size,
      radius: size / 2,
    );
  }
}
