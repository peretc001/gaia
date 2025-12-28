class Event {
  final String id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String description;
  final String type; // 'Телемост', 'Встреча', etc.
  final String? location;

  Event({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.description,
    required this.type,
    this.location,
  });

  bool isOnDate(DateTime date) {
    return startTime.year == date.year &&
        startTime.month == date.month &&
        startTime.day == date.day;
  }

  String get timeRange {
    final start = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final end = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }
}

