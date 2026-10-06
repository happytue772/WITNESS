import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/navigation/home_navigation_action.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/local_repository.dart';

class QrGalleryTestPage
    extends StatefulWidget {
  final String reservationId;

  const QrGalleryTestPage({
    super.key,
    required this.reservationId,
  });

  @override
  State<QrGalleryTestPage> createState() =>
      _QrGalleryTestPageState();
}

class _QrGalleryTestPageState
    extends State<QrGalleryTestPage> {
  final ImagePicker _imagePicker =
  ImagePicker();

  final MobileScannerController
  _imageAnalyzer =
  MobileScannerController(
    autoStart: false,
    formats: const [
      BarcodeFormat.qrCode,
    ],
  );

  bool _processing = false;

  Future<void> _pickAndAnalyze() async {
    if (_processing) {
      return;
    }

    setState(() {
      _processing = true;
    });

    try {
      final file =
      await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (file == null) {
        return;
      }

      final capture =
      await _imageAnalyzer.analyzeImage(
        file.path,
        formats: const [
          BarcodeFormat.qrCode,
        ],
      );

      if (!mounted) {
        return;
      }

      if (capture == null ||
          capture.barcodes.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              '선택한 이미지에서 QR을 찾지 못했습니다.',
            ),
          ),
        );

        return;
      }

      final rawValue =
          capture.barcodes.first.rawValue;

      if (rawValue == null ||
          rawValue.trim().isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'QR 값이 비어 있습니다.',
            ),
          ),
        );

        return;
      }

      final repository =
          LocalRepository.instance;

      final expectedPoint =
      repository.nextPointForReservation(
        widget.reservationId,
      );

      if (expectedPoint == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
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
        ScaffoldMessenger.of(context)
            .showSnackBar(
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
        reservationId:
        widget.reservationId,
        pointId: value,
      );

      if (!success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              '단서를 처리하지 못했습니다.',
            ),
          ),
        );

        return;
      }

      if (!mounted) {
        return;
      }

      final progress =
      repository.progressForReservation(
        widget.reservationId,
      );

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            backgroundColor:
            AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(24),
            ),
            title: Icon(
              progress.explorationCompleted
                  ? Icons.check_circle
                  : Icons.auto_awesome,
              size: 48,
              color: AppColors.burgundy,
            ),
            content: Text(
              progress.explorationCompleted
                  ? '모든 단서를 발견했습니다.'
                  : '${expectedPoint.title}를 찾았습니다.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 19,
                fontWeight:
                FontWeight.bold,
                color:
                AppColors.darkBrown,
              ),
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
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'QR 이미지 분석 중 오류가 발생했습니다.\n'
                '$error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _processing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    unawaited(
      _imageAnalyzer.dispose(),
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository =
        LocalRepository.instance;

    final nextPoint =
    repository.nextPointForReservation(
      widget.reservationId,
    );

    return Scaffold(
      backgroundColor:
      AppColors.background,
      appBar: AppBar(
        backgroundColor:
        AppColors.background,
        title: const Text(
          'QR 이미지 테스트',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkBrown,
          ),
        ),
        actions: const [
          HomeNavigationAction(
            warningTitle: 'QR 테스트를 중단할까요?',
            warningMessage:
                '홈으로 이동하면 현재 QR 이미지 분석 작업이 중단됩니다. 이미 발견한 단서는 유지되지만 아직 인식되지 않은 QR은 기록되지 않습니다.',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.qr_code_2,
                size: 90,
                color:
                AppColors.burgundy,
              ),

              const SizedBox(height: 24),

              Text(
                nextPoint == null
                    ? '모든 단서를 발견했습니다.'
                    : '현재 단서: '
                    '${nextPoint.title}',
                textAlign:
                TextAlign.center,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight:
                  FontWeight.bold,
                  color:
                  AppColors.darkBrown,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                '에뮬레이터 테스트 전용 화면입니다.\n'
                    '실제 서비스에서는 카메라 QR 스캔을 사용합니다.',
                textAlign:
                TextAlign.center,
                style: TextStyle(
                  height: 1.5,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed:
                  _processing
                      ? null
                      : _pickAndAnalyze,
                  icon: _processing
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child:
                    CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : const Icon(
                    Icons.image_outlined,
                  ),
                  label: Text(
                    _processing
                        ? 'QR 분석 중...'
                        : '갤러리에서 QR 선택',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}