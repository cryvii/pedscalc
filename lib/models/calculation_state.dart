import 'package:pedscalc/models/emergency_results.dart';
import 'package:pedscalc/models/fluid_results.dart';
import 'package:pedscalc/models/medication_result.dart';

/// Enum representing the weight unit (kilograms or pounds).
enum WeightUnit {
  /// Kilograms
  kg,

  /// Pounds
  lb,
}

/// Represents the complete application state for pediatric calculations.
///
/// This immutable state contains the current weight, unit preference,
/// and all calculated results across emergency, medication, and fluid categories.
class CalculationState {
  /// Current weight in kilograms (null if not entered)
  final double? weightKg;

  /// Current weight unit preference (kg or lb)
  final WeightUnit unit;

  /// Emergency calculation results (null if no weight entered)
  final EmergencyResults? emergencyResults;

  /// List of medication calculation results (empty if no weight entered)
  final List<MedicationResult> medicationResults;

  /// Fluid maintenance calculation results (null if no weight entered)
  final FluidResults? fluidResults;

  /// Warning message for weight validation (null if no warning)
  final String? weightWarning;

  /// Creates a CalculationState with the specified values.
  const CalculationState({
    this.weightKg,
    required this.unit,
    this.emergencyResults,
    this.medicationResults = const [],
    this.fluidResults,
    this.weightWarning,
  });

  /// Creates a copy of this CalculationState with the given fields replaced.
  ///
  /// This method supports nullable updates by using a special pattern:
  /// - If a parameter is not provided, the original value is kept
  /// - If a parameter is provided (even if null), it replaces the original
  CalculationState copyWith({
    double? weightKg,
    WeightUnit? unit,
    EmergencyResults? emergencyResults,
    List<MedicationResult>? medicationResults,
    FluidResults? fluidResults,
    String? weightWarning,
  }) {
    return CalculationState(
      weightKg: weightKg ?? this.weightKg,
      unit: unit ?? this.unit,
      emergencyResults: emergencyResults ?? this.emergencyResults,
      medicationResults: medicationResults ?? this.medicationResults,
      fluidResults: fluidResults ?? this.fluidResults,
      weightWarning: weightWarning ?? this.weightWarning,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CalculationState &&
        other.weightKg == weightKg &&
        other.unit == unit &&
        other.emergencyResults == emergencyResults &&
        _listEquals(other.medicationResults, medicationResults) &&
        other.fluidResults == fluidResults &&
        other.weightWarning == weightWarning;
  }

  @override
  int get hashCode {
    return Object.hash(
      weightKg,
      unit,
      emergencyResults,
      Object.hashAll(medicationResults),
      fluidResults,
      weightWarning,
    );
  }

  @override
  String toString() {
    return 'CalculationState(weightKg: $weightKg, unit: $unit, '
        'emergencyResults: $emergencyResults, '
        'medicationResults: ${medicationResults.length} items, '
        'fluidResults: $fluidResults, weightWarning: $weightWarning)';
  }

  /// Helper method to compare two lists for equality.
  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
