class Reservation {
  final String id;
  final String programId;
  final String sessionId;
  final int guestCount;
  final DateTime createdAt;
  final bool checkedIn;

  const Reservation({
    required this.id,
    required this.programId,
    required this.sessionId,
    required this.guestCount,
    required this.createdAt,
    required this.checkedIn,
  });

  Reservation copyWith({
    int? guestCount,
    bool? checkedIn,
  }) {
    return Reservation(
      id: id,
      programId: programId,
      sessionId: sessionId,
      guestCount: guestCount ?? this.guestCount,
      createdAt: createdAt,
      checkedIn: checkedIn ?? this.checkedIn,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'programId': programId,
      'sessionId': sessionId,
      'guestCount': guestCount,
      'createdAt': createdAt.toIso8601String(),
      'checkedIn': checkedIn,
    };
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] as String,
      programId: json['programId'] as String,
      sessionId: json['sessionId'] as String,
      guestCount: json['guestCount'] as int,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      checkedIn: json['checkedIn'] as bool,
    );
  }
}