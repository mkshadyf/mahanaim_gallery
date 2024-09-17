import 'package:flutter/foundation.dart';
import '../models/tenant.dart';
import '../repositories/tenant_repository.dart';

class TenantProvider extends ChangeNotifier {
  final TenantRepository _tenantRepository = TenantRepository();
  List<Tenant> _tenants = [];
  bool _isLoading = false;

  List<Tenant> get tenants => _tenants;
  bool get isLoading => _isLoading;

  Future<void> loadTenants() async {
    _isLoading = true;
    notifyListeners();
    try {
      _tenants = await _tenantRepository.fetchTenants();
    } catch (e) {
      print('Error loading tenants: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTenant(Tenant tenant) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _tenantRepository.addTenant(tenant);
      await loadTenants();
    } catch (e) {
      print('Error adding tenant: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateTenant(Tenant tenant) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _tenantRepository.updateTenant(tenant);
      await loadTenants();
    } catch (e) {
      print('Error updating tenant: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTenant(String tenantId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _tenantRepository.deleteTenant(tenantId);
      await loadTenants();
    } catch (e) {
      print('Error deleting tenant: $e');
    }
    _isLoading = false;
    notifyListeners();
  }
}