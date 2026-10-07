import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/exploration_point.dart';
import '../models/exploration_progress.dart';
import '../models/journal_entry.dart';
import '../models/program.dart';
import '../models/reservation.dart';
import '../models/session.dart';
import '../services/local_storage_service.dart';
import '../services/media_storage_service.dart';

class LocalRepository extends ChangeNotifier {
  LocalRepository._();

  static final LocalRepository instance =
  LocalRepository._();

  final LocalStorageService _storage =
  LocalStorageService();

  final MediaStorageService _mediaStorage =
  MediaStorageService();

  // ==================================================
  // 프로그램
  // ==================================================

  static const List<Program> programs = [
    Program(
      id: 'mist_tea',
      roomLabel: 'ROOM 01 · SIGHT',
      senseType: '시각',
      title: '안개 다도',
      location: '이끼원',
      durationMinutes: 50,
      capacity: 10,
      keyDescription:
      '안개 장치로 시선을 가까이 모으고, 격불·찻물소리 등 다도 ASMR로 몰입을 높인다.',
      recoveryPoint:
      '흩어진 시선을 한 지점에 모아 ‘천천히 바라보는 감각’을 되찾는다.',
      preparationNotice:
      '안개 다도 참여 준비물은 운영 내용이 확정되는 대로 예약자에게 안내됩니다.',
    ),
    Program(
      id: 'blind_yoga',
      roomLabel: 'ROOM 02 · TOUCH',
      senseType: '촉각',
      title: '블라인드 요가',
      location: '만병초원',
      durationMinutes: 50,
      capacity: 10,
      keyDescription:
      '안대로 시각을 차단하고, 강사의 안내에 따른 저강도 동작으로 바람, 지면, 몸의 감각에 집중한다.',
      recoveryPoint:
      '몸의 흔들림과 자연의 접촉을 느끼며 중심을 되찾는다.',
      preparationNotice:
      '블라인드 요가 참여 준비물은 운영 내용이 확정되는 대로 예약자에게 안내됩니다.',
    ),
    Program(
      id: 'aufguss_sauna_bus',
      roomLabel: 'ROOM 03 · SCENT',
      senseType: '후각',
      title: '아우프구스 사우나 버스',
      location: '사우나버스',
      durationMinutes: 40,
      capacity: 10,
      keyDescription:
      '사우나 스톤에 제이드가든만의 향을 활용한 아로마 물을 부어 증기를 퍼뜨리고 체험한다.',
      recoveryPoint:
      '열기로 긴장을 풀고, 향으로 감각을 깨워 깊은 이완에 이른다.',
      preparationNotice:
      '아우프구스 사우나 버스 참여 준비물은 운영 내용이 확정되는 대로 예약자에게 안내됩니다.',
    ),
  ];

  // ==================================================
  // DEMO 회차
  // ==================================================

  static const List<Session> demoSessions = [
    Session(
      id: 'mist_tea_demo',
      programId: 'mist_tea',
      label: 'DEMO 회차',
      isDemo: true,
    ),
    Session(
      id: 'blind_yoga_demo',
      programId: 'blind_yoga',
      label: 'DEMO 회차',
      isDemo: true,
    ),
    Session(
      id: 'aufguss_demo',
      programId: 'aufguss_sauna_bus',
      label: 'DEMO 회차',
      isDemo: true,
    ),
  ];

  // ==================================================
  // DEMO 탐색 지점
  // ==================================================

  static const List<ExplorationPoint>
  demoExplorationPoints = [
    ExplorationPoint(
      id: 'demo_point_1',
      order: 1,
      title: '첫 번째 단서',
      isFinal: false,
    ),
    ExplorationPoint(
      id: 'demo_point_2',
      order: 2,
      title: '두 번째 단서',
      isFinal: false,
    ),
    ExplorationPoint(
      id: 'demo_point_3',
      order: 3,
      title: '마지막 단서',
      isFinal: true,
    ),
  ];

  // ==================================================
  // 예약 데이터
  // ==================================================

  final List<Reservation> _reservations = [];

  List<Reservation> get reservations {
    return List.unmodifiable(_reservations);
  }

  // ==================================================
  // 후기 데이터
  // ==================================================

  final List<JournalEntry> _journalEntries = [];

  List<JournalEntry> get journalEntries {
    return List.unmodifiable(_journalEntries);
  }

  // ==================================================
  // 탐색 진행 데이터
  // ==================================================

  final Map<String, ExplorationProgress>
  _explorationProgressByReservation = {};

  // ==================================================
  // 앱 시작 시 저장 데이터 복원
  // ==================================================

