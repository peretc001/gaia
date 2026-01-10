import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gaia/database_services.dart';

class WizardPage extends StatefulWidget {
  const WizardPage({super.key});

  @override
  State<WizardPage> createState() => _WizardPageState();
}

class _WizardPageState extends State<WizardPage> {
  final _formKey = GlobalKey<FormState>();
  final _cycleDurationController = TextEditingController();
  final _menstruationDurationController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String _lastMenstruationDateText = '';
  bool _hasSubmitted = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 30));
    final DateTime lastDate = now;
    final DateTime initialDate = now;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      setState(() {
        _lastMenstruationDateText =
            '${picked.day.toString().padLeft(2, '0')}.${picked.month.toString().padLeft(2, '0')}.${picked.year}';
      });
      _resetFieldError();
    }
  }

  @override
  void dispose() {
    _cycleDurationController.dispose();
    _menstruationDurationController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    setState(() {
      _hasSubmitted = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        // Получение текущего пользователя
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ошибка: пользователь не авторизован'),
              ),
            );
          }
          return;
        }

        // Получение значений полей формы
        final lastMenstruationDate = _lastMenstruationDateText;
        final cycleDuration = int.tryParse(_cycleDurationController.text) ?? 0;
        final menstruationDuration =
            int.tryParse(_menstruationDurationController.text) ?? 0;
        final age = _ageController.text.isNotEmpty
            ? int.tryParse(_ageController.text)
            : null;
        final height = _heightController.text.isNotEmpty
            ? int.tryParse(_heightController.text)
            : null;
        final weight = _weightController.text.isNotEmpty
            ? int.tryParse(_weightController.text)
            : null;

        // Формирование данных для сохранения
        final body = <String, dynamic>{
          'lastMenstruationDate': lastMenstruationDate,
          'cycleDuration': cycleDuration,
          'menstruationDuration': menstruationDuration,
        };

        // Добавляем необязательные поля только если они заполнены
        if (age != null) body['age'] = age;
        if (height != null) body['height'] = height;
        if (weight != null) body['weight'] = weight;

        // Сохранение данных под пользователем
        final path = 'users/${user.uid}/wizard';
        await DatabaseServices().create(path: path, data: body);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Данные успешно сохранены'),
              backgroundColor: Colors.green,
            ),
          );
          // Переход на главную страницу после сохранения данных
          Navigator.of(context).pushReplacementNamed('/calendar');
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
      }
    }
  }

  void _resetFieldError() {
    if (_hasSubmitted) {
      _formKey.currentState?.validate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Иконка сердца
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_outline,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Заголовок
                Text(
                  'Настройка цикла',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Подзаголовок
                Text(
                  'Введите данные для персональных рекомендаций',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Дата начала последней менструации
                TextFormField(
                  readOnly: true,
                  controller: TextEditingController(
                    text: _lastMenstruationDateText,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Дата последней менструации',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, выберите дату';
                    }
                    return null;
                  },
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 16),
                // Продолжительность цикла
                TextFormField(
                  controller: _cycleDurationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Продолжительность цикла (дни)',
                  ),
                  onChanged: (_) => _resetFieldError(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите продолжительность цикла';
                    }
                    final days = int.tryParse(value);
                    if (days == null || days < 21 || days > 45) {
                      return 'Обычно от 21 до 45 дней';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 16),
                  child: Text(
                    'Обычно от 21 до 45 дней',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFFA6A9B5),
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Длительность менструации
                TextFormField(
                  controller: _menstruationDurationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Длительность менструации (дни)',
                  ),
                  onChanged: (_) => _resetFieldError(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите длительность менструации';
                    }
                    final days = int.tryParse(value);
                    if (days == null || days < 3 || days > 7) {
                      return 'Обычно от 3 до 7 дней';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 16),
                  child: Text(
                    'Обычно от 3 до 7 дней',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFFA6A9B5),
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Заголовок дополнительной информации
                Text(
                  'Дополнительная информация \n(для персонализации)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                // Возраст
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Возраст (лет)',
                    hintText: 'Укажите ваш возраст',
                  ),
                  onChanged: (_) => _resetFieldError(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null; // Необязательное поле
                    }
                    final age = int.tryParse(value);
                    if (age != null && (age < 14 || age > 85)) {
                      return 'От 14 до 85 лет';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 16),
                  child: Text(
                    'От 14 до 85 лет',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFFA6A9B5),
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Рост
                TextFormField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Рост (см)',
                    hintText: 'Укажите ваш рост',
                  ),
                  onChanged: (_) => _resetFieldError(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null; // Необязательное поле
                    }
                    final height = int.tryParse(value);
                    if (height != null && (height < 120 || height > 220)) {
                      return 'От 120 до 220 см';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 16),
                  child: Text(
                    'От 120 до 220 см',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFFA6A9B5),
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Вес
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Вес (кг)',
                    hintText: 'Укажите ваш вес',
                  ),
                  onChanged: (_) => _resetFieldError(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null; // Необязательное поле
                    }
                    final weight = int.tryParse(value);
                    if (weight != null && (weight < 30 || weight > 150)) {
                      return 'От 30 до 150 кг';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 16),
                  child: Text(
                    'От 30 до 150 кг',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFFA6A9B5),
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Кнопка входа
                ElevatedButton(
                  onPressed: _handleSubmit,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.calendar_today, size: 20),
                      SizedBox(width: 8),
                      Text('Войти в приложение'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
