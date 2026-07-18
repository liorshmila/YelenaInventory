import 'package:flutter/services.dart';

class IsraeliPhoneInputFormatter extends TextInputFormatter {
  const IsraeliPhoneInputFormatter();

  static String format(String value) {
    final digits = _digitsOnly(value);

    if (digits.length <= 3) {
      return digits;
    }

    return '${digits.substring(0, 3)}-${digits.substring(3)}';
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsBeforeCursor = _digitsOnly(
      newValue.text.substring(
        0,
        newValue.selection.extentOffset.clamp(0, newValue.text.length),
      ),
    ).length;
    final formatted = format(newValue.text);
    final cursorOffset = _offsetForDigitCount(formatted, digitsBeforeCursor);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorOffset),
    );
  }

  static String _digitsOnly(String value) {
    final buffer = StringBuffer();

    for (final codeUnit in value.codeUnits) {
      if (codeUnit >= 48 && codeUnit <= 57) {
        buffer.writeCharCode(codeUnit);
        if (buffer.length == 10) {
          break;
        }
      }
    }

    return buffer.toString();
  }

  static int _offsetForDigitCount(String formatted, int digitCount) {
    if (digitCount <= 0) {
      return 0;
    }

    var seenDigits = 0;
    for (var index = 0; index < formatted.length; index++) {
      final codeUnit = formatted.codeUnitAt(index);
      if (codeUnit >= 48 && codeUnit <= 57) {
        seenDigits++;
      }

      if (seenDigits == digitCount) {
        return index + 1;
      }
    }

    return formatted.length;
  }
}
