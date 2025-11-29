import 'package:glados/glados.dart';
import 'package:pedscalc/services/calculator_service.dart';
import 'package:pedscalc/services/drug_repository.dart';

void main() {
  group('Medication Calculations Property Tests', () {
    late CalculatorService service;
    late DrugRepository repository;

    setUp(() {
      service = CalculatorService();
      repository = DrugRepository();
    });

    // Feature: pedscalc-mvp, Property 4: Medication volume calculation consistency
    // For any drug and weight, the calculated volume in mL should equal
    // (doseMg / concentrationMg) * concentrationMl, where doseMg is the
    // calculated dose for that weight.
    // Validates: Requirements 4.2, 4.4, 4.6, 4.8
    Glados(any.doubleInRange(1.0, 50.0)).test(
      'medication volume calculation is consistent with formula',
      (weightKg) {
        final drugs = repository.getAllDrugs();

        for (final drug in drugs) {
          final result = service.calculateMedication(drug, weightKg);

          // Calculate expected volume from dose and concentration
          final expectedVolume =
              (result.doseMg / drug.concentrationMg) * drug.concentrationMl;

          expect(
            result.volumeMl,
            closeTo(expectedVolume, 0.01),
            reason:
                'Volume for ${drug.name} should match formula: '
                '(${result.doseMg} / ${drug.concentrationMg}) * ${drug.concentrationMl} = $expectedVolume mL',
          );
        }
      },
    );

    // Feature: pedscalc-mvp, Property 5: Medication maximum daily dose is enforced
    // For any drug with a maxDailyDose and any weight, the calculated dose in mg
    // should never exceed the drug's maxDailyDose value.
    // Validates: Requirements 4.7
    Glados(any.doubleInRange(1.0, 100.0)).test(
      'medication maximum daily dose is enforced',
      (weightKg) {
        final drugs = repository.getAllDrugs();

        for (final drug in drugs) {
          final result = service.calculateMedication(drug, weightKg);

          if (drug.maxDailyDose != null) {
            expect(
              result.doseMg,
              lessThanOrEqualTo(drug.maxDailyDose!),
              reason:
                  'Dose for ${drug.name} should not exceed max daily dose of ${drug.maxDailyDose} mg',
            );
          }
        }
      },
    );

    test('medication calculations specific examples', () {
      // Test acetaminophen at 10 kg
      final acetaminophen = repository.getDrugByName('acetaminophen')!;
      final acetResult = service.calculateMedication(acetaminophen, 10.0);
      expect(acetResult.doseMg, equals(150.0)); // 15 mg/kg * 10 kg
      expect(acetResult.volumeMl, closeTo(4.6875, 0.01)); // (150/160)*5

      // Test prednisolone at 40 kg (should hit max dose)
      final prednisolone = repository.getDrugByName('prednisolone')!;
      final predResult = service.calculateMedication(prednisolone, 40.0);
      expect(predResult.doseMg, equals(60.0)); // Capped at max
      expect(predResult.volumeMl, closeTo(20.0, 0.01)); // (60/15)*5
    });
  });
}
