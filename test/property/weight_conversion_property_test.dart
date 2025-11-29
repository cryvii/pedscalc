import 'package:glados/glados.dart';
import 'package:pedscalc/services/calculator_service.dart';

void main() {
  group('Weight Conversion Property Tests', () {
    late CalculatorService service;

    setUp(() {
      service = CalculatorService();
    });

    // Feature: pedscalc-mvp, Property 1: Weight conversion round trip
    // For any weight value in kilograms, converting to pounds and back to
    // kilograms should produce the original value within floating-point
    // precision tolerance (0.01 kg).
    // Validates: Requirements 10.1, 10.2, 10.3
    Glados(any.doubleInRange(0.5, 150.0)).test(
      'weight conversion round trip preserves value within tolerance',
      (weightKg) {
        // Convert kg -> lb -> kg
        final weightLb = service.convertKgToLb(weightKg);
        final weightKgRoundTrip = service.convertLbToKg(weightLb);

        // Assert the round trip preserves the value within 0.01 kg tolerance
        expect(
          (weightKg - weightKgRoundTrip).abs(),
          lessThan(0.01),
          reason:
              'Round trip conversion should preserve weight within 0.01 kg. '
              'Original: $weightKg kg, After round trip: $weightKgRoundTrip kg',
        );
      },
    );

    test('unit conversion specific examples', () {
      // Test specific known conversions
      expect(service.convertKgToLb(10.0), closeTo(22.0462, 0.0001));
      expect(service.convertLbToKg(22.0462), closeTo(10.0, 0.0001));

      // Test edge cases
      expect(service.convertKgToLb(0.5), closeTo(1.10231, 0.0001));
      expect(service.convertKgToLb(100.0), closeTo(220.462, 0.001));
    });
  });
}
