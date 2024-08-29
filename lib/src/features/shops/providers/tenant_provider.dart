import 'package:flutter/foundation.dart';
import '../models/tenant.dart';
import '../services/tenant_service.dart';

class TenantProvider extends ChangeNotifier {
  final TenantService _tenantService = TenantService();
  List<Tenant> _tenants = [];
  bool _isLoading = false;

  List<Tenant> get tenants => _tenants;
  bool get isLoading => _isLoading;

  Future<void> loadTenants() async {
    _isLoading = true;
    notifyListeners();
    _tenants = await _tenantService.fetchTenants();
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

  Future<void> addPayment(String tenantId, Payment payment) async {
    await _tenantService.addPayment(tenantId, payment);
    await loadTenants();
  }
}
