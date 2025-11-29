import 'package:pedscalc/models/drug.dart';

/// Repository for accessing the medication database.
///
/// Provides access to a predefined list of common pediatric medications
/// with their dosing parameters. All data is stored locally for offline access.
class DrugRepository {
  /// Static list of available drugs with correct dosing parameters.
  static final List<Drug> _drugs = [
    const Drug(
      name: 'acetaminophen',
      displayName: 'Acetaminophen (Paracetamol)',
      dosePerKg: 15.0, // 15 mg/kg per dose
      concentrationMg: 160.0, // 160 mg
      concentrationMl: 5.0, // per 5 mL
      dosesPerDay: 4, // q6h
    ),
    const Drug(
      name: 'ibuprofen',
      displayName: 'Ibuprofen',
      dosePerKg: 10.0, // 10 mg/kg per dose
      concentrationMg: 100.0, // 100 mg
      concentrationMl: 5.0, // per 5 mL
      dosesPerDay: 3, // q8h
      minAgeMonths: 6, // Not recommended for infants under 6 months
    ),
    const Drug(
      name: 'amoxicillin',
      displayName: 'Amoxicillin (High Dose)',
      dosePerKg: 45.0, // 45 mg/kg per dose (90 mg/kg/day divided by 2 for BID)
      concentrationMg: 400.0, // 400 mg
      concentrationMl: 5.0, // per 5 mL
      dosesPerDay: 2, // BID (twice daily)
    ),
    const Drug(
      name: 'prednisolone',
      displayName: 'Prednisolone',
      dosePerKg: 2.0, // 2 mg/kg per dose
      concentrationMg: 15.0, // 15 mg
      concentrationMl: 5.0, // per 5 mL
      maxDailyDose: 60.0, // Maximum 60 mg per day
      dosesPerDay: 1, // Once daily
    ),
  ];

  /// Returns all available drugs in the repository.
  List<Drug> getAllDrugs() {
    return List.unmodifiable(_drugs);
  }

  /// Returns a specific drug by name, or null if not found.
  ///
  /// The [name] parameter should match the drug's internal name
  /// (e.g., 'acetaminophen', not 'Acetaminophen (Paracetamol)').
  Drug? getDrugByName(String name) {
    try {
      return _drugs.firstWhere((drug) => drug.name == name);
    } catch (e) {
      return null;
    }
  }
}
