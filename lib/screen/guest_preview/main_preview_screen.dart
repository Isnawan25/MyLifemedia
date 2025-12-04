import 'package:flutter/material.dart';
import 'package:mylm/base/widgets/bottom_nav.dart';
import 'package:mylm/screen/main/faq/faq_screen.dart';
import 'package:mylm/screen/main/helpdesk/helpdesk_screen.dart';
import 'package:mylm/screen/main/home/home_screen.dart';
import 'package:mylm/screen/main/manage_bills/riwayat_tagihan/riwayat_tagihan_screen.dart';
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
        custGroupId: widget.custGroupId,),
      HelpdeskScreen(
        custNumber: widget.custNumber,
        accessToken: widget.accessToken,
        custGroupId: widget.custGroupId,),
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

