import 'package:flutter_test/flutter_test.dart';
import 'package:yelena_inventory/services/auth_service.dart';

void main() {
  group('EmployeeLinkResult.fromCode', () {
    test('parses all supported server result codes', () {
      for (final result in EmployeeLinkResult.values) {
        expect(EmployeeLinkResult.fromCode(result.code), result);
      }
    });

    test('rejects unknown server result codes', () {
      expect(
        () => EmployeeLinkResult.fromCode('unexpectedResult'),
        throwsFormatException,
      );
    });
  });
}
