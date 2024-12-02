import 'package:eta_app/src/core/models/post.dart';
import 'package:eta_app/src/features/dashboard_screen.dart';
import 'package:eta_app/src/features/details/details_screen.dart';
import 'package:eta_app/src/features/logs/log_detail_screen.dart';
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
          routes: [
            GoRoute(
              path: LogDetailScreen.location,
              pageBuilder: (BuildContext context, GoRouterState state) {
                final logFileName = state.extra as String;
                return NoTransitionPage(
                  child: LogDetailScreen(
                    logFileName: logFileName,
                  ),
                );
              },
            )
          ],
        ),
        GoRoute(
          path: DetailsScreen.route,
          pageBuilder: (BuildContext context, GoRouterState state) {
            final post = state.extra as Post;
            return NoTransitionPage(
              child: DetailsScreen(
                post: post,
              ),
            );
          },
        )
      ],
    )
  ],
);
