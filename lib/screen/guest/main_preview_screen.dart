import 'package:flutter/material.dart';
import 'package:mylm/base/widgets/bottom_nav.dart';
import 'package:mylm/screen/guest/welcome_screen.dart';
import 'package:mylm/screen/guest/home_preview_screen.dart';
import 'package:mylm/screen/guest/helpdesk_preview_screen.dart';


class MainPreviewScreen extends StatefulWidget {


  const MainPreviewScreen({
    super.key,
  });

  @override
  State<MainPreviewScreen> createState() => _MainPreviewScreenState();
}

class _MainPreviewScreenState extends State<MainPreviewScreen> {
  int _currentIndex = 2; // default home
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      WelcomeScreen(
      ),
      WelcomeScreen(
      ),
      HomePreviewScreen(
      ),
      WelcomeScreen(
      ),
      HelpdeskPreviewScreen(
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

