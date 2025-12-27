import '../features/product_list/index.dart';
import '../features/product_page/index.dart';

final routes = {
  '/': (context) => const ProductList(title: 'Welcome to GAIA'),
  '/page': (context) => const ProductPage(),
};
