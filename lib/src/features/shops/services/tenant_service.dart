import 'package:mahanaim_gallery/src/features/shops/models/tenant.dart';
import 'package:mahanaim_gallery/src/features/shops/repositories/tenant_repository.dart';

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
}
