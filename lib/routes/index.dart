import '../features/product_list/index.dart';
import '../features/product_page/index.dart';
import '../features/auth/index.dart';
import '../features/auth/widgets/auth_wrapper.dart';
import '../features/wizard/index.dart';
import '../features/calendar/index.dart';

final routes = {
  '/': (context) => const AuthWrapper(),
  '/products': (context) => const ProductList(title: 'Welcome to GAIA'),
  '/page': (context) => const ProductPage(),
  '/calendar': (context) => const CalendarPage(),
  '/wizard': (context) => const WizardPage(),
  '/auth': (context) => const AuthPage(),
  '/register': (context) => const RegisterPage(),
};
