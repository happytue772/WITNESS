import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/navigation/home_navigation_action.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/local_repository.dart';

class QrScanPage extends StatefulWidget {
  final String reservationId;

  const QrScanPage({
    super.key,
    required this.reservationId,
  });

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  late final MobileScannerController _controller;

  bool _processing = false;

  @override
  void initState() {
    super.initState();

    _controller = MobileScannerController(
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.noDuplicates,
      formats: const [
        BarcodeFormat.qrCode,
      ],
    );
  }

  Future<void> _handleQr(String rawValue) async {
    if (_processing) {
      return;
    }

    _processing = true;

    final repository = LocalRepository.instance;

    final expectedPoint =
    repository.nextPointForReservation(
      widget.reservationId,
    );

    if (expectedPoint == null) {
      _processing = false;

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '이미 모든 단서를 발견했습니다.',
          ),
        ),
      );

      return;
    }

    final value = rawValue.trim();

    if (value != expectedPoint.id) {
      _processing = false;

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '현재 찾아야 할 단서는 '
                '"${expectedPoint.title}"입니다.',
          ),
        ),
      );

      return;
    }

    final success =
    repository.discoverDemoPoint(
      reservationId: widget.reservationId,
      pointId: value,
    );

    if (!success) {
      _processing = false;

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '단서를 확인하지 못했습니다.',
          ),
        ),
      );

      return;
    }

    try {
      await _controller.stop();
    } catch (_) {}

    if (!mounted) {
      return;
    }

    final progress =
    repository.progressForReservation(
      widget.reservationId,
    );

    final completed =
        progress.explorationCompleted;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Icon(
            completed
                ? Icons.check_circle
                : Icons.auto_awesome,
            size: 48,
            color: AppColors.burgundy,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                completed
                    ? '모든 단서를 발견했습니다.'
                    : '${expectedPoint.title}를 찾았습니다.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                completed
                    ? '이제 프로그램 체험 단계로 이동할 수 있습니다.'
                    : '탐색 화면에서 다음 단서를 확인해보세요.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  height: 1.5,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(
                    dialogContext,
                  ).pop();
                },
                child: const Text('확인'),
              ),
            ),
          ],
        );
      },
    );

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop(true);
  }

  void _onDetect(
      BarcodeCapture capture,
      ) {
    if (_processing) {
      return;
    }

    if (capture.barcodes.isEmpty) {
      return;
    }

    final value =
        capture.barcodes.first.rawValue;

    if (value == null ||
        value.trim().isEmpty) {
      return;
    }

    unawaited(
      _handleQr(value),
    );
  }

  Future<void> _toggleTorch() async {
    try {
      await _controller.toggleTorch();
    } catch (_) {}
  }

  Future<void> _switchCamera() async {
    try {
      await _controller.switchCamera();
    } catch (_) {}
  }

  @override
  void dispose() {
    unawaited(
      _controller.dispose(),
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository =
        LocalRepository.instance;

    final progress =
    repository.progressForReservation(
      widget.reservationId,
    );

    final nextPoint =
    repository.nextPointForReservation(
      widget.reservationId,
    );

    final total =
        LocalRepository
            .demoExplorationPoints.length;

    final discovered =
        progress.discoveredPointIds.length;

    final current =
    discovered >= total
        ? total
        : discovered + 1;

    return Scaffold(
      backgroundColor:
      const Color(0xFF241C17),
      appBar: AppBar(
        backgroundColor:
        const Color(0xFF241C17),
        foregroundColor: Colors.white,
        title: const Text(
          'QR 스캔',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          HomeNavigationAction(
            warningTitle: 'QR 스캔을 중단할까요?',
            warningMessage:
                '홈으로 이동하면 현재 QR 스캔이 중단됩니다. 이미 발견한 단서는 유지되지만 아직 인식되지 않은 QR은 기록되지 않습니다.',
            iconColor: Colors.white,
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: MobileScanner(
              controller: _controller,
              useAppLifecycleState: true,
              tapToFocus: true,
              onDetect: _onDetect,
              placeholderBuilder: (_) {
                return const ColoredBox(
                  color: Color(0xFF241C17),
                  child: Center(
                    child: CircularProgressIndicator(
                      color:
                      AppColors.softYellow,
                    ),
                  ),
                );
              },
              errorBuilder: (
                  context,
                  error,
                  ) {
                return Container(
                  color:
                  const Color(0xFF241C17),
                  alignment:
                  Alignment.center,
                  padding:
                  const EdgeInsets.all(30),
                  child: const Text(
                    '카메라를 사용할 수 없습니다.\n'
                        '카메라 권한을 확인해주세요.',
                    textAlign:
                    TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ),

          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                color: Colors.black.withValues(
                  alpha: 0.18,
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.fromLTRB(
                24,
                20,
                24,
                28,
              ),
              child: Column(
                children: [
                  Text(
                    nextPoint == null
                        ? '모든 단서를 발견했습니다.'
                        : '$current / $total · '
                        '${nextPoint.title}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const Spacer(),

                  Container(
                    width: 250,
                    height: 250,
                    decoration:
                    BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(
                        28,
                      ),
                      border: Border.all(
                        width: 3,
                        color:
                        AppColors.softYellow,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.qr_code_2,
                        size: 70,
                        color: Colors.white38,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'QR 코드를 프레임 안에 맞춰주세요.',
                    textAlign:
                    TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                      FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    '현재 순서에 맞는 단서만 기록됩니다.',
                    textAlign:
                    TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      _ScannerButton(
                        icon:
                        Icons.flashlight_on,
                        label: '플래시',
                        onPressed: () {
                          unawaited(
                            _toggleTorch(),
                          );
                        },
                      ),
                      const SizedBox(width: 22),
                      _ScannerButton(
                        icon:
                        Icons.cameraswitch,
                        label: '카메라',
                        onPressed: () {
                          unawaited(
                            _switchCamera(),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerButton
    extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ScannerButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.white.withValues(
            alpha: 0.15,
          ),
          shape: const CircleBorder(),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}