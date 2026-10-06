class Program {
  final String id;
  final String roomLabel;
  final String senseType;
  final String title;
  final String location;
  final int durationMinutes;
  final int capacity;
  final String keyDescription;
  final String recoveryPoint;

  const Program({
    required this.id,
    required this.roomLabel,
    required this.senseType,
    required this.title,
    required this.location,
    required this.durationMinutes,
    required this.capacity,
    required this.keyDescription,
    required this.recoveryPoint,
  });
}