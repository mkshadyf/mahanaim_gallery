import '../models/tenant.dart';
import '../repositories/tenant_repository.dart';

class TenantService {
  final TenantRepository _tenantRepository = TenantRepository();

  Future<List<Tenant>> fetchTenants() async {
    return await _tenantRepository.fetchTenants();
  }

  Future<void> addTenant(Tenant tenant) async {
    await _tenantRepository.addTenant(tenant);
  }

  Future<void> updateTenant(Tenant tenant) async {
    await _tenantRepository.updateTenant(tenant);
  }

  Future<void> deleteTenant(String tenantId) async {
    await _tenantRepository.deleteTenant(tenantId);
  }

  Future<List<Tenant>> searchTenants(String query) async {
    return await _tenantRepository.searchTenants(query);
  }

  Future<Tenant?> fetchTenantById(String tenantId) async {
    return await _tenantRepository.fetchTenantById(tenantId);
  }
}
