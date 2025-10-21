import 'package:flutter/material.dart';
import 'package:mylm/base/widgets/bottom_nav.dart';
import 'package:mylm/screen/faq/faq_screen.dart';
import 'package:mylm/screen/helpdesk/helpdesk_screen.dart';
import 'package:mylm/screen/home/home_screen.dart';
import 'package:mylm/screen/riwayat_tagihan/riwayat_tagihan_screen.dart';
import 'package:mylm/screen/user_profil/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final String custNumber;
  final String accessToken;


  const MainScreen({
    super.key,
    required this.custNumber,
    required this.accessToken,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 2; // default ke home
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      ProfileScreen(
        custNumber: widget.custNumber,
        accessToken: widget.accessToken,
      ),
      RiwayatTagihanScreen(
        custNumber: widget.custNumber,
        accessToken: widget.accessToken,
      ),
      HomeScreen(
        custNumber: widget.custNumber,
        accessToken: widget.accessToken,
      ),
      FaqScreen(
        custNumber: widget.custNumber,
        accessToken: widget.accessToken,),
      HelpdeskScreen(
        custNumber: widget.custNumber,
        accessToken: widget.accessToken,),
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

