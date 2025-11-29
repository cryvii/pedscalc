/// Represents IV fluid maintenance calculation results.
///
/// Contains the calculated maintenance rate using the Holliday-Segar method
/// and indicates if the rate exceeds the typical maximum.
class FluidResults {
  /// Maintenance fluid rate in milliliters per hour
  final double maintenanceRateMlPerHr;

  /// Method used for calculation (e.g., "Holliday-Segar")
  final String method;

  /// Whether the calculated rate exceeds 120 mL/hr
  final bool exceedsMaxRate;

  /// Creates a FluidResults with the specified values.
  const FluidResults({
    required this.maintenanceRateMlPerHr,
    required this.method,
    required this.exceedsMaxRate,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FluidResults &&
        other.maintenanceRateMlPerHr == maintenanceRateMlPerHr &&
        other.method == method &&
        other.exceedsMaxRate == exceedsMaxRate;
  }

  @override
  int get hashCode {
    return Object.hash(
      maintenanceRateMlPerHr,
      method,
      exceedsMaxRate,
    );
  }

  @override
  String toString() {
    return 'FluidResults(maintenanceRateMlPerHr: $maintenanceRateMlPerHr, '
        'method: $method, exceedsMaxRate: $exceedsMaxRate)';
  }
}
