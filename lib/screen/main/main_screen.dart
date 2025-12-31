import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mylm/base/widgets/bottom_nav.dart';
import 'package:mylm/data/cubit/current_cust_loaded/current_cust_cubit.dart';
import 'package:mylm/data/cubit/exists_package/exists_package_cubit.dart';
import 'package:mylm/data/cubit/notification/notification_read_cubit.dart';
import 'package:mylm/data/cubit/profile/profile_cubit.dart';
import 'package:mylm/data/cubit/promotions/promotions_cubit.dart';
import 'package:mylm/data/network/services/get/get_exists_package.dart';
import 'package:mylm/data/network/services/get/get_profile.dart';
import 'package:mylm/data/network/services/get/get_promotions.dart';
import 'package:mylm/screen/main/faq/faq_screen.dart';
import 'package:mylm/screen/main/helpdesk/helpdesk_screen.dart';
import 'package:mylm/screen/main/home/home_screen.dart';
import 'package:mylm/screen/main/riwayat_tagihan/riwayat_tagihan_screen.dart';
import 'package:mylm/screen/main/user_profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final String custNumber;
  final String accessToken;
  final String custGroupId;

  const MainScreen({
    super.key,
    required this.custNumber,
    required this.accessToken,
    required this.custGroupId,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2; // default home
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
      HomeScreen(
        custNumber: widget.custNumber,
        accessToken: widget.accessToken,
        custGroupId: widget.custGroupId,
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
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CurrentCustCubit(),
        ),

        BlocProvider(
          create: (_) => ProfileCubit(ProfileService()),
        ),

        BlocProvider(
          create: (_) => ExistsPackageCubit(ExistsPackageService()),
        ),

        BlocProvider(
          create: (_) => NotificationReadCubit(),
        ),

        BlocProvider(
          create: (_) => PromotionsCubit(PromotionService())
            ..fetchPromotions(),
        ),
      ],
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNav(
          currentIndex: _currentIndex,
          onTap: _onTap,
        ),
      ),
    );
  }

}


