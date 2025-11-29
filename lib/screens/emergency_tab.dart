import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/providers.dart';
import '../widgets/result_card.dart';

/// Emergency tab showing crash cart calculations
/// 
/// Displays:
/// - Fluid Bolus
/// - Epinephrine dose and volume
/// - Defibrillation energy (initial and subsequent)
class EmergencyTab extends ConsumerWidget {
  const EmergencyTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculationProvider);

    if (state.weightKg == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emergency,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Enter patient weight to see emergency calculations',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final emergency = state.emergencyResults!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header
        Text(
          'Crash Cart',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.error,
              ),
        ),
        Text(
          'Emergency resuscitation calculations',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 16),

        // Fluid Bolus
        ResultCard.emergency(
          title: 'Fluid Bolus',
          value: emergency.fluidBolusMl.toStringAsFixed(0),
          unit: 'mL',
          subtitle: '20 mL/kg · Isotonic Crystalloid (NS/LR)',
          icon: Icons.water_drop,
        ),

        // Epinephrine
        ResultCard.emergency(
          title: 'Epinephrine (1:10,000)',
          value: emergency.epinephrineMg.toStringAsFixed(2),
          unit: 'mg',
          subtitle: '0.01 mg/kg · Max: 1 mg',
          icon: Icons.local_pharmacy,
        ),
        
        ResultCard.emergency(
          title: 'Epinephrine Volume',
          value: emergency.epinephrineMl.toStringAsFixed(1),
          unit: 'mL',
          subtitle: '0.1 mL/kg (1:10,000) · Max: 10 mL',
          icon: Icons.colorize,
        ),

        const Divider(height: 32),

        // Defibrillation
        Text(
          'Defibrillation',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),

        ResultCard.emergency(
          title: 'Initial Shock',
          value: emergency.defibrillationInitialJ.toStringAsFixed(0),
          unit: 'J',
          subtitle: '2 J/kg',
          icon: Icons.flash_on,
        ),

        ResultCard.emergency(
          title: 'Subsequent Shock',
          value: emergency.defibrillationSubsequentJ.toStringAsFixed(0),
          unit: 'J',
          subtitle: '4 J/kg',
          icon: Icons.flash_on,
        ),

        // Important Notes
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
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
                    color: Theme.of(context).colorScheme.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Important',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '• Always follow PALS/ACLS protocols\n'
                '• Verify calculations before administration\n'
                '• Maximum doses are built into calculations',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
