import 'package:book_exchange/presentation/views/screens/home/library/collection.dart';
import 'package:book_exchange/presentation/views/screens/home/library/share.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/colors/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final tabs = [
    const CollectionScreen(),
    const ShareScreen(),
    const Center(
      child: Text('Adu2'),
    ),
    const Center(
      child: Text('Adu3'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: S.colors.white,
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
        selectedItemColor: S.colors.orange,
        //backgroundColor: S.colors.white,
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
    );
  }
}
