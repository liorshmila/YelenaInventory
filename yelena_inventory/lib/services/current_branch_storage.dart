import 'package:shared_preferences/shared_preferences.dart';

class CurrentBranchStorage {
  static const _lastBranchCodeKey = 'current_session.last_branch_code';

  Future<String?> readLastBranchCode() async {
    final preferences = await SharedPreferences.getInstance();
    final branchCode = preferences.getString(_lastBranchCodeKey)?.trim();

    if (branchCode == null || branchCode.isEmpty) {
      return null;
    }

    return branchCode;
  }

  Future<void> saveLastBranchCode(String branchCode) async {
    final normalizedBranchCode = branchCode.trim();

    if (normalizedBranchCode.isEmpty) {
      throw ArgumentError.value(
        branchCode,
        'branchCode',
        'Branch code cannot be empty.',
      );
    }

    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_lastBranchCodeKey, normalizedBranchCode);
  }

  Future<void> clearLastBranchCode() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_lastBranchCodeKey);
  }
}
