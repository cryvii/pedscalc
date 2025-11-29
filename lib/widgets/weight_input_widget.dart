import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/providers.dart';
import '../models/calculation_state.dart';

/// Widget for inputting weight with unit toggle
/// 
/// Provides a large, focused input field for weight entry with:
/// - Numeric keyboard
/// - kg/lb unit toggle
/// - Material 3 design
/// - Auto-calculation on input
class WeightInputWidget extends ConsumerStatefulWidget {
  const WeightInputWidget({super.key});

  @override
  ConsumerState<WeightInputWidget> createState() => _WeightInputWidgetState();
}

class _WeightInputWidgetState extends ConsumerState<WeightInputWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(calculationProvider);
    final notifier = ref.read(calculationProvider.notifier);

    // Update controller if state changes externally
    if (state.weightKg != null) {
      final displayWeight = state.unit == WeightUnit.kg
          ? state.weightKg
          : state.weightKg! * 2.20462;
      
      if (_controller.text != displayWeight!.toStringAsFixed(1)) {
        _controller.text = displayWeight.toStringAsFixed(1);
      }
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              'Patient Weight',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),

            // Unit Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _UnitToggleButton(
                  label: 'kg',
                  isSelected: state.unit == WeightUnit.kg,
                  onTap: () {
                    if (state.unit != WeightUnit.kg) {
                      notifier.toggleUnit();
                    }
                  },
                ),
                const SizedBox(width: 16),
                _UnitToggleButton(
                  label: 'lb',
                  isSelected: state.unit == WeightUnit.lb,
                  onTap: () {
                    if (state.unit != WeightUnit.lb) {
                      notifier.toggleUnit();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Weight Input Field
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              decoration: InputDecoration(
                hintText: '0.0',
                suffix: Text(
                  state.unit == WeightUnit.kg ? 'kg' : 'lb',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 3,
                  ),
                ),
              ),
              onChanged: (value) {
                if (value.isEmpty) {
                  notifier.updateWeight(null);
                  return;
                }
                
                final weight = double.tryParse(value);
                if (weight != null) {
                  notifier.updateWeight(weight);
                }
              },
            ),
            const SizedBox(height: 16),

            // Warning message if applicable
            if (state.weightWarning != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.weightWarning!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Toggle button for unit selection (kg/lb)
class _UnitToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _UnitToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
