import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/navigation/home_navigation_action.dart';
import '../../core/theme/app_colors.dart';
import '../../data/repositories/local_repository.dart';
import '../../data/services/media_storage_service.dart';
import 'visit_card_page.dart';

class JournalWritePage extends StatefulWidget {
  final String reservationId;

  const JournalWritePage({
    super.key,
    required this.reservationId,
  });

  @override
  State<JournalWritePage> createState() =>
      _JournalWritePageState();
}

class _JournalWritePageState
    extends State<JournalWritePage> {
  late final TextEditingController _reviewController;

  final ImagePicker _imagePicker = ImagePicker();

  final MediaStorageService _mediaStorage =
  MediaStorageService();

  String? _photoPath;

  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();

    final existing =
    LocalRepository.instance
        .journalEntryForReservation(
      widget.reservationId,
    );

    _reviewController = TextEditingController(
      text: existing?.oneLineReview ?? '',
    );

    _photoPath = existing?.photoPath;
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  bool get _hasPhoto {
    final path = _photoPath;

    if (path == null) {
      return false;
    }

    return File(path).existsSync();
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) {
      return;
    }

    setState(() {
      _isPickingImage = true;
    });

    try {
      final pickedFile =
      await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1800,
      );

      if (pickedFile == null) {
        return;
      }

      final oldPhotoPath = _photoPath;

      final savedPath =
      await _mediaStorage.savePickedImage(
        pickedFile.path,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _photoPath = savedPath;
      });

      // 기존 사진을 새로운 사진으로 교체한 경우
      // 이전 파일은 제거
      if (oldPhotoPath != null &&
          oldPhotoPath != savedPath) {
        await _mediaStorage.deleteImage(
          oldPhotoPath,
        );
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '사진을 불러오지 못했습니다: $error',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPickingImage = false;
        });
      }
    }
  }

  Future<void> _removeImage() async {
    final oldPath = _photoPath;

    setState(() {
      _photoPath = null;
    });

    await _mediaStorage.deleteImage(
      oldPath,
    );
  }

  void _save() {
    final review =
    _reviewController.text.trim();

    if (review.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            '한 줄 후기를 입력해주세요.',
          ),
        ),
      );

      return;
    }

    final entry =
    LocalRepository.instance
        .saveJournalEntry(
      reservationId:
      widget.reservationId,
      oneLineReview: review,
      photoPath: _photoPath,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => VisitCardPage(
          journalEntryId: entry.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repository =
        LocalRepository.instance;

    final reservation =
    repository.reservationById(
      widget.reservationId,
    );

    final program =
    repository.programById(
      reservation.programId,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor:
        AppColors.background,
        title: const Text(
          '기록하기',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.darkBrown,
          ),
        ),
        actions: const [
          HomeNavigationAction(
            warningTitle: '기록 작성을 중단할까요?',
            warningMessage:
                '아직 저장하지 않은 한 줄 후기와 변경사항은 사라질 수 있습니다. 홈으로 이동하면 다시 작성해야 할 수 있습니다.',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Text(
              '오늘의 경험을\n한 줄로 남겨보세요.',
              style: TextStyle(
                fontSize: 27,
                height: 1.3,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),

            const SizedBox(height: 26),

            Container(
              width: double.infinity,
              padding:
              const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.softYellow,
                borderRadius:
                BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    program.senseType,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight:
                      FontWeight.bold,
                      color:
                      AppColors.burgundy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    program.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight:
                      FontWeight.bold,
                      color:
                      AppColors.darkBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    program.location,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              '사진',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),

            const SizedBox(height: 10),

            GestureDetector(
              onTap:
              _isPickingImage
                  ? null
                  : _pickImage,
              child: Container(
                width: double.infinity,
                height: 190,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius:
                  BorderRadius.circular(20),
                  border: Border.all(
                    color:
                    Colors.grey.shade300,
                  ),
                ),
                child: _hasPhoto
                    ? ClipRRect(
                  borderRadius:
                  BorderRadius.circular(
                    19,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(
                        File(_photoPath!),
                        fit: BoxFit.cover,
                      ),

                      Positioned(
                        top: 10,
                        right: 10,
                        child: Material(
                          color:
                          Colors.black54,
                          shape:
                          const CircleBorder(),
                          child: IconButton(
                            onPressed:
                            _removeImage,
                            icon:
                            const Icon(
                              Icons.close,
                              color:
                              Colors.white,
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        left: 12,
                        bottom: 12,
                        child: Container(
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration:
                          BoxDecoration(
                            color:
                            Colors.black54,
                            borderRadius:
                            BorderRadius
                                .circular(20),
                          ),
                          child:
                          const Text(
                            '눌러서 사진 변경',
                            style: TextStyle(
                              fontSize: 11,
                              color:
                              Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : Center(
                  child: _isPickingImage
                      ? const Column(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 14,
                      ),
                      Text(
                        '사진을 불러오는 중입니다.',
                        style:
                        TextStyle(
                          color:
                          Colors.grey,
                        ),
                      ),
                    ],
                  )
                      : const Column(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      Icon(
                        Icons
                            .add_photo_alternate_outlined,
                        size: 44,
                        color:
                        AppColors
                            .burgundy,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '눌러서 체험 사진 추가',
                        style:
                        TextStyle(
                          fontWeight:
                          FontWeight
                              .bold,
                          color:
                          AppColors
                              .darkBrown,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '갤러리에서 사진을 선택할 수 있습니다.',
                        style:
                        TextStyle(
                          fontSize: 11,
                          color:
                          Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              '한 줄 후기',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBrown,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _reviewController,
              maxLength: 60,
              maxLines: 3,
              decoration: InputDecoration(
                hintText:
                '이 경험을 어떻게 기억하고 싶나요?',
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(18),
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
                onPressed: _save,
                child: const Text(
                  '기록 저장하기',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight:
                    FontWeight.bold,
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