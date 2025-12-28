import 'package:flutter/material.dart';
import 'package:gaia/features/calendar/models/models.dart';

class EventDetailDialog extends StatelessWidget {
  final Event event;

  const EventDetailDialog({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Тип события
            Row(
              children: [
                const Icon(
                  Icons.videocam,
                  size: 20,
                  color: Color(0xFF2196F3),
                ),
                const SizedBox(width: 8),
                Text(
                  event.type,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Время
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 20,
                  color: Color(0xFF666666),
                ),
                const SizedBox(width: 8),
                Text(
                  event.timeRange,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Дата
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Color(0xFF666666),
                ),
                const SizedBox(width: 8),
                Text(
                  '${event.startTime.day.toString().padLeft(2, '0')}.${event.startTime.month.toString().padLeft(2, '0')}.${event.startTime.year}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
            if (event.location != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 20,
                    color: Color(0xFF666666),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    event.location!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            // Описание
            const Text(
              'Описание:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 24),
            // Кнопка закрытия
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Закрыть'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void show(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (context) => EventDetailDialog(event: event),
    );
  }
}

