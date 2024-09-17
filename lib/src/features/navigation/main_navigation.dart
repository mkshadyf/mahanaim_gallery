import 'package:flutter/material.dart';
import 'package:mahanaim_gallery/src/features/dashboard/maindashboard.dart';
import 'package:mahanaim_gallery/src/features/shops/views/shop_list_view.dart';
import 'package:mahanaim_gallery/src/features/shops/views/tenant_list_view.dart';
import 'package:mahanaim_gallery/src/settings/settings_view.dart';
import '../../settings/settings_controller.dart';

class MainNavigation extends StatefulWidget {
  final SettingsController settingsController;

  const MainNavigation({super.key, required this.settingsController});

  @override
  State<MainNavigation> createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const MainDashboard(),
      const ShopListView(),
      const TenantListView(),
      SettingsView(controller: widget.settingsController),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahanaim Gallery'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Shops',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Tenants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}