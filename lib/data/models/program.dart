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
  final List<String> preparationItems;
  final String preparationNotice;

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
    this.preparationItems = const [],
    this.preparationNotice =
        '프로그램별 준비물은 운영 내용이 확정되는 대로 예약자에게 안내됩니다.',
  });
}
