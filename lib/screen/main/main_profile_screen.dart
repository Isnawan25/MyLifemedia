import 'package:flutter/material.dart';
import 'package:mylm/base/widgets/bottom_nav.dart';
import 'package:mylm/screen/faq/faq_screen.dart';
import 'package:mylm/screen/helpdesk/helpdesk_screen.dart';
import 'package:mylm/screen/home/home_screen.dart';
import 'package:mylm/screen/riwayat_tagihan/riwayat_tagihan_screen.dart';
import 'package:mylm/screen/user_profil/profile_screen.dart';

class MainProfileScreen extends StatefulWidget {
  final String custNumber;
  final String accessToken;
  final String custGroupId;

  const MainProfileScreen({
    super.key,
    required this.accessToken,
    required this.custNumber,
    required this.custGroupId,
  });

  @override
  State<MainProfileScreen> createState() => _MainProfileScreenState();
}

class _MainProfileScreenState extends State<MainProfileScreen> {
  int _currentIndex = 0; // default ke Profil
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    // ⚙️ Inisialisasi di sini agar bisa akses widget.custNumber & widget.accessToken
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
