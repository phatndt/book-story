import 'package:book_exchange/presentation/di/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/colors/colors.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(mainAppNotifierProvider).context = context;
    return SafeArea(
      child: Scaffold(
        body: ref.watch(mainAppNotifierProvider).navigation,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: ref.watch(mainAppNotifierProvider).currentIndex,
          onTap: (index) {
            ref.watch(mainAppNotifierProvider.notifier).setCurrentIndext(index);
          },
          selectedItemColor: S.colors.orange,
          unselectedItemColor: S.colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.book),
              label: 'Collection',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.binoculars),
              label: 'Share',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.peopleGroup),
              label: 'Clubs',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.ellipsis),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
