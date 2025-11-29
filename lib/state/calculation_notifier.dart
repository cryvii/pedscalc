import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedscalc/models/calculation_state.dart';
import 'package:pedscalc/models/medication_result.dart';
import 'package:pedscalc/services/calculator_service.dart';
import 'package:pedscalc/services/drug_repository.dart';

/// StateNotifier that manages the calculation state for the app.
///
/// Handles weight input, unit conversion, and triggers all calculations
/// when the weight changes.
class CalculationNotifier extends StateNotifier<CalculationState> {
  final CalculatorService _calculatorService;
  final DrugRepository _drugRepository;

  /// Creates a CalculationNotifier with the required dependencies.
  ///
  /// Initializes with default state (kg unit, no weight entered).
  CalculationNotifier(this._calculatorService, this._drugRepository)
      : super(const CalculationState(unit: WeightUnit.kg));

  /// Updates the weight and recalculates all results.
  ///
  /// If [weight] is null, clears all results.
  /// Otherwise, converts to kg if needed and calculates:
  /// - Emergency results
  /// - Medication results for all drugs
  /// - Fluid maintenance results
  /// - Weight validation warnings
  void updateWeight(double? weight) {
    if (weight == null) {
      state = CalculationState(
        weightKg: null,
        unit: state.unit,
        emergencyResults: null,
        medicationResults: const [],
        fluidResults: null,
        weightWarning: null,
      );
      return;
    }

    // Convert to kg if current unit is lb
    final weightKg = state.unit == WeightUnit.kg
        ? weight
        : _calculatorService.convertLbToKg(weight);

    // Calculate all results
    final emergencyResults = _calculatorService.calculateEmergency(weightKg);
    final medicationResults = _calculateAllMedications(weightKg);
    final fluidResults = _calculatorService.calculateMaintenanceFluid(weightKg);
    final weightWarning = _calculatorService.validateWeight(weightKg);

    state = CalculationState(
      weightKg: weightKg,
      unit: state.unit,
      emergencyResults: emergencyResults,
      medicationResults: medicationResults,
      fluidResults: fluidResults,
      weightWarning: weightWarning,
    );
  }

  /// Toggles between kg and lb units.
  ///
  /// Updates the unit preference in state. The displayed weight value
  /// should be converted by the UI layer.
  void toggleUnit() {
    final newUnit = state.unit == WeightUnit.kg ? WeightUnit.lb : WeightUnit.kg;
    state = CalculationState(
      weightKg: state.weightKg,
      unit: newUnit,
      emergencyResults: state.emergencyResults,
      medicationResults: state.medicationResults,
      fluidResults: state.fluidResults,
      weightWarning: state.weightWarning,
    );
  }

  /// Calculates medication results for all drugs in the repository.
  List<MedicationResult> _calculateAllMedications(double weightKg) {
    return _drugRepository
        .getAllDrugs()
        .map((drug) => _calculatorService.calculateMedication(drug, weightKg))
        .toList();
  }
}
