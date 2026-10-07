import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../data/services/auth_service.dart';
import '../navigation/main_navigation_page.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() =>
      _PhoneAuthPageState();
}

class _PhoneAuthPageState
    extends State<PhoneAuthPage> {
  final TextEditingController _phoneController =
      TextEditingController();
  final TextEditingController _codeController =
      TextEditingController();

  bool _codeRequested = false;
  bool _isVerifying = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _requestCode() {
    final auth = AuthService.instance;

    if (!auth.isValidPhoneNumber(
      _phoneController.text,
    )) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '휴대전화 번호를 정확히 입력해주세요.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _codeRequested = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'DEMO 인증번호가 준비되었습니다.',
        ),
      ),
    );
  }

  Future<void> _verify() async {
    if (_isVerifying) {
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    final success =
        await AuthService.instance.verifyAndSignIn(
      phoneNumber: _phoneController.text,
      verificationCode: _codeController.text,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _isVerifying = false;
    });

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '휴대전화 번호 또는 인증번호를 확인해주세요.',
          ),
        ),
      );
      return;
    }

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) =>
            const MainNavigationPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          '본인 인증',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkBrown,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            24,
            20,
            24,
            32,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.lock_person_outlined,
                size: 48,
                color: AppColors.burgundy,
              ),
              const SizedBox(height: 18),
              const Text(
                '나만의 예약을 위해\n본인 인증을 진행해주세요.',
                style: TextStyle(
                  fontSize: 26,
                  height: 1.35,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'THE FIRST WITNESS는 본인 1인 예약을 기준으로 합니다. '
                '동반인은 각자의 휴대전화 번호로 인증 후 별도로 예약해야 합니다.',
                style: TextStyle(
                  height: 1.6,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                '휴대전화 번호',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
              const SizedBox(height: 9),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9-]'),
                  ),
                ],
                decoration: InputDecoration(
                  hintText: '010-0000-0000',
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: _requestCode,
                  child: Text(
                    _codeRequested
                        ? '인증번호 다시 받기'
                        : '인증번호 받기',
                  ),
                ),
              ),
              if (_codeRequested) ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.softYellow,
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: const Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.burgundy,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '현재는 DEMO 인증입니다. 실제 SMS는 발송하지 않으며 '
                          '인증번호 123456을 입력하면 로그인할 수 있습니다.',
                          style: TextStyle(
                            height: 1.5,
                            color: AppColors.darkBrown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '인증번호',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBrown,
                  ),
                ),
                const SizedBox(height: 9),
                TextField(
                  controller: _codeController,
                  keyboardType:
                      TextInputType.number,
                  maxLength: 6,
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: '6자리 인증번호',
                    counterText: '',
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                      borderSide:
                          BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        _isVerifying ? null : _verify,
                    child: Text(
                      _isVerifying
                          ? '인증 중...'
                          : '인증하고 시작하기',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
