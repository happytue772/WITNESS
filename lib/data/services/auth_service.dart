import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  AuthService._();

  static final AuthService instance = AuthService._();

  static const String demoVerificationCode = '123456';

  static const String _phoneKey =
      'first_witness_authenticated_phone';

  final SharedPreferencesAsync _preferences =
      SharedPreferencesAsync();

  String? _phoneNumber;

  String? get phoneNumber => _phoneNumber;

  bool get isSignedIn =>
      _phoneNumber != null && _phoneNumber!.isNotEmpty;

  Future<void> initialize() async {
    _phoneNumber =
        await _preferences.getString(_phoneKey);
  }

  String normalizePhoneNumber(String input) {
    return input.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );
  }

  bool isValidPhoneNumber(String input) {
    final digits = normalizePhoneNumber(input);

    return digits.length >= 10 &&
        digits.length <= 11 &&
        digits.startsWith('01');
  }

  Future<bool> verifyAndSignIn({
    required String phoneNumber,
    required String verificationCode,
  }) async {
    final normalized =
        normalizePhoneNumber(phoneNumber);

    if (!isValidPhoneNumber(normalized)) {
      return false;
    }

    if (verificationCode.trim() !=
        demoVerificationCode) {
      return false;
    }

    _phoneNumber = normalized;

    await _preferences.setString(
      _phoneKey,
      normalized,
    );

    notifyListeners();

    return true;
  }

  String get maskedPhoneNumber {
    final phone = _phoneNumber;

    if (phone == null || phone.length < 7) {
      return '';
    }

    if (phone.length == 11) {
      return '${phone.substring(0, 3)}-****-${phone.substring(7)}';
    }

    return '${phone.substring(0, 3)}-***-${phone.substring(phone.length - 4)}';
  }
}
