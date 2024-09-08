import 'package:flutter/material.dart';
import '../dashboard/maindashboard.dart';
import '../shops/views/add_rent_payment_view.dart';
import '../shops/views/shop_list_view.dart';
import '../shops/views/tenant_list_view.dart';
import '../../settings/settings_view.dart';
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
      const AddRentPaymentView(), // Add the new view
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
            icon: Icon(Icons.payment),
            label: 'Add Rent Payment',
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
        unselectedItemColor: Colors.grey,
        backgroundColor:  const Color.fromARGB(255, 49, 46, 46),
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}