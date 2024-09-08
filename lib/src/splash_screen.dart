import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/shops/providers/shop_provider.dart';
import 'features/shops/providers/tenant_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _loadInitialData);
  }

  Future<void> _loadInitialData() async {
    final shopProvider = Provider.of<ShopProvider>(context, listen: false);
    final tenantProvider = Provider.of<TenantProvider>(context, listen: false);

    await Future.wait([
      shopProvider.loadShops(),
      tenantProvider.loadTenants(),
    ]);

    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/app_icon.png', width: 100, height: 100),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
