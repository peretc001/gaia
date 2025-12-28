import '../features/product_list/index.dart';
import '../features/product_page/index.dart';
import '../features/auth/index.dart';
import '../features/wizard/index.dart';

final routes = {
  '/products': (context) => const ProductList(title: 'Welcome to GAIA'),
  '/page': (context) => const ProductPage(),
  '/wizard': (context) => const WizardPage(),
  '/': (context) => const AuthPage(),
};
