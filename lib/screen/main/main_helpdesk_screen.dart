import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylm/base/widgets/bottom_nav.dart';
import 'package:mylm/data/cubit/promotions/promotions_cubit.dart';
import 'package:mylm/data/network/services/get/get_promotions.dart';
import 'package:mylm/screen/main/faq/faq_screen.dart';
import 'package:mylm/screen/main/helpdesk/helpdesk_screen.dart';
import 'package:mylm/screen/main/home/home_screen.dart';
import 'package:mylm/screen/main/riwayat_tagihan/riwayat_tagihan_screen.dart';
import 'package:mylm/screen/main/user_profile/profile_screen.dart';

class MainHelpdeskScreen extends StatefulWidget {
  final String custNumber;
  final String accessToken;
  final String custGroupId;

  const MainHelpdeskScreen({
    super.key,
    required this.accessToken,
    required this.custNumber,
    required this.custGroupId,
  });

  @override
  State<MainHelpdeskScreen> createState() => _MainHelpdeskScreenState();
}

class _MainHelpdeskScreenState extends State<MainHelpdeskScreen> {
  int _currentIndex = 4;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      ProfileScreen(
        custNumber: widget.custNumber,
        accessToken: widget.accessToken,
        custGroupId: widget.custGroupId,
      ),
      RiwayatTagihanScreen(
        custNumber: widget.custNumber,
        accessToken: widget.accessToken,
        custGroupId: widget.custGroupId,
      ),
      BlocProvider(
        create: (_) => PromotionsCubit(PromotionService())
          ..fetchPromotions(),
        child: HomeScreen(
          custNumber: widget.custNumber,
          accessToken: widget.accessToken,
          custGroupId: widget.custGroupId,
        ),
      ),
      FaqScreen(
        custNumber: widget.custNumber,
        accessToken: widget.accessToken,
        custGroupId: widget.custGroupId,
      ),
      HelpdeskScreen(
        custNumber: widget.custNumber,
        accessToken: widget.accessToken,
        custGroupId: widget.custGroupId,
      ),
    ];
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
