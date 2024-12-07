//
//  CategoryScreen
//  FoodOrderApp
//
//  Created by Ranula Ranatunga on 2024-12-05.
//

import 'package:flutter/material.dart';
import 'package:food_order_app/controllers/category_controller.dart';
import 'package:food_order_app/util/app_theme.dart';
import 'package:food_order_app/views/menu_item_screen.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  final String menuId;
  const CategoryScreen({super.key, required this.menuId});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryController>(context, listen: false)
          .fetchCategories(widget.menuId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Categories', style: AppTheme.headingStyle),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Consumer<CategoryController>(
        builder: (context, categoryController, child) {
          if (categoryController.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primaryColor,
              ),
            );
          }
          if (categoryController.errorMessage != null) {
            return Center(
              child: Text(
                categoryController.errorMessage!,
                style: AppTheme.headingStyle.copyWith(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }
          if (categoryController.categories.isEmpty) {
            return const Center(
              child: Text(
                'No categories found',
                style: AppTheme.headingStyle,
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categoryController.categories.length,
            itemBuilder: (context, index) {
              final category = categoryController.categories[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: AppTheme.cardDecoration,
                child: ListTile(
                  title: Text(
                    category.name,
                    style: AppTheme.headingStyle.copyWith(fontSize: 18),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.primaryColor,
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuItemScreen(
                        categoryId: category.categoryId,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
