import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _stateKey =
      'first_witness_app_state_v1';

  final SharedPreferencesAsync _preferences =
  SharedPreferencesAsync();

  Future<void> saveState(
      Map<String, dynamic> state,
      ) async {
    final jsonString = jsonEncode(state);

    await _preferences.setString(
      _stateKey,
      jsonString,
    );
  }

  Future<Map<String, dynamic>?> loadState() async {
    final jsonString =
    await _preferences.getString(_stateKey);

    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(jsonString);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return Map<String, dynamic>.from(
      decoded as Map,
    );
  }

  Future<void> clearState() async {
    await _preferences.remove(_stateKey);
  }
}