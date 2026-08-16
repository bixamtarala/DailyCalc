import 'package:flutter_test/flutter_test.dart';
import 'package:dailycalc/services/calculator_service.dart';

void main() {
  test('simple interest', () => expect(CalculatorService.simpleInterest(10000, 10, 2), 2000));
  test('zero-interest EMI', () => expect(CalculatorService.emi(12000, 0, 12), 1000));
  test('discount', () => expect(CalculatorService.discountPrice(1000, 20), 800));
  test('monthly vaddi', () => expect(CalculatorService.monthlyVaddi(10000, 2, 3), 600));
}
