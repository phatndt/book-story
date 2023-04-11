import 'package:book_exchange/core/route_paths.dart';
import 'package:book_exchange/presentation/views/screens/home/library/share.dart';
import 'package:book_exchange/presentation/views/screens/post/main_post_screen.dart';
import 'package:book_exchange/presentation/views/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/user.dart';
import '../views/screens/home/library/collection.dart';

class MainApp {
  String route;
  int currentIndex;
  Widget navigation;
  User user;
  BuildContext? context;
  MainApp({
    required this.route,
    required this.currentIndex,
    required this.navigation,
    required this.user,
    this.context,
  });

  MainApp copy({
    int? currentIndex,
    String? route,
    Widget? navigation,
    User? user,
    BuildContext? context,
  }) =>
      MainApp(
        route: route ?? this.route,
        currentIndex: currentIndex ?? this.currentIndex,
        navigation: navigation ?? this.navigation,
        user: user ?? this.user,
        context: context ?? this.context,
      );
}

class MainAppNotifier extends StateNotifier<MainApp> {
  MainAppNotifier(this.ref)
      : super(
          MainApp(
              route: RoutePaths.home,
              currentIndex: 0,
              navigation: const CollectionScreen(),
              user: User("", "", "", "", "", "", false, false)),
        );

  final Ref ref;
  final navigationList = const [
    CollectionScreen(),
    ShareScreen(),
    MainPostScreen(),
    ProfileScreen()
  ];

  setCurrentIndext(int index) {
    final newState = state.copy(
      navigation: navigationList[index],
      currentIndex: index,
    );
    state = newState;
  }

  setUser(User user) {
    final newState = state.copy(user: user);
    state = newState;
  }

  setBuildContext(BuildContext context) {
    final newState = state.copy(context: context);
    state = newState;
  }

  void resetState() {
    state.currentIndex = 0;
    state.navigation = const CollectionScreen();
    state.route = RoutePaths.home;
  }
}
