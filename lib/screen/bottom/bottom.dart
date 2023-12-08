import 'package:flutter/material.dart';
import '../../themepage/theme.dart';
import 'home.dart';
import 'profile.dart';
import 'search.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});
  @override
  State<BottomNavigation> createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation> {
  int selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    Search(),
    Profile(),
  ];
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(label: "홈", icon: Icon(Icons.home)),
            BottomNavigationBarItem(
              label: "검색",
              icon: ImageIcon(
                AssetImage('assets/images/search.png'),
              ),
            ),
            BottomNavigationBarItem(
              label: "프로필",
              icon: ImageIcon(
                AssetImage('assets/images/man.png'),
              ),
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: const Color.fromRGBO(128, 128, 128, 1),
          backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
          onTap: onItemTapped,
          selectedLabelStyle: pinkw500.copyWith(
              fontSize: 12, letterSpacing: -0.24), // 선택된 아이템의 텍스트 크기 설정
          unselectedLabelStyle:
              greyw500.copyWith(fontSize: 12, letterSpacing: -0.24),
        ),
      ),
    );
  }
}
