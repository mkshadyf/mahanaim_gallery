import 'package:flutter/material.dart';
import 'package:mahanaim_gallery/src/features/dashboard/maindashboard.dart';
import 'package:mahanaim_gallery/src/features/shops/views/shop_list_view.dart';
import 'package:mahanaim_gallery/src/features/shops/views/tenant_list_view.dart';
import 'package:mahanaim_gallery/src/settings/settings_view.dart';
import 'package:mahanaim_gallery/src/features/shops/views/rent_payments_list_view.dart';
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
      const RentPaymentsView(),
    ];
  }

  void _onItemTapped(int index) {
    if (index == 4) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              SettingsView(controller: widget.settingsController),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahanaim Gallery'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Shops',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Locataires',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payments loyers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Parametres',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: isDarkMode ? Colors.white60 : Colors.black54,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}
