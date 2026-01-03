import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gaia/app.dart';
import 'package:gaia/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Подключение к эмуляторам в debug режиме
  if (kDebugMode) {
    try {
      // Для Android эмулятора используем 10.0.2.2 вместо localhost
      // Для iOS симулятора и других платформ используем localhost
      final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
      await FirebaseAuth.instance.useAuthEmulator(host, 9099);
      debugPrint('✅ Подключено к Firebase Auth Emulator на $host:9099');
    } catch (e) {
      debugPrint('⚠️ Не удалось подключиться к эмулятору: $e');
      debugPrint(
        '💡 Убедитесь, что эмуляторы запущены: firebase emulators:start',
      );
    }
  }

  runApp(const MyApp());
}
