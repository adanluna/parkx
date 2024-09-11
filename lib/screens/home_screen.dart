import 'package:flutter/material.dart';
import 'package:parkx/screens/help/help_screen.dart';
import 'package:parkx/screens/profile/profile.dart';
import 'package:parkx/screens/scanner_screen.dart';
import 'package:parkx/screens/wallet/wallet.dart';
import 'package:parkx/utils/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedTab = 0;

  final List _pages = [
    const ScannerScreen(),
    const WalletScreen(),
    const ScannerScreen(),
    const ProfileScreen(),
    const HelpScreen(),
  ];

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedTab],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: GestureDetector(
              onTap: () => _changeTab(2),
              child: const SizedBox(width: 63, height: 79, child: Image(image: AssetImage('assets/images/menu_scanner.png'))))),
      bottomNavigationBar: Container(
          height: 90,
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black12, width: 1)),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedTab,
            onTap: (index) => _changeTab(index),
            selectedItemColor: AppTheme.disabledTextSecondary,
            unselectedItemColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(fontFamily: 'Signika SC', fontSize: 14, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontFamily: 'Signika SC', fontSize: 14, fontWeight: FontWeight.w600),
            items: [
              menuItem('Pagar', 'icon-menu-home.png'),
              menuItem('Billetera', 'icon-menu-billetera.png'),
              menuItem('', ''),
              menuItem('Perfil', 'icon-menu-perfil.png'),
              menuItem('Ayuda', 'icon-menu-ayuda.png'),
            ],
          )),
    );
  }

  BottomNavigationBarItem menuItem(title, image) {
    return BottomNavigationBarItem(
      icon: (image != '') ? SizedBox(width: 20, child: Image(image: AssetImage('assets/images/$image'))) : Container(),
      label: title,
    );
  }
}
