import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedscalc/models/calculation_state.dart';
import 'package:pedscalc/services/calculator_service.dart';
import 'package:pedscalc/services/drug_repository.dart';
import 'package:pedscalc/state/calculation_notifier.dart';

/// Provider for the CalculatorService singleton.
///
/// This service handles all calculation logic for the app.
final calculatorServiceProvider = Provider<CalculatorService>((ref) {
  return CalculatorService();
});

/// Provider for the DrugRepository singleton.
///
/// This repository provides access to the medication database.
final drugRepositoryProvider = Provider<DrugRepository>((ref) {
  return DrugRepository();
});

/// Provider for the CalculationNotifier state notifier.
///
/// This manages the application state for all calculations.
/// Depends on calculatorServiceProvider and drugRepositoryProvider.
final calculationNotifierProvider =
    StateNotifierProvider<CalculationNotifier, CalculationState>((ref) {
  final calculatorService = ref.watch(calculatorServiceProvider);
  final drugRepository = ref.watch(drugRepositoryProvider);

  return CalculationNotifier(calculatorService, drugRepository);
});

/// Shorter alias for calculationNotifierProvider for easier use.
final calculationProvider = calculationNotifierProvider;
