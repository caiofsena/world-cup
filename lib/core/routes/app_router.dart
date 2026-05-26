import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/groups_screen.dart';
import '../../presentation/screens/group_detail_screen.dart';
import '../../presentation/screens/matches_screen.dart';
import '../../presentation/screens/match_detail_screen.dart';
import '../../presentation/screens/predictions_screen.dart';
import '../../presentation/screens/profile_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          HomeScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const GroupsScreen(),
              routes: [
                GoRoute(
                  path: 'group/:groupLetter',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => GroupDetailScreen(
                    groupLetter: state.pathParameters['groupLetter']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/matches',
              builder: (context, state) => const MatchesScreen(),
              routes: [
                GoRoute(
                  path: ':matchId',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => MatchDetailScreen(
                    matchId: int.parse(state.pathParameters['matchId']!),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/predictions',
              builder: (context, state) => const PredictionsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
