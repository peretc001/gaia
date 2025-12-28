import 'package:flutter/material.dart';
import 'package:gaia/features/calendar/models/models.dart';
import 'package:gaia/features/calendar/widgets/widgets.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? _selectedDate;
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadEvents();
  }

  void _loadEvents() {
    // Пример данных событий (как на скриншоте для 30 декабря)
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;
    
    _events = [
      // События на 30 число текущего месяца (как на скриншоте)
      Event(
        id: '1',
        title: 'Daily meeting Run',
        startTime: DateTime(currentYear, currentMonth, 30, 10, 0),
        endTime: DateTime(currentYear, currentMonth, 30, 10, 30),
        description: 'Ежедневная встреча команды для обсуждения текущих задач и прогресса проекта.',
        type: 'Телемост',
      ),
      Event(
        id: '2',
        title: 'Daily',
        startTime: DateTime(currentYear, currentMonth, 30, 10, 30),
        endTime: DateTime(currentYear, currentMonth, 30, 11, 0),
        description: 'Ежедневная синхронизация команды разработки.',
        type: 'Телемост',
      ),
      Event(
        id: '3',
        title: 'Sprint Retrospective Run',
        startTime: DateTime(currentYear, currentMonth, 30, 14, 0),
        endTime: DateTime(currentYear, currentMonth, 30, 15, 0),
        description: 'Ретроспектива спринта для анализа проделанной работы и планирования улучшений.',
        type: 'Телемост',
      ),
      // События для других дней для демонстрации индикаторов
      Event(
        id: '4',
        title: 'Планирование',
        startTime: DateTime(currentYear, currentMonth, 1, 9, 0),
        endTime: DateTime(currentYear, currentMonth, 1, 10, 0),
        description: 'Планирование задач на месяц.',
        type: 'Встреча',
      ),
      Event(
        id: '5',
        title: 'Code Review',
        startTime: DateTime(currentYear, currentMonth, 1, 15, 0),
        endTime: DateTime(currentYear, currentMonth, 1, 16, 0),
        description: 'Обзор кода.',
        type: 'Телемост',
      ),
      Event(
        id: '6',
        title: 'Встреча с клиентом',
        startTime: DateTime(currentYear, currentMonth, 4, 11, 0),
        endTime: DateTime(currentYear, currentMonth, 4, 12, 0),
        description: 'Встреча с клиентом для обсуждения требований.',
        type: 'Телемост',
      ),
      Event(
        id: '7',
        title: 'Тестирование',
        startTime: DateTime(currentYear, currentMonth, 4, 14, 0),
        endTime: DateTime(currentYear, currentMonth, 4, 15, 0),
        description: 'Тестирование новой функциональности.',
        type: 'Встреча',
      ),
      Event(
        id: '8',
        title: 'Стендап',
        startTime: DateTime(currentYear, currentMonth, 10, 9, 0),
        endTime: DateTime(currentYear, currentMonth, 10, 9, 30),
        description: 'Ежедневный стендап команды.',
        type: 'Телемост',
      ),
      Event(
        id: '9',
        title: 'Демо',
        startTime: DateTime(currentYear, currentMonth, 12, 13, 0),
        endTime: DateTime(currentYear, currentMonth, 12, 14, 0),
        description: 'Демонстрация новой функциональности.',
        type: 'Телемост',
      ),
      Event(
        id: '10',
        title: 'Ревью',
        startTime: DateTime(currentYear, currentMonth, 12, 15, 0),
        endTime: DateTime(currentYear, currentMonth, 12, 16, 0),
        description: 'Ревью кода.',
        type: 'Встреча',
      ),
      Event(
        id: '11',
        title: 'Планирование спринта',
        startTime: DateTime(currentYear, currentMonth, 15, 10, 0),
        endTime: DateTime(currentYear, currentMonth, 15, 11, 0),
        description: 'Планирование задач на следующий спринт.',
        type: 'Телемост',
      ),
      Event(
        id: '12',
        title: 'Ретроспектива',
        startTime: DateTime(currentYear, currentMonth, 15, 14, 0),
        endTime: DateTime(currentYear, currentMonth, 15, 15, 0),
        description: 'Ретроспектива спринта.',
        type: 'Встреча',
      ),
      Event(
        id: '13',
        title: 'Обучение',
        startTime: DateTime(currentYear, currentMonth, 16, 10, 0),
        endTime: DateTime(currentYear, currentMonth, 16, 12, 0),
        description: 'Обучение новой технологии.',
        type: 'Телемост',
      ),
      Event(
        id: '14',
        title: 'Встреча',
        startTime: DateTime(currentYear, currentMonth, 20, 11, 0),
        endTime: DateTime(currentYear, currentMonth, 20, 12, 0),
        description: 'Встреча команды.',
        type: 'Телемост',
      ),
      Event(
        id: '15',
        title: 'Событие',
        startTime: DateTime(currentYear, currentMonth, 27, 14, 0),
        endTime: DateTime(currentYear, currentMonth, 27, 15, 0),
        description: 'Событие.',
        type: 'Встреча',
      ),
      Event(
        id: '16',
        title: 'Встреча',
        startTime: DateTime(currentYear, currentMonth, 29, 9, 0),
        endTime: DateTime(currentYear, currentMonth, 29, 10, 0),
        description: 'Встреча.',
        type: 'Телемост',
      ),
      Event(
        id: '17',
        title: 'Событие',
        startTime: DateTime(currentYear, currentMonth, 29, 11, 0),
        endTime: DateTime(currentYear, currentMonth, 29, 12, 0),
        description: 'Событие.',
        type: 'Встреча',
      ),
      Event(
        id: '18',
        title: 'Встреча',
        startTime: DateTime(currentYear, currentMonth, 31, 10, 0),
        endTime: DateTime(currentYear, currentMonth, 31, 11, 0),
        description: 'Встреча.',
        type: 'Телемост',
      ),
    ];
  }

  List<Event> _getEventsForSelectedDate() {
    if (_selectedDate == null) return [];
    return _events.where((event) => event.isOnDate(_selectedDate!)).toList();
  }

  void _handleDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _handleEventTap(Event event) {
    EventDetailDialog.show(context, event);
  }

  @override
  Widget build(BuildContext context) {
    final selectedDateEvents = _getEventsForSelectedDate();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Календарь
            Expanded(
              flex: 2,
              child: CalendarWidget(
                selectedDate: _selectedDate,
                events: _events,
                onDateSelected: _handleDateSelected,
              ),
            ),
            // Список событий
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (selectedDateEvents.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        'События на ${_selectedDate?.day}.${_selectedDate?.month}.${_selectedDate?.year}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Expanded(
                    child: selectedDateEvents.isEmpty
                        ? Center(
                            child: Text(
                              'Нет событий на выбранный день',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          )
                        : EventList(
                            events: selectedDateEvents,
                            onEventTap: _handleEventTap,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

