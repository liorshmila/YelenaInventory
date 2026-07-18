import 'package:flutter_test/flutter_test.dart';
import 'package:yelena_inventory/models/end_role_assignment_result.dart';

void main() {
  group('EndRoleAssignmentResult.parse', () {
    test('parses all stable RPC result codes', () {
      for (final result in EndRoleAssignmentResult.values) {
        expect(EndRoleAssignmentResult.parse(result.code), result);
      }
    });

    test('fails clearly for unknown result codes', () {
      expect(
        () => EndRoleAssignmentResult.parse('unexpected'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
