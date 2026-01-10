import 'package:flutter/material.dart';
import 'package:gaia/features/calendar/models/models.dart';

class EventList extends StatelessWidget {
  final List<Event> events;
  final Function(Event) onEventTap;

  const EventList({super.key, required this.events, required this.onEventTap});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return _EventItem(
          event: event,
          onTap: () => onEventTap(event),
          isHighlighted: index == 1, // Второе событие выделено как на скриншоте
        );
      },
    );
  }
}

class _EventItem extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;
  final bool isHighlighted;

  const _EventItem({
    required this.event,
    required this.onTap,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: isHighlighted
              ? const Color(0xFFE3F2FD).withValues(alpha: 0.5)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Синяя полоска слева
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            // Контент события
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Название события
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Иконка и тип события
                  Row(
                    children: [
                      const Icon(
                        Icons.videocam,
                        size: 16,
                        color: Color(0xFF2196F3),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.type,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Время
            Text(
              event.timeRange,
              style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
