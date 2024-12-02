import 'package:eta_app/src/core/routing/router.dart';
import 'package:eta_app/src/features/logs/log_screen.dart';
import 'package:eta_app/src/features/overview/overview_screen.dart';
import 'package:eta_app/src/features/statistics_screen/statistics_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Theme.of(context).colorScheme.onSurface,
      unselectedItemColor: Theme.of(context).colorScheme.onSurface,
      onTap: (int index) {
        switch (index) {
          case 0:
            context.go(OverviewScreen.route);
            break;
          case 1:
            context.go(StatisticsScreen.route);
            break;
          case 2:
            context.go(LogScreen.route);
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: 'stats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'logs',
        ),
      ],
    );
  }
}