  Future<void> initialize() async {
    try {
      final state = await _storage.loadState();

      if (state == null) {
        return;
      }

      final reservationsJson =
          state['reservations'] as List<dynamic>? ?? [];

      final progressesJson =
          state['progresses'] as List<dynamic>? ?? [];

      final journalsJson =
          state['journals'] as List<dynamic>? ?? [];

      // 예약 복원
      _reservations.clear();

      for (final item in reservationsJson) {
        final reservation = Reservation.fromJson(
          Map<String, dynamic>.from(
            item as Map,
          ),
        );

        _reservations.add(
          reservation.guestCount == 1
              ? reservation
              : reservation.copyWith(
                  guestCount: 1,
                ),
        );
      }

      // 탐색 진행 상태 복원
      _explorationProgressByReservation.clear();

      for (final item in progressesJson) {
        final progress =
        ExplorationProgress.fromJson(
          Map<String, dynamic>.from(
            item as Map,
          ),
        );

        _explorationProgressByReservation[
        progress.reservationId] = progress;
      }

      // 후기 복원
      _journalEntries.clear();

      for (final item in journalsJson) {
        final journalEntry =
        JournalEntry.fromJson(
          Map<String, dynamic>.from(
            item as Map,
          ),
        );

        _journalEntries.add(journalEntry);
      }
    } catch (error) {
      debugPrint(
        '저장된 앱 상태를 복원하지 못했습니다: $error',
      );

      _reservations.clear();
      _journalEntries.clear();
      _explorationProgressByReservation.clear();
    }
  }

  // ==================================================
  // 프로그램 조회
  // ==================================================

  Program programById(String id) {
    return programs.firstWhere(
          (program) => program.id == id,
    );
  }

  Session sessionById(String id) {
    return demoSessions.firstWhere(
          (session) => session.id == id,
    );
  }

  Session demoSessionForProgram(
      String programId,
      ) {
    return demoSessions.firstWhere(
          (session) => session.programId == programId,
    );
  }

  // ==================================================
  // 예약 조회
  // ==================================================

  Reservation reservationById(String id) {
    return _reservations.firstWhere(
          (reservation) => reservation.id == id,
    );
  }

  // ==================================================
  // DEMO 예약 생성
  // ==================================================

  Reservation createDemoReservation({
    required Program program,
  }) {
    final session =
    demoSessionForProgram(program.id);

    final reservation = Reservation(
      id: 'demo_${DateTime.now().microsecondsSinceEpoch}',
      programId: program.id,
      sessionId: session.id,
      guestCount: 1,
      createdAt: DateTime.now(),
      checkedIn: false,
    );

    _reservations.add(reservation);

    _explorationProgressByReservation[
    reservation.id] = ExplorationProgress(
      reservationId: reservation.id,
      discoveredPointIds: const [],
      explorationCompleted: false,
      experienceCompleted: false,
    );

    notifyListeners();
    _schedulePersist();

    return reservation;
  }

  // ==================================================
  // 예약 삭제
  // 연결된 탐색 진행 / 후기 / 후기 사진도 함께 정리
  // ==================================================

  Future<bool> deleteReservation(
      String reservationId,
      ) async {
    final reservationIndex = _reservations.indexWhere(
          (reservation) => reservation.id == reservationId,
    );

    if (reservationIndex == -1) {
      return false;
    }

    final reservation = _reservations[reservationIndex];

    final progress =
        _explorationProgressByReservation[reservationId];

    final journalIndex = _journalEntries.indexWhere(
          (entry) => entry.reservationId == reservationId,
    );

    final journalEntry = journalIndex == -1
        ? null
        : _journalEntries[journalIndex];

    _reservations.removeAt(reservationIndex);
    _explorationProgressByReservation.remove(reservationId);

    if (journalIndex != -1) {
      _journalEntries.removeAt(journalIndex);
    }

    notifyListeners();

    try {
      await _persistState();
    } catch (error) {
      _reservations.insert(
        reservationIndex,
        reservation,
      );

      if (progress != null) {
        _explorationProgressByReservation[
        reservationId] = progress;
      }

      if (journalEntry != null) {
        _journalEntries.insert(
          journalIndex,
          journalEntry,
        );
      }

      notifyListeners();
      rethrow;
    }

    try {
      await _mediaStorage.deleteImage(
        journalEntry?.photoPath,
      );
    } catch (error) {
      debugPrint(
        '예약 삭제 후 후기 사진 정리에 실패했습니다: $error',
      );
    }

    return true;
  }

  // ==================================================
  // 체크인
  // ==================================================

  void checkIn(String reservationId) {
    final index = _reservations.indexWhere(
          (reservation) =>
      reservation.id == reservationId,
    );

    if (index == -1) {
      return;
    }

    _reservations[index] =
        _reservations[index].copyWith(
          checkedIn: true,
        );

    notifyListeners();
    _schedulePersist();
  }

  Reservation? get latestCheckedInReservation {
    final checkedInReservations =
    _reservations.where(
          (reservation) => reservation.checkedIn,
    ).toList();

    if (checkedInReservations.isEmpty) {
      return null;
    }

    return checkedInReservations.last;
  }

