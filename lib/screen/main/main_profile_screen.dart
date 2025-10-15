import 'package:flutter/material.dart';
import 'package:mylm/base/widgets/bottom_nav.dart';
import 'package:mylm/screen/faq/faq_screen.dart';
import 'package:mylm/screen/helpdesk/helpdesk_screen.dart';
import 'package:mylm/screen/home/home_screen.dart';
import 'package:mylm/screen/riwayat_tagihan/riwayat_tagihan_screen.dart';
import 'package:mylm/screen/user_profil/profile_screen.dart';


class MainProfileScreen extends StatefulWidget {
  const MainProfileScreen({super.key});

  @override
  State<MainProfileScreen> createState() => _MainProfileScreenState();
}

class _MainProfileScreenState extends State<MainProfileScreen> {
  int _currentIndex = 0; // default ke Profil

  final List<Widget> _screens = const [

    ProfileScreen(),
    RiwayatTagihanScreen(),
    HomeScreen(),
    FaqScreen(),
    HelpdeskScreen(),
  ];

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
