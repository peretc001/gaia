import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gaia/database_services.dart';
import 'package:gaia/features/calendar/models/models.dart';

class AddEventDialog extends StatefulWidget {
  final DateTime selectedDate;
  final Function(Event) onEventAdded;

  const AddEventDialog({
    super.key,
    required this.selectedDate,
    required this.onEventAdded,
  });

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();

  static void show(
    BuildContext context,
    DateTime selectedDate,
    Function(Event) onEventAdded,
  ) {
    showDialog(
      context: context,
      builder: (context) => AddEventDialog(
        selectedDate: selectedDate,
        onEventAdded: onEventAdded,
      ),
    );
  }
}

class _AddEventDialogState extends State<AddEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(hours: 1));
  String _selectedType = 'Телемост';
  bool _isLoading = false;

  final List<String> _eventTypes = ['Телемост', 'Встреча', 'Другое'];

  @override
  void initState() {
    super.initState();
    // Устанавливаем время начала на выбранную дату с текущим временем
    final now = DateTime.now();
    _startTime = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
      now.hour,
      now.minute,
    );
    _endTime = _startTime.add(const Duration(hours: 1));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startTime),
    );
    if (picked != null) {
      setState(() {
        _startTime = DateTime(
          widget.selectedDate.year,
          widget.selectedDate.month,
          widget.selectedDate.day,
          picked.hour,
          picked.minute,
        );
        // Автоматически устанавливаем время окончания на час позже
        _endTime = _startTime.add(const Duration(hours: 1));
      });
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_endTime),
    );
    if (picked != null) {
      setState(() {
        _endTime = DateTime(
          widget.selectedDate.year,
          widget.selectedDate.month,
          widget.selectedDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_endTime.isBefore(_startTime) ||
        _endTime.isAtSameMomentAs(_startTime)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Время окончания должно быть позже времени начала'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ошибка: пользователь не авторизован'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Генерируем уникальный ID для события
      final eventId = DateTime.now().millisecondsSinceEpoch.toString();

      final event = Event(
        id: eventId,
        title: _titleController.text.trim(),
        startTime: _startTime,
        endTime: _endTime,
        description: _descriptionController.text.trim(),
        type: _selectedType,
        location: _locationController.text.trim().isEmpty
            ? null
            : _locationController.text.trim(),
      );

      // Сохраняем событие в базу данных
      final path = 'users/${user.uid}/calendar/events/$eventId';
      await DatabaseServices().create(path: path, data: event.toMap());

      if (mounted) {
        widget.onEventAdded(event);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Событие успешно добавлено'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при сохранении: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Заголовок
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Добавить событие',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Название события
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Название события *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введите название события';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Тип события
                DropdownButtonFormField<String>(
                  initialValue: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Тип события',
                    border: OutlineInputBorder(),
                  ),
                  items: _eventTypes.map((type) {
                    return DropdownMenuItem(value: type, child: Text(type));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedType = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                // Время начала
                InkWell(
                  onTap: _isLoading ? null : _selectStartTime,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Время начала *',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    child: Text(
                      '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Время окончания
                InkWell(
                  onTap: _isLoading ? null : _selectEndTime,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Время окончания *',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.access_time),
                    ),
                    child: Text(
                      '${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Описание
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Описание *',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Введите описание события';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Место
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Место (необязательно)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                // Кнопки
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: const Text('Отмена'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: const Text('Добавить'),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
