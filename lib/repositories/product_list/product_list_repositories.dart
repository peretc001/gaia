import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class ProductListRepositories {
  Future<void> getProductList() async {
    final response = await Dio().get(
      'https://jsonplaceholder.typicode.com/todos/1',
    );
    debugPrint(response.toString());
  }
}
