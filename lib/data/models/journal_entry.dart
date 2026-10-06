class JournalEntry {
  final String id;
  final String reservationId;
  final String programId;
  final String oneLineReview;
  final DateTime createdAt;
  final String? photoPath;

  const JournalEntry({
    required this.id,
    required this.reservationId,
    required this.programId,
    required this.oneLineReview,
    required this.createdAt,
    this.photoPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reservationId': reservationId,
      'programId': programId,
      'oneLineReview': oneLineReview,
      'createdAt': createdAt.toIso8601String(),
      'photoPath': photoPath,
    };
  }

  factory JournalEntry.fromJson(
      Map<String, dynamic> json,
      ) {
    return JournalEntry(
      id: json['id'] as String,
      reservationId: json['reservationId'] as String,
      programId: json['programId'] as String,
      oneLineReview: json['oneLineReview'] as String,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      photoPath: json['photoPath'] as String?,
    );
  }
}