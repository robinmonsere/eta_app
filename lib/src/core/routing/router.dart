import 'package:eta_app/src/features/dashboard_screen.dart';
import 'package:eta_app/src/features/logs/log_screen.dart';
import 'package:eta_app/src/features/overview/overview_screen.dart';
import 'package:eta_app/src/features/statistics_screen/statistics_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter router = GoRouter(
  initialLocation: OverviewScreen.route,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return DashboardScreen(child: child);
      },
      routes: [
        GoRoute(
          path: OverviewScreen.route,
          pageBuilder: (BuildContext context, GoRouterState state) =>
              const NoTransitionPage(
            child: OverviewScreen(),
          ),
        ),
        GoRoute(
          path: StatisticsScreen.route,
          pageBuilder: (BuildContext context, GoRouterState state) =>
              const NoTransitionPage(
            child: StatisticsScreen(),
          ),
        ),
        GoRoute(
          path: LogScreen.route,
          pageBuilder: (BuildContext context, GoRouterState state) =>
              const NoTransitionPage(
            child: LogScreen(),
          ),
        )
      ],
    )
  ],
);
