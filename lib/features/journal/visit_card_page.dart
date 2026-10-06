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
      final renderObject =
          _cardKey.currentContext?.findRenderObject();

      if (renderObject is! RenderRepaintBoundary) {
        throw Exception(
          '방문 카드 이미지를 찾을 수 없습니다.',
        );
      }

      final ui.Image image =
          await renderObject.toImage(
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

      Rect? sharePositionOrigin;

      final box = context.findRenderObject();

      if (box is RenderBox) {
        sharePositionOrigin =
            box.localToGlobal(Offset.zero) &
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
    final repository = LocalRepository.instance;

    final entry = repository.journalEntryById(
      widget.journalEntryId,
    );

    final program =
        repository.programById(entry.programId);

    final hasPhoto =
        entry.photoPath != null &&
        File(entry.photoPath!).existsSync();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          '방문 카드',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar:
          const HomeNavigationBottomBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          20,
          8,
          20,
          30,
        ),
        child: Column(
          children: [
            RepaintBoundary(
              key: _cardKey,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.burgundy,
                  borderRadius:
                      BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.10,
                      ),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.fromLTRB(
                        22,
                        24,
                        22,
                        20,
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.auto_awesome_outlined,
                            size: 18,
                            color: AppColors.softYellow,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'THE FIRST WITNESS',
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 1.2,
                                fontWeight:
                                    FontWeight.bold,
                                color:
                                    AppColors.softYellow,
                              ),
                            ),
                          ),
                          Text(
                            'VISIT CARD',
                            style: TextStyle(
                              fontSize: 9,
                              letterSpacing: 1.0,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (hasPhoto)
                      Image.file(
                        File(entry.photoPath!),
                        width: double.infinity,
                        height: 235,
                        fit: BoxFit.cover,
                      )
                    else
                      Container(
                        width: double.infinity,
                        height: 190,
                        color: AppColors.darkBrown,
                        child: const Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.spa_outlined,
                              size: 56,
                              color: AppColors.white,
                            ),
                            SizedBox(height: 12),
                            Text(
                              '체험 사진 없음',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(
                        22,
                        24,
                        22,
                        28,
                      ),
                      child: Column(
                        children: [
                          Text(
                            program.roomLabel,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              letterSpacing: 0.7,
                              color:
                                  AppColors.softYellow,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            program.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 28,
                              height: 1.15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            '${program.senseType} · '
                            '${program.location}',
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 22),
                          Container(
                            width: double.infinity,
                            padding:
                                const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.format_quote,
                                  size: 24,
                                  color:
                                      AppColors.burgundy,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  entry.oneLineReview,
                                  textAlign:
                                      TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    height: 1.55,
                                    fontWeight:
                                        FontWeight.bold,
                                    color:
                                        AppColors.darkBrown,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 14,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                '기록일 '
                                '${_formatDate(entry.createdAt)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 22),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.softYellow,
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 19,
                    color: AppColors.burgundy,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '방문 카드는 현재 화면 그대로 PNG 이미지로 만들어 공유됩니다.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        color: AppColors.darkBrown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
