import 'package:glados/glados.dart';
import 'package:pedscalc/services/calculator_service.dart';
import 'package:pedscalc/services/drug_repository.dart';
import 'package:pedscalc/state/calculation_notifier.dart';

void main() {
  group('State Preservation Property Tests', () {
    late CalculatorService service;
    late DrugRepository repository;

    setUp(() {
      service = CalculatorService();
      repository = DrugRepository();
    });

    // Feature: pedscalc-mvp, Property 11: Calculation results are deterministic
    // For any specific weight value, calculating results multiple times should
    // always produce identical values for all medications, emergency parameters,
    // and fluid rates.
    // Validates: Requirements 1.1, 1.3
    Glados(any.doubleInRange(1.0, 100.0)).test(
      'calculation results are deterministic',
      (weightKg) {
        final notifier1 = CalculationNotifier(service, repository);
        final notifier2 = CalculationNotifier(service, repository);

        // Calculate with same weight on both notifiers
        notifier1.updateWeight(weightKg);
        notifier2.updateWeight(weightKg);

        final state1 = notifier1.state;
        final state2 = notifier2.state;

        // Emergency results should be identical
        expect(state1.emergencyResults, equals(state2.emergencyResults),
            reason: 'Emergency results should be deterministic for weight $weightKg kg');

        // Fluid results should be identical
        expect(state1.fluidResults, equals(state2.fluidResults),
            reason: 'Fluid results should be deterministic for weight $weightKg kg');

        // Medication results should be identical
        expect(state1.medicationResults.length, equals(state2.medicationResults.length));
        for (int i = 0; i < state1.medicationResults.length; i++) {
          expect(state1.medicationResults[i], equals(state2.medicationResults[i]),
              reason: 'Medication result $i should be deterministic for weight $weightKg kg');
        }

        // Weight warning should be identical
        expect(state1.weightWarning, equals(state2.weightWarning),
            reason: 'Weight warning should be deterministic for weight $weightKg kg');
      },
    );

    // Feature: pedscalc-mvp, Property 12: Empty weight produces no results
    // For any state where weight is null or empty, the system should produce
    // null or empty results for all calculation categories (emergency, medications, fluids).
    // Validates: Requirements 1.4
    test('empty weight produces no results', () {
      final notifier = CalculationNotifier(service, repository);

      // Initial state should have no results
      expect(notifier.state.weightKg, isNull);
      expect(notifier.state.emergencyResults, isNull);
      expect(notifier.state.medicationResults, isEmpty);
      expect(notifier.state.fluidResults, isNull);
      expect(notifier.state.weightWarning, isNull);

      // Add a weight
      notifier.updateWeight(10.0);
      expect(notifier.state.weightKg, isNotNull);
      expect(notifier.state.emergencyResults, isNotNull);
      expect(notifier.state.medicationResults, isNotEmpty);
      expect(notifier.state.fluidResults, isNotNull);

      // Clear weight by passing null
      notifier.updateWeight(null);
      expect(notifier.state.weightKg, isNull);
      expect(notifier.state.emergencyResults, isNull);
      expect(notifier.state.medicationResults, isEmpty);
      expect(notifier.state.fluidResults, isNull);
      expect(notifier.state.weightWarning, isNull);
    });

    test('multiple calculations with same weight produce identical results', () {
      final notifier = CalculationNotifier(service, repository);

      // Calculate multiple times with same weight
      notifier.updateWeight(15.0);
      final state1 = notifier.state;

      notifier.updateWeight(20.0); // Change weight
      notifier.updateWeight(15.0); // Back to original
      final state2 = notifier.state;

      // Results should be identical
      expect(state1.emergencyResults, equals(state2.emergencyResults));
      expect(state1.fluidResults, equals(state2.fluidResults));
      expect(state1.medicationResults.length, equals(state2.medicationResults.length));
      for (int i = 0; i < state1.medicationResults.length; i++) {
        expect(state1.medicationResults[i], equals(state2.medicationResults[i]));
      }
    });
  });
}
