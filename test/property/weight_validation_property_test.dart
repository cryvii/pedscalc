import 'package:glados/glados.dart';
import 'package:pedscalc/services/calculator_service.dart';

void main() {
  group('Weight Validation Property Tests', () {
    late CalculatorService service;

    setUp(() {
      service = CalculatorService();
    });

    // Feature: pedscalc-mvp, Property 8: Weight warnings trigger at correct thresholds
    // For any weight less than 1 kg, the system should generate a neonatal warning;
    // for any weight greater than 50 kg, the system should generate an adult weight
    // warning; for any weight greater than 200 kg, the system should reject the input.
    // Validates: Requirements 6.1, 6.2, 6.3
    Glados(any.doubleInRange(0.1, 0.99)).test(
      'neonatal warning for weights less than 1 kg',
      (weightKg) {
        final warning = service.validateWeight(weightKg);

        expect(
          warning,
          isNotNull,
          reason: 'Weight $weightKg kg should trigger a warning',
        );

        expect(
          warning,
          contains('Neonatal'),
          reason: 'Warning should mention neonatal dosing for weight $weightKg kg',
        );
      },
    );

    Glados(any.doubleInRange(50.01, 200.0)).test(
      'adult weight warning for weights greater than 50 kg',
      (weightKg) {
        final warning = service.validateWeight(weightKg);

        expect(
          warning,
          isNotNull,
          reason: 'Weight $weightKg kg should trigger a warning',
        );

        expect(
          warning,
          contains('adult'),
          reason: 'Warning should mention adult weight for weight $weightKg kg',
        );
      },
    );

    Glados(any.doubleInRange(200.01, 300.0)).test(
      'error for weights exceeding 200 kg',
      (weightKg) {
        final warning = service.validateWeight(weightKg);

        expect(
          warning,
          isNotNull,
          reason: 'Weight $weightKg kg should trigger an error',
        );

        expect(
          warning,
          contains('exceeds'),
          reason: 'Error should indicate weight exceeds valid range for $weightKg kg',
        );
      },
    );

    Glados(any.doubleInRange(1.0, 50.0)).test(
      'no warning for normal weights (1-50 kg)',
      (weightKg) {
        final warning = service.validateWeight(weightKg);

        expect(
          warning,
          isNull,
          reason: 'Weight $weightKg kg should not trigger any warning',
        );
      },
    );

    test('weight validation at specific thresholds', () {
      // Test exactly at 1 kg (should be valid)
      expect(service.validateWeight(1.0), isNull);

      // Test just below 1 kg (should warn)
      final warning0_99 = service.validateWeight(0.99);
      expect(warning0_99, isNotNull);
      expect(warning0_99, contains('Neonatal'));

      // Test exactly at 50 kg (should be valid)
      expect(service.validateWeight(50.0), isNull);

      // Test just above 50 kg (should warn)
      final warning50_01 = service.validateWeight(50.01);
      expect(warning50_01, isNotNull);
      expect(warning50_01, contains('adult'));

      // Test exactly at 200 kg (should warn about adult)
      final warning200 = service.validateWeight(200.0);
      expect(warning200, isNotNull);
      expect(warning200, contains('adult'));

      // Test just above 200 kg (should error)
      final error200_01 = service.validateWeight(200.01);
      expect(error200_01, isNotNull);
      expect(error200_01, contains('exceeds'));
    });
  });
}
