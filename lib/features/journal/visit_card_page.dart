import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/navigation/home_navigation_action.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/local_repository.dart';

class VisitCardPage extends StatefulWidget {
  final String journalEntryId;

  const VisitCardPage({
    super.key,
    required this.journalEntryId,
  });

  @override
  State<VisitCardPage> createState() =>
      _VisitCardPageState();
}

class _VisitCardPageState extends State<VisitCardPage> {
  final GlobalKey _cardKey = GlobalKey();

  bool _isSharing = false;

  String _formatDate(DateTime date) {
    final month =
    date.month.toString().padLeft(2, '0');

    final day =
    date.day.toString().padLeft(2, '0');

    return '${date.year}.$month.$day';
  }

  Future<void> _shareVisitCard() async {
    if (_isSharing) {
      return;
    }

    setState(() {
      _isSharing = true;
    });

    try {
      // 방문 카드 위젯 찾기
      final renderObject =
      _cardKey.currentContext?.findRenderObject();

      if (renderObject is! RenderRepaintBoundary) {
        throw Exception(
          '방문 카드 이미지를 찾을 수 없습니다.',
        );
      }

      // 화면의 방문 카드를 PNG 이미지로 변환
      final ui.Image image = await renderObject.toImage(
        pixelRatio: 3.0,
      );

      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        throw Exception(
          '방문 카드 이미지 생성에 실패했습니다.',
        );
      }

      final pngBytes =
      byteData.buffer.asUint8List();

      // 임시 폴더
      final tempDirectory =
      await getTemporaryDirectory();

      final filePath =
          '${tempDirectory.path}/'
          'first_witness_visit_card_'
          '${DateTime.now().millisecondsSinceEpoch}.png';

      final file = File(filePath);

      await file.writeAsBytes(
        pngBytes,
        flush: true,
      );

      if (!mounted) {
        return;
      }

      // iPad/macOS 등에서 공유창 위치를 잡기 위한 영역
      Rect? sharePositionOrigin;

      final box =
      context.findRenderObject();

      if (box is RenderBox) {
        sharePositionOrigin =
        box.localToGlobal(
          Offset.zero,
        ) &
        box.size;
      }

      await SharePlus.instance.share(
        ShareParams(
          title: 'THE FIRST WITNESS',
          text: 'THE FIRST WITNESS에서 남긴 '
              '나의 회복 기록입니다.',
          files: [
            XFile(
              file.path,
              mimeType: 'image/png',
            ),
          ],
          sharePositionOrigin:
          sharePositionOrigin,
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '방문 카드 공유 중 문제가 발생했습니다.\n$error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository =
        LocalRepository.instance;

    final entry =
    repository.journalEntryById(
      widget.journalEntryId,
    );

    final program =
    repository.programById(
      entry.programId,
    );

    final hasPhoto =
        entry.photoPath != null &&
            File(entry.photoPath!).existsSync();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor:
        AppColors.background,
        title: const Text(
          '방문 카드',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkBrown,
          ),
        ),
        actions: const [
          HomeNavigationAction(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ==========================================
            // 공유할 방문 카드 영역
            // ==========================================
            RepaintBoundary(
              key: _cardKey,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  22,
                  30,
                  22,
                  30,
                ),
                decoration: BoxDecoration(
                  color: AppColors.burgundy,
                  borderRadius:
                  BorderRadius.circular(28),
                ),
                child: Column(
                  children: [
                    const Text(
                      'THE FIRST WITNESS',
                      style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 1.2,
                        fontWeight:
                        FontWeight.bold,
                        color:
                        AppColors.softYellow,
                      ),
                    ),

                    if (hasPhoto) ...[
                      const SizedBox(height: 24),

                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(
                          20,
                        ),
                        child: Image.file(
                          File(
                            entry.photoPath!,
                          ),
                          width:
                          double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],

                    const SizedBox(height: 26),

                    if (!hasPhoto)
                      const Icon(
                        Icons.spa_outlined,
                        size: 52,
                        color: AppColors.white,
                      ),

                    if (!hasPhoto)
                      const SizedBox(height: 22),

                    Text(
                      program.title,
                      textAlign:
                      TextAlign.center,
                      style: const TextStyle(
                        fontSize: 29,
                        fontWeight:
                        FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '${program.senseType} · '
                          '${program.location}',
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(height: 26),

                    Container(
                      width: double.infinity,
                      padding:
                      const EdgeInsets.all(
                        20,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                        BorderRadius.circular(
                          18,
                        ),
                      ),
                      child: Text(
                        '“${entry.oneLineReview}”',
                        textAlign:
                        TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.5,
                          fontWeight:
                          FontWeight.bold,
                          color:
                          AppColors.darkBrown,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    Text(
                      '기록일 '
                          '${_formatDate(entry.createdAt)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ==========================================
            // 실제 공유 버튼
            // ==========================================
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed:
                _isSharing
                    ? null
                    : _shareVisitCard,
                icon: _isSharing
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(
                  Icons.share_outlined,
                ),
                label: Text(
                  _isSharing
                      ? '방문 카드 만드는 중...'
                      : '방문 카드 공유하기',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              '방문 카드가 이미지로 만들어져 공유됩니다.',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}