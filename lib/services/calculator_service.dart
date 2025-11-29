import 'dart:math';
import 'package:pedscalc/models/drug.dart';
import 'package:pedscalc/models/emergency_results.dart';
import 'package:pedscalc/models/fluid_results.dart';
import 'package:pedscalc/models/medication_result.dart';

/// Service for performing all pediatric medical calculations.
///
/// Provides methods for unit conversion, emergency calculations,
/// medication dosing, fluid maintenance rates, and weight validation.
class CalculatorService {
  /// Conversion factor from pounds to kilograms
  static const double _lbToKgFactor = 2.20462;

  /// Maximum maintenance fluid rate threshold in mL/hr
  static const double _maxFluidRateThreshold = 120.0;

  /// Converts weight from pounds to kilograms.
  ///
  /// Formula: kg = lb / 2.20462
  double convertLbToKg(double lb) {
    return lb / _lbToKgFactor;
  }

  /// Converts weight from kilograms to pounds.
  ///
  /// Formula: lb = kg * 2.20462
  double convertKgToLb(double kg) {
    return kg * _lbToKgFactor;
  }

  /// Calculates emergency resuscitation values based on weight.
  ///
  /// Returns [EmergencyResults] containing:
  /// - Fluid bolus: 20 mL/kg
  /// - Epinephrine dose: 0.01 mg/kg (max 1 mg)
  /// - Epinephrine volume: 0.1 mL/kg for 1:10,000 (max 10 mL)
  /// - Defibrillation initial: 2 J/kg
  /// - Defibrillation subsequent: 4 J/kg
  EmergencyResults calculateEmergency(double weightKg) {
    return EmergencyResults(
      fluidBolusMl: 20 * weightKg,
      epinephrineMg: min(0.01 * weightKg, 1.0),
      epinephrineMl: min(0.1 * weightKg, 10.0),
      defibrillationInitialJ: 2 * weightKg,
      defibrillationSubsequentJ: 4 * weightKg,
    );
  }

  /// Calculates medication dose and volume based on drug parameters and weight.
  ///
  /// Returns [MedicationResult] containing:
  /// - Dose in mg (capped at maxDailyDose if specified)
  /// - Volume in mL calculated from concentration
  /// - Formula and concentration strings for display
  /// - Warning message if age restrictions apply
  MedicationResult calculateMedication(
    Drug drug,
    double weightKg, {
    int? ageMonths,
  }) {
    // Calculate dose with max daily dose cap if specified
    final doseMg = drug.maxDailyDose != null
        ? min(drug.dosePerKg * weightKg, drug.maxDailyDose!)
        : drug.dosePerKg * weightKg;

    // Calculate volume from dose and concentration
    final volumeMl = (doseMg / drug.concentrationMg) * drug.concentrationMl;

    // Generate formula string
    final formula = '${drug.dosePerKg} mg/kg';

    // Generate concentration string
    final concentration =
        '${drug.concentrationMg.toStringAsFixed(0)}mg/${drug.concentrationMl.toStringAsFixed(0)}mL';

    // Check for age restrictions
    String? warning;
    if (drug.minAgeMonths != null && ageMonths != null) {
      if (ageMonths < drug.minAgeMonths!) {
        warning =
            'Not recommended for infants under ${drug.minAgeMonths} months';
      }
    }

    return MedicationResult(
      drugName: drug.displayName,
      doseMg: doseMg,
      volumeMl: volumeMl,
      formula: formula,
      concentration: concentration,
      warning: warning,
    );
  }

  /// Calculates IV fluid maintenance rate using the Holliday-Segar method.
  ///
  /// The 4-2-1 rule:
  /// - First 10 kg: 4 mL/kg/hr
  /// - Next 10 kg (10-20 kg): 2 mL/kg/hr
  /// - Remaining kg (>20 kg): 1 mL/kg/hr
  ///
  /// Returns [FluidResults] with the calculated rate and a flag if it exceeds 120 mL/hr.
  FluidResults calculateMaintenanceFluid(double weightKg) {
    double rate;

    if (weightKg <= 10) {
      rate = weightKg * 4;
    } else if (weightKg <= 20) {
      rate = 40 + (weightKg - 10) * 2;
    } else {
      rate = 60 + (weightKg - 20) * 1;
    }

    return FluidResults(
      maintenanceRateMlPerHr: rate,
      method: 'Holliday-Segar',
      exceedsMaxRate: rate > _maxFluidRateThreshold,
    );
  }

  /// Validates weight and returns appropriate warning messages.
  ///
  /// Returns:
  /// - Neonatal warning if weight < 1 kg
  /// - Adult weight warning if weight > 50 kg
  /// - Error message if weight > 200 kg
  /// - null for valid weights
  String? validateWeight(double weightKg) {
    if (weightKg > 200) {
      return 'Weight exceeds valid range';
    } else if (weightKg > 50) {
      return 'Approaching adult weight. Check adult dosing limits';
    } else if (weightKg < 1) {
      return 'Neonatal dosing may differ. Consult neonatal protocols.';
    }
    return null;
  }
}
