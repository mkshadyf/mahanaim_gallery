import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../shops/providers/shop_provider.dart';
import '../shops/providers/tenant_provider.dart';

class AnalyticsWidget extends StatelessWidget {
  const AnalyticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);
    final tenantProvider = Provider.of<TenantProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.analytics, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAnalyticItem(context, localizations.totalShops, shopProvider.shops.length.toString()),
                _buildAnalyticItem(context, localizations.totalTenants, tenantProvider.tenants.length.toString()),
                _buildAnalyticItem(context, localizations.totalRevenue, '\$${shopProvider.totalRevenue.toStringAsFixed(2)}'),
              ],
            ),
            // In AnalyticsWidget class
ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, '/detailed_insights');
  },
  child: Text(localizations.viewDetailedInsights),
),

          ],
        ),
      ),
      
    );
    
  }

  Widget _buildAnalyticItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
      
      ],

    );
    
  }
}

// import 'package:flutter/material.dart';
// import 'package:mahanaim_gallery/src/features/shops/providers/tenant_provider.dart';
// import 'package:provider/provider.dart';
// import '../shops/providers/shop_provider.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class AnalyticsWidget extends StatelessWidget {
//   const AnalyticsWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final shopProvider = Provider.of<ShopProvider>(context);
//     final tenantProvider = Provider.of<TenantProvider>(context);
//     final localizations = AppLocalizations.of(context)!;

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Card(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   localizations.analyticsTitle,
//                   style: Theme.of(context).textTheme.headlineSmall,
//                 ),
//                 const SizedBox(height: 16),
//                 Wrap(
//                   spacing: 16,
//                   runSpacing: 16,
//                   children: [
//                     _buildAnalyticItem(
//                       context,
//                       localizations.totalShops,
//                       shopProvider.shops.length.toString(),
//                       constraints.maxWidth,
//                       onTap: () => Navigator.pushNamed(context, '/shops_list'),
//                     ),
//                     _buildAnalyticItem(
//                       context,
//                       localizations.totalTenants,
//                       tenantProvider.tenants.length.toString(),
//                       constraints.maxWidth,
//                       onTap: () => Navigator.pushNamed(context, '/tenants_list'),
//                     ),
//                     _buildAnalyticItem(
//                       context,
//                       localizations.totalRevenue,
//                       '\$${shopProvider.totalRevenue.toStringAsFixed(2)}',
//                       constraints.maxWidth,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildAnalyticItem(BuildContext context, String label, String value, double maxWidth, {VoidCallback? onTap}) {
//     final cardWidth = maxWidth < 600 ? maxWidth : maxWidth / 3 - 16;
    
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 2,
//         child: Container(
//           width: cardWidth,
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: Theme.of(context).textTheme.bodySmall,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 value,
//                 style: Theme.of(context).textTheme.headlineMedium,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }