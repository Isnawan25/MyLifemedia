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
import 'package:mylm/data/cubit/current_cust_loaded/current_cust_state.dart';


class MainHelpdeskScreen extends StatefulWidget {
  final String custNumber;
  final String accessToken;
  final String custGroupId;

  const MainHelpdeskScreen({
    super.key,
    required this.custNumber,
    required this.accessToken,
    required this.custGroupId,
  });

  @override
  State<MainHelpdeskScreen> createState() => _MainHelpdeskScreenState();
}

class _MainHelpdeskScreenState extends State<MainHelpdeskScreen> {
  int _currentIndex = 4;

  late String _custNumber;
  late String _custGroupId;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _custNumber = widget.custNumber;
    _custGroupId = widget.custGroupId;

    _buildScreens();
  }

  void _buildScreens() {
    _screens = [
      ProfileScreen(
        custNumber: _custNumber,
        accessToken: widget.accessToken,
        custGroupId: _custGroupId,
      ),
      RiwayatTagihanScreen(
        custNumber: _custNumber,
        accessToken: widget.accessToken,
        custGroupId: _custGroupId,
      ),
      HomeScreen(
        custNumber: _custNumber,
        accessToken: widget.accessToken,
        custGroupId: _custGroupId,
      ),
      FaqScreen(
        custNumber: _custNumber,
        accessToken: widget.accessToken,
        custGroupId: _custGroupId,
      ),
      HelpdeskScreen(
        custNumber: _custNumber,
        accessToken: widget.accessToken,
        custGroupId: _custGroupId,
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
          create: (_) => CurrentCustCubit()
            ..load(
              defaultCustNumber: _custNumber,
              defaultCustGroupId: _custGroupId,
            ),
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
      child: BlocListener<CurrentCustCubit, CurrentCustState>(
        listener: (context, state) {
          if (state is CurrentCustLoaded) {

            setState(() {
              _custNumber = state.custNumber;
              _custGroupId = state.custGroupId;
              _buildScreens(); // rebuild SEMUA tab
            });
          }
        },
        child: Scaffold(
          body: _screens[_currentIndex],
          bottomNavigationBar: BottomNav(
            currentIndex: _currentIndex,
            onTap: _onTap,
          ),
        ),
      ),
    );
  }
}



