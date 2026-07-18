import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yelena_inventory/utils/israeli_phone_input_formatter.dart';

void main() {
  const formatter = IsraeliPhoneInputFormatter();

  TextEditingValue edit(String value, {int? offset}) {
    return TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: offset ?? value.length),
    );
  }

  group('IsraeliPhoneInputFormatter.format', () {
    test('formats visible Israeli local phone values', () {
      const cases = {
        '': '',
        '0': '0',
        '05': '05',
        '050': '050',
        '0501': '050-1',
        '0501234567': '050-1234567',
        '050-1234567': '050-1234567',
        '050 123 4567': '050-1234567',
        '050123456789': '050-1234567',
      };

      for (final entry in cases.entries) {
        expect(IsraeliPhoneInputFormatter.format(entry.key), entry.value);
      }
    });
  });

  group('IsraeliPhoneInputFormatter.formatEditUpdate', () {
    test('formats typing digits and keeps cursor at the end', () {
      final result = formatter.formatEditUpdate(edit('050'), edit('0501'));

      expect(result.text, '050-1');
      expect(result.selection.extentOffset, result.text.length);
    });

    test('accepts paste with hyphens or spaces', () {
      final hyphenated = formatter.formatEditUpdate(
        edit(''),
        edit('050-1234567'),
      );
      final spaced = formatter.formatEditUpdate(edit(''), edit('050 123 4567'));

      expect(hyphenated.text, '050-1234567');
      expect(spaced.text, '050-1234567');
    });

    test('backspace around the hyphen behaves naturally', () {
      final result = formatter.formatEditUpdate(edit('050-1'), edit('050-'));

      expect(result.text, '050');
      expect(result.selection.extentOffset, 3);
    });

    test('preserves cursor position when editing in the middle', () {
      final result = formatter.formatEditUpdate(
        edit('050-1234567', offset: 6),
        edit('050-9234567', offset: 5),
      );

      expect(result.text, '050-9234567');
      expect(result.selection.extentOffset, 5);
    });
  });
}
