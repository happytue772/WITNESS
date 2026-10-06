class ExplorationProgress {
  final String reservationId;
  final List<String> discoveredPointIds;
  final bool explorationCompleted;
  final bool experienceCompleted;

  const ExplorationProgress({
    required this.reservationId,
    required this.discoveredPointIds,
    required this.explorationCompleted,
    required this.experienceCompleted,
  });

  ExplorationProgress copyWith({
    List<String>? discoveredPointIds,
    bool? explorationCompleted,
    bool? experienceCompleted,
  }) {
    return ExplorationProgress(
      reservationId: reservationId,
      discoveredPointIds:
      discoveredPointIds ?? this.discoveredPointIds,
      explorationCompleted:
      explorationCompleted ?? this.explorationCompleted,
      experienceCompleted:
      experienceCompleted ?? this.experienceCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reservationId': reservationId,
      'discoveredPointIds': discoveredPointIds,
      'explorationCompleted': explorationCompleted,
      'experienceCompleted': experienceCompleted,
    };
  }

  factory ExplorationProgress.fromJson(
      Map<String, dynamic> json,
      ) {
    return ExplorationProgress(
      reservationId: json['reservationId'] as String,
      discoveredPointIds: List<String>.from(
        json['discoveredPointIds'] as List,
      ),
      explorationCompleted:
      json['explorationCompleted'] as bool,
      experienceCompleted:
      json['experienceCompleted'] as bool,
    );
  }
}