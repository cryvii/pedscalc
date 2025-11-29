/// Represents the calculated result for a medication dose.
///
/// Contains both the dose in milligrams and the volume in milliliters,
/// along with the formula and concentration used for the calculation.
class MedicationResult {
  /// The name of the drug
  final String drugName;

  /// Calculated dose in milligrams
  final double doseMg;

  /// Calculated volume in milliliters
  final double volumeMl;

  /// Formula used for calculation (e.g., "15 mg/kg")
  final String formula;

  /// Concentration used (e.g., "160mg/5mL")
  final String concentration;

  /// Optional warning message (e.g., age restrictions)
  final String? warning;

  /// Creates a MedicationResult with the specified values.
  const MedicationResult({
    required this.drugName,
    required this.doseMg,
    required this.volumeMl,
    required this.formula,
    required this.concentration,
    this.warning,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MedicationResult &&
        other.drugName == drugName &&
        other.doseMg == doseMg &&
        other.volumeMl == volumeMl &&
        other.formula == formula &&
        other.concentration == concentration &&
        other.warning == warning;
  }

  @override
  int get hashCode {
    return Object.hash(
      drugName,
      doseMg,
      volumeMl,
      formula,
      concentration,
      warning,
    );
  }

  @override
  String toString() {
    return 'MedicationResult(drugName: $drugName, doseMg: $doseMg, '
        'volumeMl: $volumeMl, formula: $formula, concentration: $concentration, '
        'warning: $warning)';
  }
}
