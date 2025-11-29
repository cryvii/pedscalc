import 'package:flutter/material.dart';
import '../models/medication_result.dart';

/// Reusable card widget for displaying calculation results
/// 
/// Displays:
/// - Left: Title (e.g., "Paracetamol")
/// - Middle: Calculated Dose (e.g., "150 mg")
/// - Right (Highlighted): Calculated Volume (e.g., "4.7 mL")
/// - Subtitle: Formula used (e.g., "15 mg/kg | 160mg/5mL")
class ResultCard extends StatelessWidget {
  final String title;
  final String primaryValue;
  final String? secondaryValue;
  final String? subtitle;
  final IconData? icon;
  final Color? accentColor;

  const ResultCard({
    super.key,
    required this.title,
    required this.primaryValue,
    this.secondaryValue,
    this.subtitle,
    this.icon,
    this.accentColor,
  });

  /// Factory constructor for medication results
  factory ResultCard.medication(MedicationResult result) {
    return ResultCard(
      title: result.drugName,
      primaryValue: '${result.doseMg.toStringAsFixed(1)} mg',
      secondaryValue: '${result.volumeMl.toStringAsFixed(1)} mL',
      subtitle: result.formula,
      icon: Icons.medication,
      accentColor: Colors.blue,
    );
  }

  /// Factory constructor for emergency results
  factory ResultCard.emergency({
    required String title,
    required String value,
    required String unit,
    String? subtitle,
    IconData? icon,
  }) {
    return ResultCard(
      title: title,
      primaryValue: '$value $unit',
      subtitle: subtitle,
      icon: icon ?? Icons.emergency,
      accentColor: Colors.red,
    );
  }

  /// Factory constructor for fluid results
  factory ResultCard.fluid({
    required String title,
    required String value,
    required String unit,
    String? subtitle,
  }) {
    return ResultCard(
      title: title,
      primaryValue: '$value $unit',
      subtitle: subtitle,
      icon: Icons.water_drop,
      accentColor: Colors.lightBlue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: accentColor ?? Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Primary Value Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Primary Value (Dose in mg)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dose',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        primaryValue,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ],
                  ),
                ),

                // Secondary Value (Volume in mL) - Highlighted if present
                if (secondaryValue != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor?.withValues(alpha: 0.15) ??
                          Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: accentColor?.withValues(alpha: 0.3) ??
                            Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Volume',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: accentColor ??
                                    Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          secondaryValue!,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: accentColor ??
                                    Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            // Subtitle (Formula)
            if (subtitle != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontFamily: 'monospace',
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
