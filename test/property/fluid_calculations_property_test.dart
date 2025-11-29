import 'package:glados/glados.dart';
import 'package:pedscalc/services/calculator_service.dart';

void main() {
  group('Fluid Calculations Property Tests', () {
    late CalculatorService service;

    setUp(() {
      service = CalculatorService();
    });

    // Feature: pedscalc-mvp, Property 6: Holliday-Segar fluid calculation is monotonically increasing
    // For any two valid weights where weight2 > weight1, the maintenance fluid rate
    // for weight2 should be greater than or equal to the rate for weight1.
    // Validates: Requirements 5.1, 5.2, 5.3
    Glados2(any.doubleInRange(0.5, 100.0), any.doubleInRange(0.5, 100.0)).test(
      'fluid maintenance rate is monotonically increasing',
      (weight1, weight2) {
        if (weight1 >= weight2) return; // Skip if not weight1 < weight2

        final result1 = service.calculateMaintenanceFluid(weight1);
        final result2 = service.calculateMaintenanceFluid(weight2);

        expect(
          result2.maintenanceRateMlPerHr,
          greaterThanOrEqualTo(result1.maintenanceRateMlPerHr),
          reason:
              'Maintenance rate should be monotonically increasing: '
              'weight1=$weight1 kg (${result1.maintenanceRateMlPerHr} mL/hr) < '
              'weight2=$weight2 kg (${result2.maintenanceRateMlPerHr} mL/hr)',
        );
      },
    );

    // Feature: pedscalc-mvp, Property 7: Holliday-Segar breakpoint consistency
    // For any weight exactly at 10 kg or 20 kg, calculating the maintenance rate
    // using the formula for the lower bracket should equal the calculation using
    // the formula for the upper bracket.
    // Validates: Requirements 5.1, 5.2, 5.3
    test('Holliday-Segar breakpoint at 10 kg is consistent', () {
      final result = service.calculateMaintenanceFluid(10.0);

      // Using lower bracket formula: 10 * 4 = 40
      final lowerBracket = 10.0 * 4;

      // Using upper bracket formula: 40 + (10 - 10) * 2 = 40
      final upperBracket = 40 + (10.0 - 10) * 2;

      expect(result.maintenanceRateMlPerHr, equals(40.0));
      expect(lowerBracket, equals(upperBracket));
      expect(result.maintenanceRateMlPerHr, equals(lowerBracket));
    });

    test('Holliday-Segar breakpoint at 20 kg is consistent', () {
      final result = service.calculateMaintenanceFluid(20.0);

      // Using middle bracket formula: 40 + (20 - 10) * 2 = 60
      final middleBracket = 40 + (20.0 - 10) * 2;

      // Using upper bracket formula: 60 + (20 - 20) * 1 = 60
      final upperBracket = 60 + (20.0 - 20) * 1;

      expect(result.maintenanceRateMlPerHr, equals(60.0));
      expect(middleBracket, equals(upperBracket));
      expect(result.maintenanceRateMlPerHr, equals(middleBracket));
    });

    test('fluid maintenance calculations specific examples', () {
      // Test first bracket (≤10 kg): 4 mL/kg/hr
      final result5kg = service.calculateMaintenanceFluid(5.0);
      expect(result5kg.maintenanceRateMlPerHr, equals(20.0)); // 5 * 4
      expect(result5kg.method, equals('Holliday-Segar'));
      expect(result5kg.exceedsMaxRate, isFalse);

      // Test second bracket (10-20 kg): 40 + 2 mL/kg/hr for each kg above 10
      final result15kg = service.calculateMaintenanceFluid(15.0);
      expect(result15kg.maintenanceRateMlPerHr, equals(50.0)); // 40 + (15-10)*2
      expect(result15kg.exceedsMaxRate, isFalse);

      // Test third bracket (>20 kg): 60 + 1 mL/kg/hr for each kg above 20
      final result30kg = service.calculateMaintenanceFluid(30.0);
      expect(result30kg.maintenanceRateMlPerHr, equals(70.0)); // 60 + (30-20)*1
      expect(result30kg.exceedsMaxRate, isFalse);

      // Test exceeds max rate threshold
      final result150kg = service.calculateMaintenanceFluid(150.0);
      expect(result150kg.maintenanceRateMlPerHr, equals(190.0)); // 60 + 130
      expect(result150kg.exceedsMaxRate, isTrue);
    });
  });
}
