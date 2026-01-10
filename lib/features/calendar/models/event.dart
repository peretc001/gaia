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

  // Сериализация для базы данных
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'description': description,
      'type': type,
      'location': location,
    };
  }

  // Десериализация из базы данных
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String,
      title: map['title'] as String,
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: DateTime.parse(map['endTime'] as String),
      description: map['description'] as String,
      type: map['type'] as String,
      location: map['location'] as String?,
    );
  }
}

