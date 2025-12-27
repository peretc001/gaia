import 'package:flutter/material.dart';
import 'package:gaia/features/product_list/widgets/widgets.dart';
import 'package:gaia/repositories/product_list/product_list_repositories.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key, required this.title});
  final String title;

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.separated(
        itemCount: 50,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) => ListItem(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ProductListRepositories().getProductList();
        },
        child: const Icon(Icons.download),
      ),
    );
  }
}
