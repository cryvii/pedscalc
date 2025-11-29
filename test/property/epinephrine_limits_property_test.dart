import 'package:glados/glados.dart';
import 'package:pedscalc/services/calculator_service.dart';

void main() {
  group('Epinephrine Maximum Limits Property Tests', () {
    late CalculatorService service;

    setUp(() {
      service = CalculatorService();
    });

    // Feature: pedscalc-mvp, Property 3: Epinephrine maximum limits are enforced
    // For any weight that would produce an epinephrine dose exceeding 1 mg or
    // volume exceeding 10 mL, the calculated values should be capped at exactly
    // 1 mg and 10 mL respectively.
    // Validates: Requirements 3.2, 3.3
    Glados(any.doubleInRange(100.0, 200.0)).test(
      'epinephrine dose is capped at 1 mg for high weights',
      (weightKg) {
        final results = service.calculateEmergency(weightKg);

        // Epinephrine dose should never exceed 1 mg
        expect(
          results.epinephrineMg,
          lessThanOrEqualTo(1.0),
          reason:
              'Epinephrine dose should be capped at 1 mg for weight $weightKg kg',
        );

        // For weights >= 100 kg, dose should be exactly 1 mg
        if (weightKg >= 100) {
          expect(
            results.epinephrineMg,
            equals(1.0),
            reason:
                'Epinephrine dose should be exactly 1 mg for weight $weightKg kg',
          );
        }
      },
    );

    Glados(any.doubleInRange(100.0, 200.0)).test(
      'epinephrine volume is capped at 10 mL for high weights',
      (weightKg) {
        final results = service.calculateEmergency(weightKg);

        // Epinephrine volume should never exceed 10 mL
        expect(
          results.epinephrineMl,
          lessThanOrEqualTo(10.0),
          reason:
              'Epinephrine volume should be capped at 10 mL for weight $weightKg kg',
        );

        // For weights >= 100 kg, volume should be exactly 10 mL
        if (weightKg >= 100) {
          expect(
            results.epinephrineMl,
            equals(10.0),
            reason:
                'Epinephrine volume should be exactly 10 mL for weight $weightKg kg',
          );
        }
      },
    );

    test('epinephrine limits at specific weights', () {
      // Test at exactly 100 kg (threshold)
      final results100kg = service.calculateEmergency(100.0);
      expect(results100kg.epinephrineMg, equals(1.0));
      expect(results100kg.epinephrineMl, equals(10.0));

      // Test above threshold
      final results150kg = service.calculateEmergency(150.0);
      expect(results150kg.epinephrineMg, equals(1.0));
      expect(results150kg.epinephrineMl, equals(10.0));

      // Test below threshold (should scale linearly)
      final results50kg = service.calculateEmergency(50.0);
      expect(results50kg.epinephrineMg, closeTo(0.5, 0.001));
      expect(results50kg.epinephrineMl, closeTo(5.0, 0.01));
    });
  });
}
