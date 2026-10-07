import 'package:flutter/material.dart';

import 'app.dart';
import 'data/repositories/local_repository.dart';
import 'data/services/auth_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const _BootstrapApp(),
  );
}

class _BootstrapApp extends StatefulWidget {
  const _BootstrapApp();

  @override
  State<_BootstrapApp> createState() =>
      _BootstrapAppState();
}

class _BootstrapAppState extends State<_BootstrapApp> {
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();

    _initialization = _initializeApp();
  }

  Future<void> _initializeApp() async {
    debugPrint(
      '[BOOT] LocalRepository initialization started',
    );

    await Future.wait([
      LocalRepository.instance.initialize(),
      AuthService.instance.initialize(),
    ]).timeout(
      const Duration(seconds: 10),
    );

    debugPrint(
      '[BOOT] LocalRepository initialization completed',
    );
  }

  void _retryInitialization() {
    setState(() {
      _initialization = _initializeApp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        // ============================================
        // 초기화 성공
        // ============================================

        if (snapshot.connectionState ==
            ConnectionState.done &&
            !snapshot.hasError) {
          return const FirstWitnessApp();
        }

        // ============================================
        // 초기화 실패
        // ============================================

        if (snapshot.hasError) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor:
              const Color(0xFFFFFBF5),
              body: SafeArea(
                child: Center(
                  child: Padding(
                    padding:
                    const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color:
                          Color(0xFF98152B),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        const Text(
                          '앱 초기화 중 문제가 발생했습니다.',
                          textAlign:
                          TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight:
                            FontWeight.bold,
                            color:
                            Color(0xFF5B4038),
                          ),
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        Text(
                          '${snapshot.error}',
                          textAlign:
                          TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.5,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(
                          height: 24,
                        ),

                        SizedBox(
                          width: 180,
                          height: 48,
                          child: ElevatedButton(
                            onPressed:
                            _retryInitialization,
                            style:
                            ElevatedButton
                                .styleFrom(
                              backgroundColor:
                              const Color(
                                0xFF98152B,
                              ),
                              foregroundColor:
                              Colors.white,
                            ),
                            child: const Text(
                              '다시 시도',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        // ============================================
        // 초기화 진행 중
        // ============================================

        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor:
            Color(0xFFFFFBF5),
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color:
                      Color(0xFF98152B),
                    ),

                    SizedBox(height: 22),

                    Text(
                      'THE FIRST WITNESS',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        Color(0xFF98152B),
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      '앱 데이터를 불러오고 있습니다.',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}