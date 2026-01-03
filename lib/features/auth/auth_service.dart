import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Получить текущего пользователя
  User? get currentUser => _auth.currentUser;

  // Поток изменений состояния авторизации
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Вход с email и паролем
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (e) {
      throw Exception('Неожиданная ошибка: ${e.toString()}');
    }
  }

  // Регистрация с email и паролем
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleAuthException(e));
    } catch (e) {
      throw Exception('Неожиданная ошибка: ${e.toString()}');
    }
  }

  // Выход
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Обработка ошибок Firebase Auth
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Пользователь с таким email не найден';
      case 'wrong-password':
        return 'Неверный пароль';
      case 'email-already-in-use':
        return 'Email уже используется';
      case 'invalid-email':
        return 'Некорректный email';
      case 'weak-password':
        return 'Пароль слишком слабый';
      case 'user-disabled':
        return 'Пользователь заблокирован';
      case 'too-many-requests':
        return 'Слишком много попыток. Попробуйте позже';
      case 'operation-not-allowed':
        return 'Операция не разрешена';
      case 'network-request-failed':
        return 'Ошибка сети. Проверьте подключение к интернету';
      default:
        return 'Ошибка авторизации: ${e.message ?? "Неизвестная ошибка"}';
    }
  }
}

