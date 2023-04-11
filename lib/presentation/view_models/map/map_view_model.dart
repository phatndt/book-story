import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/entities/user.dart';

class MapState {
  List<User> userList;
  final PageController pageController;

  MapState({required this.userList, required this.pageController});

  MapState copy({
    List<User>? userList,
    PageController? pageController,
  }) =>
      MapState(
        userList: userList ?? this.userList,
        pageController: pageController ?? this.pageController
      );
}

class MapNotifier extends StateNotifier<MapState> {
  MapNotifier(this.ref) : super(MapState(userList: [], pageController: PageController()));
  final Ref ref;

  setUserList(List<User> userList) {
    final newState = state.copy(userList: userList);
    state = newState;
  }
}
