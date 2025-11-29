import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/providers.dart';
import '../widgets/result_card.dart';

/// Fluids tab showing IV maintenance fluid calculations
/// 
/// Displays:
/// - Maintenance rate using Holliday-Segar (4-2-1) rule
/// - Hourly rate in mL/hr
class FluidsTab extends ConsumerWidget {
  const FluidsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculationProvider);

    if (state.weightKg == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.water_drop,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Enter patient weight to see fluid calculations',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final fluids = state.fluidResults!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header
        Text(
          'IV Fluid Management',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          'Maintenance fluid calculations',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 16),

        // Maintenance Rate
        ResultCard.fluid(
          title: 'Maintenance Rate',
          value: fluids.maintenanceRateMlPerHr.toStringAsFixed(1),
          unit: 'mL/hr',
          subtitle: 'Holliday-Segar (4-2-1 Rule)',
        ),

        const SizedBox(height: 16),

        // Explanation Card
        Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Holliday-Segar Method',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                      ),
                ),
                const SizedBox(height: 12),
                _buildFormulaRow(
                  context,
                  'First 10 kg:',
                  '4 mL/kg/hr',
                  state.weightKg! <= 10,
                ),
                _buildFormulaRow(
                  context,
                  'Next 10 kg:',
                  '2 mL/kg/hr',
                  state.weightKg! > 10 && state.weightKg! <= 20,
                ),
                _buildFormulaRow(
                  context,
                  'Each kg > 20:',
                  '1 mL/kg/hr',
                  state.weightKg! > 20,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Quick Reference: 24-hour total
        Card(
          color: Theme.of(context).colorScheme.tertiaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '24-Hour Total',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(fluids.maintenanceRateMlPerHr * 24).toStringAsFixed(0)} mL/day',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onTertiaryContainer,
                      ),
                ),
              ],
            ),
          ),
        ),

        // Important Notes
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Clinical Notes',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '• This is a maintenance rate for stable patients\n'
                '• Adjust for ongoing losses, fever, or disease state\n'
                '• Maximum rate typically capped at 100-120 mL/hr\n'
                '• Use isotonic fluids (NS or LR) in most cases',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormulaRow(
    BuildContext context,
    String label,
    String value,
    bool isApplicable,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontWeight: isApplicable ? FontWeight.bold : FontWeight.normal,
                ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isApplicable
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isApplicable
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.onSecondaryContainer,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
