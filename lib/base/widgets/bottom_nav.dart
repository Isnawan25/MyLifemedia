import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mylm/base/lifemedia_colors.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, "assets/svgs/icons_user.svg", 0),
          _buildNavItem(context, "assets/svgs/icons_invoice2.svg", 1),
          _buildNavItem(context, "assets/svgs/icons_home.svg", 2),
          _buildNavItem(context, "assets/svgs/icons_talk.svg", 3),
          _buildNavItem(context, "assets/svgs/icons_customers_support.svg", 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String assetPath, int index) {
    final isSelected = currentIndex == index;

    final double iconSize = (index == 4) ? 36.r : 28.r;

    return GestureDetector(
      onTap: () {
        Feedback.forTap(context);
        onTap(index);
      },
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [darkorange, orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: Opacity(
          opacity: isSelected ? 1.0 : 0.4,
          child: SvgPicture.asset(
            assetPath,
            width: iconSize,
            height: iconSize,
            colorFilter: const
            ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn)
          ),
        ),
      ),
    );

  }

}
