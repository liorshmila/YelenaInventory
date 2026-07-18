class IsraeliPhoneNormalizer {
  static final RegExp _allowedCharacters = RegExp(r'^\+?[0-9\s-]+$');
  static final RegExp _localMobileNumber = RegExp(r'^05\d{8}$');
  static final RegExp _internationalMobileNumber = RegExp(r'^\+?9725\d{8}$');

  const IsraeliPhoneNormalizer._();

  static String normalizeToE164(String value) {
    final trimmedValue = value.trim();

    if (trimmedValue.isEmpty) {
      throw const FormatException('Phone number cannot be empty.');
    }

    if (!_allowedCharacters.hasMatch(trimmedValue)) {
      throw const FormatException(
        'Phone number contains unsupported characters.',
      );
    }

    if (trimmedValue.indexOf('+') > 0) {
      throw const FormatException('Plus sign is only allowed at the start.');
    }

    final compactValue = trimmedValue.replaceAll(RegExp(r'[\s-]'), '');

    if (compactValue == '+') {
      throw const FormatException('Phone number cannot be empty.');
    }

    if (_localMobileNumber.hasMatch(compactValue)) {
      return '+972${compactValue.substring(1)}';
    }

    if (_internationalMobileNumber.hasMatch(compactValue)) {
      final withoutPlus = compactValue.startsWith('+')
          ? compactValue.substring(1)
          : compactValue;

      return '+$withoutPlus';
    }

    throw const FormatException(
      'Phone number must be a valid Israeli mobile number.',
    );
  }

  static String normalizeToLocalStorage(String value) {
    final e164 = normalizeToE164(value);
    final localDigits = '0${e164.substring(4)}';

    return '${localDigits.substring(0, 3)}-${localDigits.substring(3)}';
  }
}
