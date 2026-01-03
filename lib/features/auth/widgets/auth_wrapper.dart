import 'package:flutter/material.dart';
import '../auth_service.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final _authService = AuthService();
  bool? _previousAuthState;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        // Показываем индикатор загрузки, пока проверяем состояние
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Определяем текущее состояние авторизации
        final isAuthenticated = snapshot.hasData && snapshot.data != null;

        // Выполняем редирект только при изменении состояния
        if (_previousAuthState != isAuthenticated) {
          _previousAuthState = isAuthenticated;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              // Если пользователь авторизован, редирект на календарь
              if (isAuthenticated) {
                Navigator.of(context).pushReplacementNamed('/calendar');
              } else {
                // Если не авторизован, редирект на страницу авторизации
                Navigator.of(context).pushReplacementNamed('/auth');
              }
            }
          });
        }

        // Показываем индикатор загрузки во время редиректа
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
