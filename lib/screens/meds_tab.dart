import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/providers.dart';
import '../widgets/result_card.dart';

/// Medications tab showing common pediatric drug calculations
/// 
/// Displays calculated doses and volumes for:
/// - Acetaminophen (Paracetamol)
/// - Ibuprofen
/// - Amoxicillin
/// - Prednisolone
class MedsTab extends ConsumerWidget {
  const MedsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculationProvider);

    if (state.weightKg == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medication,
              size: 64,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Enter patient weight to see medication calculations',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final medications = state.medicationResults;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header
        Text(
          'Common Medications',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          'Pediatric dosing with liquid volumes',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 16),

        // Antipyretics Section
        Text(
          'Antipyretics / Analgesics',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),

        // Find and display Acetaminophen
        ...medications
            .where((med) => med.drugName.contains('Acetaminophen'))
            .map((med) => ResultCard.medication(med)),

        // Find and display Ibuprofen
        ...medications
            .where((med) => med.drugName.contains('Ibuprofen'))
            .map((med) => ResultCard.medication(med)),

        const Divider(height: 32),

        // Antibiotics Section
        Text(
          'Antibiotics',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),

        // Find and display Amoxicillin
        ...medications
            .where((med) => med.drugName.contains('Amoxicillin'))
            .map((med) => ResultCard.medication(med)),

        const Divider(height: 32),

        // Steroids Section
        Text(
          'Corticosteroids',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),

        // Find and display Prednisolone
        ...medications
            .where((med) => med.drugName.contains('Prednisolone'))
            .map((med) => ResultCard.medication(med)),

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
                    'Dosing Notes',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '• Volumes shown are per dose\n'
                '• Maximum daily doses are enforced\n'
                '• Always verify concentration on bottle\n'
                '• Round volumes to nearest 0.5 mL for practical dosing',
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
}
