import 'package:flutter_test/flutter_test.dart';
import 'package:yelena_inventory/models/create_employee_result.dart';

void main() {
  group('CreateEmployeeResult.parse', () {
    test('parses all stable RPC result codes', () {
      for (final result in CreateEmployeeResult.values) {
        expect(CreateEmployeeResult.parse(result.code), result);
      }
    });

    test('fails clearly for unknown result codes', () {
      expect(
        () => CreateEmployeeResult.parse('unexpected'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
