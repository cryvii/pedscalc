import 'package:glados/glados.dart';
import 'package:pedscalc/services/calculator_service.dart';

void main() {
  group('Emergency Calculations Property Tests', () {
    late CalculatorService service;

    setUp(() {
      service = CalculatorService();
    });

    // Feature: pedscalc-mvp, Property 2: Emergency calculations scale linearly with weight
    // For any two valid weights where weight2 = 2 * weight1, all emergency calculations
    // (fluid bolus, epinephrine dose, epinephrine volume, defibrillation energies) for
    // weight2 should equal 2 times the calculations for weight1, except where maximum
    // limits apply.
    // Validates: Requirements 3.1, 3.2, 3.3, 3.4, 3.5
    Glados(any.doubleInRange(0.5, 50.0)).test(
      'emergency calculations scale linearly with weight (below max limits)',
      (weight1) {
        final weight2 = weight1 * 2;

        final results1 = service.calculateEmergency(weight1);
        final results2 = service.calculateEmergency(weight2);

        // Fluid bolus should scale linearly (no max limit)
        expect(
          results2.fluidBolusMl,
          closeTo(results1.fluidBolusMl * 2, 0.01),
          reason: 'Fluid bolus should scale linearly with weight',
        );

        // Defibrillation energies should scale linearly (no max limit)
        expect(
          results2.defibrillationInitialJ,
          closeTo(results1.defibrillationInitialJ * 2, 0.01),
          reason: 'Initial defibrillation should scale linearly with weight',
        );

        expect(
          results2.defibrillationSubsequentJ,
          closeTo(results1.defibrillationSubsequentJ * 2, 0.01),
          reason: 'Subsequent defibrillation should scale linearly with weight',
        );

        // Epinephrine dose and volume scale linearly only if below max
        // For weights below 50 kg, epinephrine should scale linearly
        // (max is 1 mg at 100 kg, max volume is 10 mL at 100 kg)
        if (weight1 < 50) {
          expect(
            results2.epinephrineMg,
            closeTo(results1.epinephrineMg * 2, 0.001),
            reason: 'Epinephrine dose should scale linearly below max limit',
          );

          expect(
            results2.epinephrineMl,
            closeTo(results1.epinephrineMl * 2, 0.01),
            reason: 'Epinephrine volume should scale linearly below max limit',
          );
        }
      },
    );

    test('emergency calculations specific examples', () {
      // Test known values
      final results10kg = service.calculateEmergency(10.0);
      expect(results10kg.fluidBolusMl, equals(200.0));
      expect(results10kg.epinephrineMg, closeTo(0.1, 0.001));
      expect(results10kg.epinephrineMl, closeTo(1.0, 0.01));
      expect(results10kg.defibrillationInitialJ, equals(20.0));
      expect(results10kg.defibrillationSubsequentJ, equals(40.0));

      // Test at 20 kg (double of 10 kg)
      final results20kg = service.calculateEmergency(20.0);
      expect(results20kg.fluidBolusMl, equals(400.0));
      expect(results20kg.epinephrineMg, closeTo(0.2, 0.001));
      expect(results20kg.epinephrineMl, closeTo(2.0, 0.01));
      expect(results20kg.defibrillationInitialJ, equals(40.0));
      expect(results20kg.defibrillationSubsequentJ, equals(80.0));
    });
  });
}
