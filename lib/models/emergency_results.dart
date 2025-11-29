/// Represents emergency resuscitation calculation results.
///
/// Contains all critical values needed for emergency pediatric care,
/// including fluid bolus, epinephrine dosing, and defibrillation energies.
class EmergencyResults {
  /// Fluid bolus volume in milliliters (20 mL/kg)
  final double fluidBolusMl;

  /// Epinephrine dose in milligrams (0.01 mg/kg, max 1 mg)
  final double epinephrineMg;

  /// Epinephrine volume in milliliters for 1:10,000 concentration (0.1 mL/kg, max 10 mL)
  final double epinephrineMl;

  /// Initial defibrillation energy in joules (2 J/kg)
  final double defibrillationInitialJ;

  /// Subsequent defibrillation energy in joules (4 J/kg)
  final double defibrillationSubsequentJ;

  /// Creates an EmergencyResults with the specified values.
  const EmergencyResults({
    required this.fluidBolusMl,
    required this.epinephrineMg,
    required this.epinephrineMl,
    required this.defibrillationInitialJ,
    required this.defibrillationSubsequentJ,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmergencyResults &&
        other.fluidBolusMl == fluidBolusMl &&
        other.epinephrineMg == epinephrineMg &&
        other.epinephrineMl == epinephrineMl &&
        other.defibrillationInitialJ == defibrillationInitialJ &&
        other.defibrillationSubsequentJ == defibrillationSubsequentJ;
  }

  @override
  int get hashCode {
    return Object.hash(
      fluidBolusMl,
      epinephrineMg,
      epinephrineMl,
      defibrillationInitialJ,
      defibrillationSubsequentJ,
    );
  }

  @override
  String toString() {
    return 'EmergencyResults(fluidBolusMl: $fluidBolusMl, '
        'epinephrineMg: $epinephrineMg, epinephrineMl: $epinephrineMl, '
        'defibrillationInitialJ: $defibrillationInitialJ, '
        'defibrillationSubsequentJ: $defibrillationSubsequentJ)';
  }
}
