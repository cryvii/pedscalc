/// Represents a medication with dosing parameters for pediatric calculations.
///
/// This immutable model contains all necessary information to calculate
/// medication doses and volumes based on patient weight.
class Drug {
  /// Internal identifier for the drug (e.g., 'acetaminophen')
  final String name;

  /// User-friendly display name (e.g., 'Acetaminophen (Paracetamol)')
  final String displayName;

  /// Dose per kilogram of body weight in mg/kg
  final double dosePerKg;

  /// Concentration numerator - mg part of concentration (e.g., 160 in 160mg/5mL)
  final double concentrationMg;

  /// Concentration denominator - mL part of concentration (e.g., 5 in 160mg/5mL)
  final double concentrationMl;

  /// Optional maximum daily dose in mg (null if no cap)
  final double? maxDailyDose;

  /// Number of doses per day (frequency)
  final int dosesPerDay;

  /// Optional minimum age in months (null if no age restriction)
  final int? minAgeMonths;

  /// Creates a Drug with the specified parameters.
  ///
  /// All parameters except [maxDailyDose] and [minAgeMonths] are required.
  const Drug({
    required this.name,
    required this.displayName,
    required this.dosePerKg,
    required this.concentrationMg,
    required this.concentrationMl,
    this.maxDailyDose,
    required this.dosesPerDay,
    this.minAgeMonths,
  });

  /// Creates a copy of this Drug with the given fields replaced with new values.
  Drug copyWith({
    String? name,
    String? displayName,
    double? dosePerKg,
    double? concentrationMg,
    double? concentrationMl,
    double? maxDailyDose,
    int? dosesPerDay,
    int? minAgeMonths,
  }) {
    return Drug(
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      dosePerKg: dosePerKg ?? this.dosePerKg,
      concentrationMg: concentrationMg ?? this.concentrationMg,
      concentrationMl: concentrationMl ?? this.concentrationMl,
      maxDailyDose: maxDailyDose ?? this.maxDailyDose,
      dosesPerDay: dosesPerDay ?? this.dosesPerDay,
      minAgeMonths: minAgeMonths ?? this.minAgeMonths,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Drug &&
        other.name == name &&
        other.displayName == displayName &&
        other.dosePerKg == dosePerKg &&
        other.concentrationMg == concentrationMg &&
        other.concentrationMl == concentrationMl &&
        other.maxDailyDose == maxDailyDose &&
        other.dosesPerDay == dosesPerDay &&
        other.minAgeMonths == minAgeMonths;
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      displayName,
      dosePerKg,
      concentrationMg,
      concentrationMl,
      maxDailyDose,
      dosesPerDay,
      minAgeMonths,
    );
  }

  @override
  String toString() {
    return 'Drug(name: $name, displayName: $displayName, dosePerKg: $dosePerKg, '
        'concentrationMg: $concentrationMg, concentrationMl: $concentrationMl, '
        'maxDailyDose: $maxDailyDose, dosesPerDay: $dosesPerDay, '
        'minAgeMonths: $minAgeMonths)';
  }
}