  // ==================================================
  // 탐색 진행 상태 조회
  // ==================================================

  ExplorationProgress progressForReservation(
      String reservationId,
      ) {
    return _explorationProgressByReservation
        .putIfAbsent(
      reservationId,
          () => ExplorationProgress(
        reservationId: reservationId,
        discoveredPointIds: const [],
        explorationCompleted: false,
        experienceCompleted: false,
      ),
    );
  }

  // ==================================================
  // 현재 찾아야 할 단서
  // ==================================================

  ExplorationPoint? nextPointForReservation(
      String reservationId,
      ) {
    final progress =
    progressForReservation(reservationId);

    final discoveredCount =
        progress.discoveredPointIds.length;

    if (discoveredCount >=
        demoExplorationPoints.length) {
      return null;
    }

    return demoExplorationPoints[
    discoveredCount];
  }

  // ==================================================
  // DEMO QR 발견
  // ==================================================

  bool discoverDemoPoint({
    required String reservationId,
    required String pointId,
  }) {
    final progress =
    progressForReservation(reservationId);

    if (progress.explorationCompleted) {
      return false;
    }

    final nextPoint =
    nextPointForReservation(
      reservationId,
    );

    if (nextPoint == null) {
      return false;
    }

    // 현재 순서의 QR만 인정
    if (nextPoint.id != pointId) {
      return false;
    }

    final updatedIds = [
      ...progress.discoveredPointIds,
      pointId,
    ];

    final explorationCompleted =
        updatedIds.length ==
            demoExplorationPoints.length;

    _explorationProgressByReservation[
    reservationId] = progress.copyWith(
      discoveredPointIds: updatedIds,
      explorationCompleted:
      explorationCompleted,
    );

    notifyListeners();
    _schedulePersist();

    return true;
  }

  // ==================================================
  // 체험 완료
  // ==================================================

  void completeExperience(
      String reservationId,
      ) {
    final progress =
    progressForReservation(reservationId);

    // 탐색이 끝나기 전에는 체험 완료 불가능
    if (!progress.explorationCompleted) {
      return;
    }

    _explorationProgressByReservation[
    reservationId] = progress.copyWith(
      experienceCompleted: true,
    );

    notifyListeners();
    _schedulePersist();
  }

  // ==================================================
  // 후기 저장
  // ==================================================

  JournalEntry saveJournalEntry({
    required String reservationId,
    required String oneLineReview,
    required String? photoPath,
  }) {
    final reservation =
    reservationById(reservationId);

    final existingIndex =
    _journalEntries.indexWhere(
          (entry) =>
      entry.reservationId == reservationId,
    );

    final journalEntry = JournalEntry(
      id: existingIndex == -1
          ? 'journal_${DateTime.now().microsecondsSinceEpoch}'
          : _journalEntries[existingIndex].id,
      reservationId: reservationId,
      programId: reservation.programId,
      oneLineReview: oneLineReview,
      createdAt: existingIndex == -1
          ? DateTime.now()
          : _journalEntries[existingIndex]
          .createdAt,
      photoPath: photoPath,
    );

    if (existingIndex == -1) {
      _journalEntries.add(
        journalEntry,
      );
    } else {
      _journalEntries[existingIndex] =
          journalEntry;
    }

    notifyListeners();
    _schedulePersist();

    return journalEntry;
  }

  // ==================================================
  // 예약에 연결된 후기 조회
  // ==================================================

  JournalEntry? journalEntryForReservation(
      String reservationId,
      ) {
    for (final entry in _journalEntries) {
      if (entry.reservationId ==
          reservationId) {
        return entry;
      }
    }

    return null;
  }

  // ==================================================
  // 후기 ID 조회
  // ==================================================

  JournalEntry journalEntryById(String id) {
    return _journalEntries.firstWhere(
          (entry) => entry.id == id,
    );
  }

  // ==================================================
  // 전체 상태 저장
  // ==================================================

  Future<void> _persistState() async {
    await _storage.saveState({
      'reservations': _reservations
          .map(
            (reservation) =>
            reservation.toJson(),
      )
          .toList(),

      'progresses':
      _explorationProgressByReservation
          .values
          .map(
            (progress) =>
            progress.toJson(),
      )
          .toList(),

      'journals': _journalEntries
          .map(
            (entry) => entry.toJson(),
      )
          .toList(),
    });
  }

  void _schedulePersist() {
    unawaited(
      _persistState(),
    );
  }

  // ==================================================
  // 개발용 전체 데이터 초기화
  // 나중에 테스트용 버튼에서 사용 가능
  // ==================================================

  Future<void> clearAllLocalData() async {
    _reservations.clear();
    _journalEntries.clear();
    _explorationProgressByReservation.clear();

    await _storage.clearState();

    notifyListeners();
  }
}