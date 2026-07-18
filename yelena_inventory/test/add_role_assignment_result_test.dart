import 'package:flutter_test/flutter_test.dart';
import 'package:yelena_inventory/models/add_role_assignment_result.dart';

void main() {
  group('AddRoleAssignmentResult.parse', () {
    test('parses all stable RPC result codes', () {
      for (final result in AddRoleAssignmentResult.values) {
        expect(AddRoleAssignmentResult.parse(result.code), result);
      }
    });

    test('fails clearly for unknown result codes', () {
      expect(
        () => AddRoleAssignmentResult.parse('unexpected'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
