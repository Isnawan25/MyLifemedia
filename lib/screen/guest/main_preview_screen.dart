import 'package:flutter/material.dart';
import 'package:mylm/base/widgets/bottom_nav.dart';
import 'package:mylm/screen/guest/welcome_screen.dart';
import 'package:mylm/screen/guest/home_preview_screen.dart';
import 'package:mylm/screen/guest/helpdesk_preview_screen.dart';
import 'package:mylm/data/cubit/main_preview/main_preview_state.dart';
import 'package:mylm/data/cubit/main_preview/main_preview_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class MainPreviewScreen extends StatelessWidget {
  const MainPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = [
      const WelcomeScreen(),
      const WelcomeScreen(),
      const HomePreviewScreen(),
      const WelcomeScreen(),
      const HelpdeskPreviewScreen(),
    ];

    return BlocProvider(
      create: (_) => MainPreviewCubit(),
      child: BlocBuilder<MainPreviewCubit, MainPreviewState>(
        builder: (context, state) {
          return Scaffold(
            body: screens[state.index],
            bottomNavigationBar: BottomNav(
              currentIndex: state.index,
              onTap: (i) =>
                  context.read<MainPreviewCubit>().changeTab(i),
            ),
          );
        },
      ),
    );
  }
}
