import 'package:flutter_test/flutter_test.dart';
import 'package:yelena_inventory/utils/israeli_phone_normalizer.dart';

void main() {
  group('IsraeliPhoneNormalizer.normalizeToE164', () {
    test('normalizes valid Israeli mobile numbers', () {
      const cases = {
        '054-1234567': '+972541234567',
        '0541234567': '+972541234567',
        '054 123 4567': '+972541234567',
        '+972541234567': '+972541234567',
        '972541234567': '+972541234567',
        ' 054-1234567 ': '+972541234567',
      };

      for (final entry in cases.entries) {
        expect(IsraeliPhoneNormalizer.normalizeToE164(entry.key), entry.value);
      }
    });

    test('rejects invalid phone numbers', () {
      const invalidValues = [
        '',
        '   ',
        '04-1234567',
        '054-123',
        '+972',
        'abc0541234567',
        '9720541234567',
        '054.1234567',
        '0641234567',
      ];

      for (final value in invalidValues) {
        expect(
          () => IsraeliPhoneNormalizer.normalizeToE164(value),
          throwsA(isA<FormatException>()),
        );
      }
    });
  });

  group('IsraeliPhoneNormalizer.normalizeToLocalStorage', () {
    test('normalizes valid Israeli mobile numbers to storage format', () {
      const cases = {
        '054-1234567': '054-1234567',
        '0541234567': '054-1234567',
        '054 123 4567': '054-1234567',
        '+972541234567': '054-1234567',
        '972541234567': '054-1234567',
      };

      for (final entry in cases.entries) {
        expect(
          IsraeliPhoneNormalizer.normalizeToLocalStorage(entry.key),
          entry.value,
        );
      }
    });

    test('rejects invalid storage phone values', () {
      expect(
        () => IsraeliPhoneNormalizer.normalizeToLocalStorage('054-123'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
