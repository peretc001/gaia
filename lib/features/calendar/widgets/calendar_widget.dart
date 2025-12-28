import 'package:flutter/material.dart';
import 'package:gaia/features/calendar/models/models.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime? selectedDate;
  final List<Event> events;
  final Function(DateTime) onDateSelected;

  const CalendarWidget({
    super.key,
    this.selectedDate,
    required this.events,
    required this.onDateSelected,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _selectedDate;
  late PageController _pageController;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    _pageController = PageController(
      initialPage: _getInitialPageIndex(),
    );
  }

  @override
  void didUpdateWidget(CalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDate != oldWidget.selectedDate && widget.selectedDate != null) {
      _selectedDate = widget.selectedDate!;
      final newMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
      if (newMonth.year != _currentMonth.year || newMonth.month != _currentMonth.month) {
        _currentMonth = newMonth;
        final newPageIndex = _getPageIndexForMonth(newMonth);
        _pageController.jumpToPage(newPageIndex);
      }
    }
  }

  int _getPageIndexForMonth(DateTime month) {
    final baseYear = 2020;
    final baseMonth = 1;
    final monthsDiff = (month.year - baseYear) * 12 + (month.month - baseMonth);
    return monthsDiff;
  }

  int _getInitialPageIndex() {
    final now = DateTime.now();
    final monthsDiff = (now.year - 2020) * 12 + (now.month - 1);
    return monthsDiff;
  }

  DateTime _getMonthFromIndex(int index) {
    final baseYear = 2020;
    final baseMonth = 1;
    final totalMonths = index;
    final year = baseYear + (totalMonths ~/ 12);
    final month = (totalMonths % 12) + 1;
    return DateTime(year, month, 1);
  }

  List<Event> _getEventsForDate(DateTime date) {
    return widget.events.where((event) => event.isOnDate(date)).toList();
  }

  List<Color> _getEventIndicatorColors(List<Event> events) {
    if (events.isEmpty) return [];
    // Разные цвета для разных событий
    const colors = [
      Color(0xFF87CEEB), // Light blue
      Color(0xFFFFB6C1), // Light pink
      Color(0xFFFFFF00), // Yellow
    ];
    return events.take(3).map((e) => colors[events.indexOf(e) % colors.length]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Заголовок месяца
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getMonthName(_currentMonth),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        // Календарная сетка
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            onPageChanged: (index) {
              setState(() {
                _currentMonth = _getMonthFromIndex(index);
              });
            },
            itemBuilder: (context, index) {
              final month = _getMonthFromIndex(index);
              return _buildMonthCalendar(month);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMonthCalendar(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final firstDayOfWeek = firstDay.weekday; // 1 = Monday, 7 = Sunday
    final daysInMonth = lastDay.day;

    // Названия дней недели
    final weekDays = ['П', 'В', 'С', 'Ч', 'П', 'С', 'В'];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Заголовки дней недели
          Row(
            children: weekDays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Календарная сетка
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: 42, // 6 недель * 7 дней
              itemBuilder: (context, index) {
                final dayOffset = index - (firstDayOfWeek - 1);
                if (dayOffset < 0 || dayOffset >= daysInMonth) {
                  return const SizedBox.shrink();
                }

                final day = dayOffset + 1;
                final date = DateTime(month.year, month.month, day);
                final isSelected = _selectedDate.year == date.year &&
                    _selectedDate.month == date.month &&
                    _selectedDate.day == date.day;
                final isWeekend = date.weekday == 6 || date.weekday == 7;
                final isToday = date.year == DateTime.now().year &&
                    date.month == DateTime.now().month &&
                    date.day == DateTime.now().day;
                final dayEvents = _getEventsForDate(date);
                final hasEvents = dayEvents.isNotEmpty;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                    widget.onDateSelected(date);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? Colors.black : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? Colors.white
                                : isWeekend
                                    ? Colors.grey[400]
                                    : isToday
                                        ? Colors.red
                                        : Colors.black,
                          ),
                        ),
                        if (hasEvents)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            height: 6,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _getEventIndicatorColors(dayEvents)
                                  .take(3)
                                  .map((color) => Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 1),
                                        height: 3,
                                        width: 6,
                                        decoration: BoxDecoration(
                                          color: color,
                                          borderRadius: BorderRadius.circular(1.5),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(DateTime date) {
    const months = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь',
    ];
    return months[date.month - 1];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

