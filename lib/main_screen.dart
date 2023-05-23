import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/colors/colors.dart';
import 'features/my _book/presentation/collection.dart';
import 'features/my_book_shelf/presentation/my_book_shelf.dart';
import 'features/profile/presentation/profile_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final navigationList = const [
    MyBookScreen(),
    BookShelfScreen(),
    ProfileScreen()
  ];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final check = ModalRoute.of(context)!.settings.arguments;
      if (check != null && check is bool) {
        setState(() {
          currentIndex = 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: navigationList[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          selectedItemColor: S.colors.primary_3,
          unselectedItemColor: S.colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.book),
              label: 'Collection',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.linesLeaning),
              label: 'Share',
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
