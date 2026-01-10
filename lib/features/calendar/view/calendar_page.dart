import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaia/database_services.dart';
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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _events = [];
          _isLoading = false;
        });
        return;
      }

      final path = 'users/${user.uid}/calendar/events';
      final snapshot = await DatabaseServices().read(path: path);

      if (snapshot != null && snapshot.value != null) {
        final eventsData = snapshot.value as Map<dynamic, dynamic>;
        final loadedEvents = <Event>[];

        eventsData.forEach((key, value) {
          try {
            if (value is Map) {
              final eventMap = Map<String, dynamic>.from(value);
              final event = Event.fromMap(eventMap);
              loadedEvents.add(event);
            }
          } catch (e) {
            print('Ошибка при загрузке события $key: $e');
          }
        });

        setState(() {
          _events = loadedEvents;
          _isLoading = false;
        });
      } else {
        setState(() {
          _events = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Ошибка при загрузке событий: $e');
      setState(() {
        _events = [];
        _isLoading = false;
      });
    }
  }

  void _handleEventAdded(Event event) {
    setState(() {
      _events = [..._events, event];
    });
  }

  List<Event> _getEventsForSelectedDate() {
    if (_selectedDate == null) return [];
    return _events.where((event) => event.isOnDate(_selectedDate!)).toList();
  }

  String getCurrentDateString(DateTime? date) {
    if (date == null) return '';

    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day.$month.$year';
  }

  void _handleDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  void _handleEventTap(Event event) {
    EventDetailDialog.show(context, event);
  }

  void _handleAddEvent() {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Выберите дату для добавления события'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    AddEventDialog.show(context, _selectedDate!, _handleEventAdded);
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
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок с кнопкой добавления
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (selectedDateEvents.isNotEmpty)
                          Text(
                            'События на ${getCurrentDateString(_selectedDate)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        else
                          const Text(
                            'События',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _handleAddEvent,
                          tooltip: 'Добавить событие',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : selectedDateEvents.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Нет событий на выбранный день',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: _handleAddEvent,
                                        icon: const Icon(Icons.add),
                                        label: const Text('Добавить событие'),
                                      ),
                                    ),
                                  ),
                                ],
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
