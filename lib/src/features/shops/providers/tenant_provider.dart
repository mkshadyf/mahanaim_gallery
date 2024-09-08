import 'package:flutter/foundation.dart';
import '../models/tenant.dart';
import '../services/shop_service.dart';
import '../services/tenant_service.dart';
import '../models/shop.dart';

class TenantProvider extends ChangeNotifier {
  final TenantService _tenantService = TenantService();
  List<Tenant> _tenants = [];
  bool _isLoading = false;
  String? _error;
  final ShopService _shopService = ShopService();

  List<Tenant> get tenants => _tenants;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTenants() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tenants = await _tenantService.fetchTenants();
    } catch (e) {
      _error = 'Failed to load tenants: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTenant(Tenant tenant) async {
    await _tenantService.addTenant(tenant);
    await loadTenants();
  }

  Future<void> updateTenant(Tenant tenant) async {
    await _tenantService.updateTenant(tenant);
    await loadTenants();
  }

  Future<void> deleteTenant(String tenantId) async {
    await _tenantService.deleteTenant(tenantId);
    await loadTenants();
  }

  Future<void> searchTenants(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _tenants = await _tenantService.searchTenants(query);
    } catch (e) {
      _error = 'Failed to search tenants: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

Future<Shop?> getShopForTenant(String tenantId) async {
  // Create a default Tenant object to use if no match is found
  final defaultTenant = Tenant(
    id: '',
    name: 'Aucun Locataire',
    email: '',
    phoneNumber: '',
    contractStartDate: DateTime.now(),
    contractEndDate: DateTime.now(),
  );

  Tenant tenant = _tenants.firstWhere(
    (t) => t.id == tenantId,
    orElse: () => defaultTenant, // Return the default Tenant if no match
  );

  if (tenant.assignedShopId != null) {
    return await _shopService.fetchShopById(tenant.assignedShopId!);
  }
  return null; // Return null if no shop is found
}


  int get upcomingLeaseExpirations {
  final now = DateTime.now();
  final threeMonthsLater = now.add(const Duration(days: 90));
  return _tenants.where((tenant) => 
    tenant.contractEndDate.isAfter(now) && 
    tenant.contractEndDate.isBefore(threeMonthsLater)
  ).length;
}
  int get overduePayments {
    final now = DateTime.now();
    return _tenants.where((tenant) =>
      tenant.lastPaymentDate?.isBefore(now) ?? false
    ).length;
  }
}